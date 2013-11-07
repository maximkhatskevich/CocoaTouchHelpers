//
//  NSMutableArray+ParseHelpers.h
//  MyHelpers
//
//  Created by Maxim Khatskevich on 11/8/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface NSMutableArray (ParseHelpers)

- (void)safeAddUniqueParseObject:(PFObject *)object;

@end
