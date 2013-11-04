//
//  NSObject+ParseHelpers.m
//  SixHelpers
//
//  Created by Maxim Khatskevich on 6/23/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "NSObject+ParseHelpers.h"

@implementation NSObject (ParseHelpers)

- (BOOL)isEqualToParseObject:(PFObject *)object
{
    BOOL result = NO;
    
    //===
    
    if ([self isKindOfClass:[PFObject class]])
    {
        result = [((PFObject *)self).objectId isEqualToString:object.objectId];
    }
    
    //===
    
    return result;
}

@end
