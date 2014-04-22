//
//  NSObject+Helpers.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "NSObject+Helpers.h"

#import "MacrosBase.h"

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
    // any kind of initial configuration should be done here
}

- (void)reConfigure
{
    // update here only what may be changed...
}

- (void)applyItem:(id)item
{
    // any item selection events should be processed here
}

- (NSString *)stringValueForKey:(NSString *)key
{
    NSString *result = @"N/A";
    
    //===
    
    if (isObjectForKeySupported(self))
    {
        id obj = [(id)self objectForKey:key];
        
        if ([obj isKindOfClass:[NSString class]]) // not nil & string
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
        
        if ([definitionStr isKindOfClass:[NSString class]])
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

- (NSString *)stringFromDateForKey:(NSString *)dateKey withFormat:(NSString *)format
{
    NSString *result = nil;
    
    //===
    
    if (isObjectForKeySupported(self))
    {
        NSDate *val = [(id)self objectForKey:dateKey];
        
        if (val)
        {
            static NSDateFormatter *dateFormatter = nil;
            static dispatch_once_t onceToken;
            
            dispatch_once(&onceToken, ^{
                
                dateFormatter = [NSDateFormatter new];
                dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
            });
            
            //===
            
            [dateFormatter setDateFormat:format];
            result = [dateFormatter stringFromDate:val];
        }
    }
    
    //===
    
    return result;
}

+ (BOOL)isClassOfObject:(id)objectToCheck
{
    return isClassOfObject([self class], objectToCheck);
}

@end
