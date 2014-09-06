//
//  ResultContainer.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 1/25/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

#define resultContainerMacro ResultContainer *result = [ResultContainer new];

@interface ResultContainer : NSObject

@property (readonly, nonatomic) id content;
@property (readonly, nonatomic) NSError *error;

// helpers:
@property (readonly, nonatomic) NSDictionary *contentDict;
@property (readonly, nonatomic) NSArray *contentArray;

- (void)reset;
- (void)wait;

@end
