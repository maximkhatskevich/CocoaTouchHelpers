//
//  NSObject+Observers.m
//  Rezzie
//
//  Created by Maxim Khatskevich on 12/10/13.
//  Copyright (c) 2013 SixAgency. All rights reserved.
//

#import "NSObject+Observers.h"
#import <objc/runtime.h>

static void *ObserverListKey;

@implementation NSObject (Observers)

#pragma mark - Property accessors

- (NSMutableArray *)observerList
{
    @synchronized(self)
    {
        NSMutableArray *result =
        objc_getAssociatedObject(self, &ObserverListKey);
        
        //===
        
        if (!result)
        {
            result = [NSMutableArray array];
            
            objc_setAssociatedObject(self,
                                     &ObserverListKey,
                                     result,
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        //===
        
        return result;
    }
}

#pragma mark - Helpers

- (void)removeObservers
{
    [self.observerList makeObjectsPerformSelector:@selector(stopObserving)];
    [self.observerList removeAllObjects];
}

@end
