//
//  NSArray+ParseHelpers.h
//  SixHelpers
//
//  Created by Maxim Khatskevich on 6/23/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ParseHelpers)

- (BOOL)containsParseObject:(PFObject *)object;
- (NSInteger)indexOfParseObject:(PFObject *)object;

@end
