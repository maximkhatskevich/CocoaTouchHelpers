//
//  AdvancedList+ParseHelpers.h
//  SixHelpers
//
//  Created by Maxim Khatskevich on 6/28/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "AdvancedList.h"
#import <Parse/Parse.h>

@interface AdvancedList (ParseHelpers)

- (void)setItemCurrentWithParseObject:(PFObject *)object;

@end
