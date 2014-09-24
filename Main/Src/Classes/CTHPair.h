//
//  CTHPair.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 24/09/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTHPair : NSObject

@property (strong, nonatomic) id key;
@property (strong, nonatomic) id value;

+ (instancetype)pairWithKey:(id)key value:(id)value;

@end
