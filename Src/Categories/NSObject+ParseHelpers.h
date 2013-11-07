//
//  NSObject+ParseHelpers.h
//  MyHelpers
//
//  Created by Maxim Khatskevich on 6/23/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface NSObject (ParseHelpers)

- (BOOL)isEqualToParseObject:(PFObject *)object;

@end
