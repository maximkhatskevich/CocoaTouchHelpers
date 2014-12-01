//
//  CTHPromise.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 30/11/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "CTHPromise.h"

#import "MacrosBase.h"
#import "CTHMutableArray.h"
#import "NSObject+Helpers.h"
#import "NSMutableArray+Helpers.h"

//===

static __weak NSOperationQueue *__defaultQueue;
static CTHErrorBlock __defaultErrorBlock;

//===

@interface CTHPromise ()

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSBlockOperation *currentOperation;

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) id selfLink;

@property (copy, nonatomic) CTHPromiseFinalBlock finalBlock;
@property (copy, nonatomic) CTHErrorBlock errorBlock;

@end

//===

@implementation CTHPromise

#pragma mark - Overrided methods

+ (void)initialize
{
    [super initialize];
    
    //===
    
    [self setDefaultQueue:[NSOperationQueue currentQueue]];
    [self setDefaultErrorHandler:nil];
}

- (instancetype)init
{
    self = [super init];
    
    //===
    
    if (self)
    {
        self.targetQueue = __defaultQueue;
        
        //===
        
        if (__defaultErrorBlock)
        {
            self.errorBlock = __defaultErrorBlock;
        }
        else
        {
            weakSelfMacro;
            
            [self
             setErrorBlock:^(NSError *error) {
                 
                 NSLog(@"Sequence named >> %@ << error: %@",
                       weakSelf.name,
                       error);
             }];
        }
        
        //===
        
        self.items = [NSMutableArray array];
    }
    
    //===
    
    return self;
}

#pragma mark - Global

+ (void)setDefaultQueue:(NSOperationQueue *)defaultQueue
{
    __defaultQueue = defaultQueue;
}

+ (void)setDefaultErrorHandler:(CTHErrorBlock)defaultErrorBlock
{
    __defaultErrorBlock = defaultErrorBlock;
}

#pragma mark - Custom

+ (instancetype)newWithName:(NSString *)sequenceName
{
    CTHPromise *result = [self.class new];
    
    //===
    
    result.name = sequenceName;
    
    //===
    
    return result;
}

+ (instancetype)execute:(CTHPromiseInitialBlock)firstOperation
{
    return
    [self.class.new
     then:^(id object) {
         
         id result = nil;
         
         //===
         
         if (block)
         {
             result = block();
         }
         
         //===
         
         return result;
    }];
}

- (instancetype)then:(CTHPromiseGenericBlock)operation
{
    [self.items safeAddObject:operation];
    
    //===
    
    return self;
}

- (instancetype)finally:(CTHPromiseFinalBlock)completion
{
    self.finalBlock = completion;
    
    //===
    
    if (self.items.count)
    {
        self.selfLink = self;
    }
    
    //===
    
    [self start];
    
    //===
    
    return self;
}

- (instancetype)errorHandler:(CTHErrorBlock)errorHandling
{
    self.errorBlock = errorHandling;
    
    //===
    
    return self;
}

- (void)cancel
{
    [self.currentOperation cancel];
}

#pragma mark - Internal

- (void)start
{
    // make sure we start sequence on main queue:
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.items.count)
        {
            [self executeNextWithObject:nil];
        }
    });
}

- (void)executeNextWithObject:(id)previousResult
{
    // NOTE: this mehtod is supposed to be called on main queue
    
    if (self.items.count)
    {
        // regular block
        
        if (self.targetQueue)
        {
            CTHPromiseGenericBlock block = [self.items objectAtIndex:0];
            [self.items removeObjectAtIndex:0];
            
            //===
            
            thisOperationMacro;
            thisOperation = self.currentOperation = [NSBlockOperation new];
            
            [thisOperation
             addExecutionBlock:^{
                 
                 id result = block(previousResult);
                 
                 //===
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     self.currentOperation = nil;
                     
                     //===
                     
                     if (!thisOperation.isCancelled)
                     {
                         // return
                         
                         if ([NSError isClassOfObject:result])
                         {
                             [self reportError:result];
                         }
                         else
                         {
                             [self executeNextWithObject:result];
                         }
                     }
                 });
             }];
            
            //===
            
            [self.targetQueue addOperation:thisOperation];
        }
        else
        {
            NSLog(@"WARNING: Can't execute block sequence, .targetQueue hasn't been set.");
        }
    }
    else
    {
        [self executeFinal:previousResult];
    }
}

- (void)executeFinal:(id)lastResult
{
    if (self.finalBlock)
    {
        // final block
        // run on main queue
        
        self.finalBlock(lastResult);
    }
    
    //===
    
    // release self
    
    self.selfLink = nil;
}

- (void)reportError:(NSError *)error
{
    if (self.errorBlock)
    {
        // error block
        // run on main queue
        
        self.errorBlock(error);
    }
    
    //===
    
    // release self
    
    self.selfLink = nil;
}

@end
