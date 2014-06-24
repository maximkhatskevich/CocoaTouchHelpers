//
//  ResultContainer.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 1/25/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "ResultContainer.h"

@interface ResultContainer ()
{
    dispatch_semaphore_t _semaphore;
}

@property (strong, nonatomic) id content;

@end

@implementation ResultContainer

#pragma mark - Overrided methods

- (id)init
{
    self = [super init];
    
    //===
    
    if (self)
    {
        [self reset];
    }
    
    //===
    
    return self;
}

- (void)configureWithObject:(id)object
{
    self.content = object;
    dispatch_semaphore_signal(_semaphore);
}

#pragma mark - Custom

- (void)reset
{
    _content = nil;
    _semaphore = dispatch_semaphore_create(0);
}

- (void)wait
{
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
}

@end
