//
//  ResultContainer.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 1/25/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "ResultContainer.h"

#import "NSObject+Helpers.h"

@interface ResultContainer ()
{
    dispatch_semaphore_t _semaphore;
}

@property (strong, nonatomic) id content;
@property (strong, nonatomic) NSError *error;

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
    if ([NSError isClassOfObject:object])
    {
        self.error = object;
    }
    else if (object)
    {
        self.content = object;
    }
    
    //===
    
    dispatch_semaphore_signal(_semaphore);
}

#pragma mark - Property accessors

- (NSDictionary *)contentDict
{
    NSDictionary *result = nil;
    
    //===
    
    if ([NSDictionary isClassOfObject:self.content])
    {
        result = self.content;
    }
    
    //===
    
    return result;
}

- (NSArray *)contentArray
{
    NSArray *result = nil;
    
    //===
    
    if ([NSArray isClassOfObject:self.content])
    {
        result = self.content;
    }
    
    //===
    
    return result;
}

#pragma mark - Custom

- (void)reset
{
    _content = nil;
    _error = nil;
    _semaphore = dispatch_semaphore_create(0);
}

- (void)wait
{
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
}

@end
