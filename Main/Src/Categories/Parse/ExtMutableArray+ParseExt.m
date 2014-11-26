//
//  ExtMutableArray+ParseExt.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 08/08/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "ExtMutableArray+ParseExt.h"

#import "NSObject+Helpers.h"
#import <Parse/Parse.h>

//===

@implementation ExtMutableArray (ParseExt)

+ (instancetype)arrayWithParseSupport
{
    ExtMutableArray *result = [[self class] array];
    
    //===
    
    [result
     setOnEqualityCheck:^BOOL(id leftObject, id rightObject){
         
         BOOL result = NO;
         
         //===
         
         if ([PFObject isClassOfObject:leftObject] &&
             [PFObject isClassOfObject:rightObject])
         {
             result = [((PFObject *)leftObject).objectId
                       isEqualToString:((PFObject *)rightObject).objectId];
         }
         
         //===
         
         return result;
     }];
    
    //===
    
    return result;
}

@end
