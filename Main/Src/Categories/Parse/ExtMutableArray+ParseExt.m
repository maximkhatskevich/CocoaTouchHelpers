//
//  ExtMutableArray+ParseExt.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 08/08/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "ExtMutableArray+ParseExt.h"

#import "ParseHelpers.h"

@implementation ExtMutableArray (ParseExt)

+ (instancetype)newWithParseSupport
{
    ExtMutableArray *result = [[self class] new];
    
    //===
    
    result.onEqualityCheck = ^(id firstObject, id secondObject) {
        
        return [firstObject isEqualToParseObject:secondObject];
    };
    
    //===
    
    return result;
}

@end
