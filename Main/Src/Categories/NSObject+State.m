//
//  NSObject+State.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 12/10/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "NSObject+State.h"
#import <objc/runtime.h>

//===

static void *CTHStateKey;
static void *CTHOnStateWillChangeKey;
static void *CTHOnStateDidChangeKey;

//===

@implementation NSObject (State)

#pragma mark - Property accessors

- (NSInteger)state
{
//    @synchronized(self)
//    {
        NSInteger result = kUnknownObjectState;
        
        //===
        
        id state =
        objc_getAssociatedObject(self, &CTHStateKey);
        
        if ([state isKindOfClass:[NSNumber class]])
        {
            result = ((NSNumber *)state).integerValue;
        }
        
        //===
        
        return result;
//    }
}

- (void)setState:(NSInteger)newValue
{
//    @synchronized(self)
//    {
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
                                         &CTHStateKey,
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
//    }
}

- (StateWillChangeBlock)onStateWillChange
{
    return objc_getAssociatedObject(self, &CTHOnStateWillChangeKey);
}

- (void)setOnStateWillChange:(StateWillChangeBlock)newValue
{
    objc_setAssociatedObject(self,
                             &CTHOnStateWillChangeKey,
                             newValue,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (StateDidChangeBlock)onStateDidChange
{
    return objc_getAssociatedObject(self, &CTHOnStateDidChangeKey);
}

- (void)setOnStateDidChange:(StateDidChangeBlock)newValue
{
    objc_setAssociatedObject(self,
                             &CTHOnStateDidChangeKey,
                             newValue,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)switchToState:(NSInteger)targetState
{
    [self switchToState:targetState completion:nil];
}

- (void)switchToState:(NSInteger)targetState completion:(SimpleBlock)completion
{
    // needs to be implemented in a custom class
}

@end
