//
//  NSArray+ParseHelpers.m
//  SixHelpers
//
//  Created by Maxim Khatskevich on 6/23/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "NSArray+ParseHelpers.h"

@implementation NSArray (ParseHelpers)

- (BOOL)containsParseObject:(PFObject *)object
{
    BOOL result = NO;
    
    //===
    
    for (id item in self)
    {
        if ([item isKindOfClass:[PFObject class]])
        {
            if ([((PFObject *)item).objectId isEqualToString:object.objectId])
            {
                result = YES;
                break;
            }
        }
    }
    
    //===
    
    return result;
}

- (NSInteger)indexOfParseObject:(PFObject *)object
{
    NSInteger result = NSNotFound;
    
    //===
    
    for (NSInteger i = 0; i < self.count; i++)
    {
        if ([self[i] isKindOfClass:[PFObject class]])
        {
            if ([((PFObject *)self[i]).objectId isEqualToString:object.objectId])
            {
                result = i;
                break;
            }
        }
    }
    
    //===
    
    return result;
}

@end
