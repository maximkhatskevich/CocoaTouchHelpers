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
@property (strong, nonatomic) NSError *error;

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
    // optionally you can call this method,
    // it means that no error occured,
    // just return result content
    
    [self fillWithContent:object andError:nil];
}

#pragma mark - Generic

- (void)wait
{
    while (self.shouldWait)
    {
        // NSLog(@"Waiting...");
    }
}

- (void)fillWithContent:(id)content andError:(NSError *)error
{
    self.content = content;
    self.error = error;
    
    self.isFilled = YES;
}

- (void)reset
{
    self.isFilled = NO;
    
    self.content = nil;
    self.error = nil;
}

@end
