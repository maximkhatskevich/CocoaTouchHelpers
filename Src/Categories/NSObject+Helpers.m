//
//  NSObject+Helpers.m
//  Spotlight-SE-iOS
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "NSObject+Helpers.h"

@implementation NSObject (Helpers)

#pragma mark - Helpers

+ (id)objectWithProperties:(NSDictionary *)properties
{
    id result = nil;
    
    //=== create entity:
    
    result = [[self class] new];
    
    //=== populate properties in instance:
    
    if (result && properties)
    {
        [result setValuesForKeysWithDictionary:properties];
    }
    
    //===
    
    return result;
}

- (void)configureWithProperties:(NSDictionary *)properties
{
    if (properties)
    {
        [self setValuesForKeysWithDictionary:properties];
    }
}

+ (id)newWithObject:(id)object
{
    id result = [[self class] new];
    
    //===
    
    [result configureWithObject:object];
    
    //===
    
    return result;
}

- (void)configureWithObject:(id)object
{
    //
}

- (void)reConfigure
{
    // update here only what may be changed...
}

- (void)applyItem:(id)item
{
    //
}

- (NSString *)stringValueForKey:(NSString *)key
{
    NSString *result = @"N/A";
    
    //===
    
    if (isObjectForKeySupported(self))
    {
        id obj = [(id)self objectForKey:key];
        
        if ([obj isKindOfClass:[NSString class]]) // not til & string
        {
            result = (NSString *)obj;
        }
    }
    
    //===
    
    return result;
}

- (NSDictionary *)dictFromJSONForKey:(NSString *)key
{
    return (NSDictionary *)[self objectFromJSONForKey:key];
}

- (NSArray *)arrayFromJSONForKey:(NSString *)key
{
    return (NSArray *)[self objectFromJSONForKey:key];
}

- (id)objectFromJSONForKey:(NSString *)key
{
    id result = nil;
    
    //==
    
    if (isObjectForKeySupported(self))
    {
        NSError *jsonError;
        
        NSString *definitionStr = [(id)self objectForKey:key];
        
        if (definitionStr)
        {
            result =
            [NSJSONSerialization
             JSONObjectWithData:[definitionStr dataUsingEncoding:NSUTF8StringEncoding]
             options:NSJSONReadingAllowFragments error:&jsonError];
        }
    }
    
    //===
    
    return result;
}

@end
