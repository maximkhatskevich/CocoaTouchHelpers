//
//  StorageCtrlBase.m
//  MyHelpers
//
//  Created by Maxim Khatskevich on 11/10/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "StorageCtrlBase.h"

#pragma mark - Helper Category

@implementation NSObject (StorageCtrlBaseExt)

#pragma mark - Property accessors

- (StorageCtrlBase *)storageCtrl
{
    return [StorageCtrlBase sharedInstance];
}

@end

#pragma mark - Class

@implementation StorageCtrlBase

#pragma mark - Helpers

+ (instancetype)sharedInstance
{
    static StorageCtrlBase *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [StorageCtrlBase new];
    });
    
    //===
    
    return _sharedInstance;
}

@end
