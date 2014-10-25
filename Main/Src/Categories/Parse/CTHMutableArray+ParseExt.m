//
//  CTHMutableArray+ParseExt.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 25/10/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "CTHMutableArray+ParseExt.h"

#import "NSObject+ParseHelpers.h"

//===

@implementation CTHMutableArray (ParseExt)

+ (instancetype)arrayWithParseSupport
{
    CTHMutableArray *result = [[self class] array];
    
    //===
    
    [result setOnEqualityCheck:^BOOL(id leftObject, id rightObject){
        
        return [leftObject isEqualToParseObject:rightObject];
     }];
    
    //===
    
    return result;
}

@end
