//
//  NSObject+State.m
//  MyHelpers
//
//  Created by Maxim Khatskevich on 12/10/13.
//  Copyright (c) 2013 SixAgency. All rights reserved.
//

#import "NSObject+State.h"
#import <objc/runtime.h>

//===

static void *StateKey;
static void *OnStateWillChangeKey;
static void *OnStateDidChangeKey;

//===

@implementation NSObject (State)

#pragma mark - Property accessors

- (NSInteger)state
{
    @synchronized(self)
    {
        NSInteger result = kObjectStateUnknown;
        
        //===
        
        id state =
        objc_getAssociatedObject(self, &StateKey);
        
        if ([state isKindOfClass:[NSNumber class]])
        {
            result = ((NSNumber *)state).integerValue;
        }
        
        //===
        
        return result;
    }
}

- (void)setState:(NSInteger)newValue
{
    @synchronized(self)
    {
        NSInteger currentValue = self.state;
        
        if (currentValue != newValue)
        {
            BOOL allowChange = YES;
            StateWillChangeBlock onStateWillChange = self.onStateWillChange;
            
            if (onStateWillChange)
            {
                allowChange = onStateWillChange(currentValue, newValue);
            }
            
            //===
            
            if (allowChange)
            {
                objc_setAssociatedObject(self,
                                         &StateKey,
                                         [NSNumber numberWithInteger:newValue],
                                         OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                
                //===
                
                StateDidChangeBlock onStateDidChange = self.onStateDidChange;
                
                if (onStateDidChange)
                {
                    // 'currentValue' is 'previousValue' now
                    // 'newValue' is 'currentValue' now
                    
                    onStateDidChange(currentValue, newValue);
                }
            }
        }
    }
}

- (StateWillChangeBlock)onStateWillChange
{
    return objc_getAssociatedObject(self, &OnStateWillChangeKey);
}

- (void)setOnStateWillChange:(StateWillChangeBlock)newValue
{
    objc_setAssociatedObject(self,
                             &OnStateWillChangeKey,
                             newValue,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (StateDidChangeBlock)onStateDidChange
{
    return objc_getAssociatedObject(self, &OnStateDidChangeKey);
}

- (void)setOnStateDidChange:(StateDidChangeBlock)newValue
{
    objc_setAssociatedObject(self,
                             &OnStateDidChangeKey,
                             newValue,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
