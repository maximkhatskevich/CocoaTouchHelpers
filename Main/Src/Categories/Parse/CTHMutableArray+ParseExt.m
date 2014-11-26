//
//  CTHMutableArray+ParseExt.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 25/10/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "CTHMutableArray+ParseExt.h"

#import "NSObject+Helpers.h"
#import <Parse/Parse.h>

//===

@implementation CTHMutableArray (ParseExt)

+ (instancetype)arrayWithParseSupport
{
    CTHMutableArray *result = [[self class] array];
    
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
