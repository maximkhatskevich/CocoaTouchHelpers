//
//  ResultContainer.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 1/25/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "ResultContainer.h"

@interface ResultContainer ()

@property (strong, nonatomic) id content;

@property BOOL isFilled;

@end

@implementation ResultContainer

#pragma mark - Property accessors

- (BOOL)shouldWait
{
    return !self.isFilled;
}

#pragma mark - Overrided methods

- (id)init
{
    self = [super init];
    
    //===
    
    if (self)
    {
        _isFilled = NO;
    }
    
    //===
    
    return self;
}

- (void)configureWithObject:(id)object
{
    self.content = object;
    self.isFilled = YES;
}

#pragma mark - Generic

- (void)wait
{
    while (self.shouldWait)
    {
        // NSLog(@"Waiting...");
    }
}

- (void)reset
{
    self.isFilled = NO;
    self.content = nil;
}

@end
