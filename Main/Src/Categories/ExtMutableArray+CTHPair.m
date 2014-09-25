//
//  ExtMutableArray+CTHPair.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 25/09/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "ExtMutableArray+CTHPair.h"

#import "CTHPair.h"
#import "NSObject+Helpers.h"

@implementation ExtMutableArray (CTHPair)

#pragma mark - Custom

- (CTHPair *)pairForKey:(id)key
{
    CTHPair *result = nil;
    
    //===
    
    for (CTHPair *item in self)
    {
        if ([CTHPair isClassOfObject:item] &&
            [item.key isEqual:key])
        {
            result = item;
            break;
        }
    }
    
    //===
    
    return result;
}

@end
