//
//  CTHPromise.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 30/11/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "CTHPromise.h"

//===

static __weak NSOperationQueue *__defaultQueue;

//===

@implementation CTHPromise
{
    NSOperationQueue *_targetQueue;
}

#pragma mark - Overrided methods

- (instancetype)init
{
    self = [super init];
    
    //===
    
    if (self)
    {
        
        _targetQueue = __defaultQueue;
        
    }
    
    //===
    
    return self;
}

#pragma mark - Custom

+ (void)setDefaultQueue:(NSOperationQueue *)defaultQueue
{
    __defaultQueue = defaultQueue;
}

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
    return self;
}

- (instancetype)finally:(CTHPromiseFinalBlock)block
{
    return self;
}

- (instancetype)error:(CTHErrorBlock)block
{
    return self;
}

@end
