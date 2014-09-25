//
//  NSArray+CTHPair.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 25/09/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTHPair;

@interface NSArray (CTHPair)

- (CTHPair *)pairForKey:(id)key;

@end
