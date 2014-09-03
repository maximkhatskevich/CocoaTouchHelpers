//
//  NSObject+ReturnExtension.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 03/09/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "NSObject+ReturnExtension.h"
#import <objc/runtime.h>

//===

static void *CTHOnReturnBlockKey;

//===

@implementation NSObject (ReturnExtension)

#pragma mark - Property accessors

- (CTHReturnBlock)onReturn
{
    return objc_getAssociatedObject(self, &CTHOnReturnBlockKey);
}

- (void)setOnReturn:(CTHReturnBlock)newValue
{
    objc_setAssociatedObject(self,
                             &CTHOnReturnBlockKey,
                             newValue,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Custom

- (void)returnWithValue:(id)aValue
{
    CTHReturnBlock block = self.onReturn;
    
    if (block)
    {
        block(aValue);
    }
}

#pragma mark - IBActions

- (IBAction)returnDefaultHandler:(id)sender
{
    CTHReturnBlock block = self.onReturn;
    
    if (block)
    {
        block(nil);
    }
}

@end
