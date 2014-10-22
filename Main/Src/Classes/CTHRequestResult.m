//
//  CTHRequestResult.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 22/10/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "CTHRequestResult.h"

//===

@interface CTHRequestResult ()

@property (strong, nonatomic) id content;

@end

//===

@implementation CTHRequestResult
{
    dispatch_semaphore_t _semaphore;
}

#pragma mark - Overrided methods

- (id)init
{
    self = [super init];
    
    //===
    
    if (self)
    {
        _semaphore = dispatch_semaphore_create(0);
    }
    
    //===
    
    return self;
}

- (void)configureWithObject:(id)object
{
    if (object)
    {
        self.content = object;
    }
}

#pragma mark - Custom

- (void)wait
{
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
}

- (void)allowToProceed
{
    dispatch_semaphore_signal(_semaphore);
}

@end
