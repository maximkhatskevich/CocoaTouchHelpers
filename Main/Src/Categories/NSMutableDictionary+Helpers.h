//
//  NSMutableDictionary+Helpers.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 5/9/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Helpers)

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end
