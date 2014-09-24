//
//  CTHPair.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 24/09/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "CTHPair.h"

@implementation CTHPair

#pragma mark - Custom

+ (instancetype)pairWithKey:(id)key value:(id)value
{
    CTHPair *result = [self new];
    
    //===
    
    result.key = key;
    result.value = value;
    
    //===
    
    return result;
}

@end
