//
//  NSArray+Helpers.h
//  Spotlight-SE-iOS
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Helpers)

@property (readonly, nonatomic) id firstObject;

- (BOOL)isValidIndex:(NSUInteger)indexForTest;
- (id)safeObjectAtIndex:(NSUInteger)index;

@end
