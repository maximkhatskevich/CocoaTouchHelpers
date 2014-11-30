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

//===

@interface CTHPromise ()

@property (weak, nonatomic) NSOperationQueue *targetQueue;
@property (strong, nonatomic) NSBlockOperation *currentOperation;

@property (strong, nonatomic) CTHMutableArray *items;
@property (strong, nonatomic) id selfLink;

@property (strong, nonatomic) CTHPromiseFinalBlock finalBlock;
@property (strong, nonatomic) CTHErrorBlock errorBlock;

@end

//===

@implementation CTHPromise

#pragma mark - Overrided methods

+ (void)initialize
{
    [self setDefaultQueue:[NSOperationQueue currentQueue]];
}

- (instancetype)init
{
    self = [super init];
    
    //===
    
    if (self)
    {
        self.targetQueue = __defaultQueue;
        
        //===
        
        self.items = [CTHMutableArray array];
        
//        [self.items
//         subscribe:self
//         onDidChangeContent:^(CTHMAChangeParamSet *params) {
//             
//             
//         }];
    }
    
    //===
    
    return self;
}

#pragma mark - Global

+ (void)setDefaultQueue:(NSOperationQueue *)defaultQueue
{
    __defaultQueue = defaultQueue;
}

#pragma mark - Dot syntax suport

+ (CTHPromise *(^)(CTHPromiseInitialBlock block))execute
{
    return ^CTHPromise *(CTHPromiseInitialBlock block) {
        
        return [CTHPromise execute:block];
    };
}

- (CTHPromise *(^)(CTHPromiseGenericBlock block))then
{
    return ^CTHPromise *(CTHPromiseGenericBlock block) {
        
        return [self then:block];
    };
}

#pragma mark - Regular syntax suport

+ (instancetype)execute:(CTHPromiseInitialBlock)block
{
    return
    [[self.class new]
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

- (instancetype)then:(CTHPromiseGenericBlock)block
{
    [self.items safeAddObject:block];
    
    //===
    
    return self;
}

- (instancetype)finally:(CTHPromiseFinalBlock)block
{
    self.finalBlock = block;
    
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

- (instancetype)error:(CTHErrorBlock)block
{
    self.errorBlock = block;
    
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
    if (self.items.count)
    {
        [self executeNextWithObject:nil];
    }
}

- (void)executeNextWithObject:(id)previousResult
{
    if (self.items.count)
    {
        // regular block
        
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
        [self executeFinal:previousResult];
    }
}

- (void)executeFinal:(id)previousResult
{
    if (self.finalBlock)
    {
        // final block
        // run on main queue
        
        self.finalBlock(previousResult);
        
        //===
        
        // release self
        
        self.selfLink = nil;
    }
}

- (void)reportError:(NSError *)error
{
    if (self.errorBlock)
    {
        // error block
        // run on main queue
        
        self.errorBlock(error);
        
        //===
        
        // release self
        
        self.selfLink = nil;
    }
}

@end
