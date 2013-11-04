//
//  NSObject+Helpers.h
//  Spotlight-SE-iOS
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Helpers)

+ (id)objectWithProperties:(NSDictionary *)properties;
- (void)configureWithProperties:(NSDictionary *)properties;

+ (id)newWithObject:(id)object;

- (void)configureWithObject:(id)object; // initial/base instance configuration
- (void)reConfigure;

- (void)applyItem:(id)item; // it means this item has been selected, has been made "current"

- (NSString *)stringValueForKey:(NSString *)key;

- (NSDictionary *)dictFromJSONForKey:(NSString *)key;
- (NSArray *)arrayFromJSONForKey:(NSString *)key;
- (id)objectFromJSONForKey:(NSString *)key;

@end
