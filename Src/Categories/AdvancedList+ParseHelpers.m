//
//  AdvancedList+ParseHelpers.m
//  MyHelpers
//
//  Created by Maxim Khatskevich on 6/28/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "AdvancedList+ParseHelpers.h"
#import "NSArray+ParseHelpers.h"

@implementation AdvancedList (ParseHelpers)

- (void)setItemCurrentWithParseObject:(PFObject *)object
{
    NSInteger targetIndex = [self.items indexOfParseObject:object];
    [self setItemCurrentByIndex:targetIndex];
}

@end
