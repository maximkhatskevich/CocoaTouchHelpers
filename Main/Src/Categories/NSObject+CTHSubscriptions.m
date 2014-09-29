//
//  NSObject+CTHSubscriptions.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 30/09/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "NSObject+CTHSubscriptions.h"

#import <objc/runtime.h>
#import "NSObject+Helpers.h"

//===

static void *CTHSubscriptionsKey;

//===

@implementation NSObject (CTHSubscriptions)

#pragma mark - Custom

- (NSMutableDictionary *)subscriptions
{
    NSMutableDictionary *result = objc_getAssociatedObject(self, &CTHSubscriptionsKey);
    
    //===
    
    if (![NSMutableDictionary isClassOfObject:result])
    {
        result = [NSMutableDictionary dictionary];
        
        // lets cache right way
        
        objc_setAssociatedObject(self,
                                 &CTHSubscriptionsKey,
                                 result,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    //===
    
    return result;
}

- (NSMapTable *)subscriptionForKey:(NSString *)subscriptionKey
{
    NSMapTable *result = [self subscriptions][subscriptionKey];
    
    //===
    
    if (![NSMapTable isClassOfObject:result])
    {
        result =
        [NSMapTable
         mapTableWithKeyOptions:NSPointerFunctionsWeakMemory
         valueOptions:NSPointerFunctionsCopyIn];
        
        [self subscriptions][subscriptionKey] = result;
    }
    
    //===
    
    return result;
}

@end
