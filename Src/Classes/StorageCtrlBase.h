//
//  StorageCtrlBase.h
//  MyHelpers
//
//  Created by Maxim Khatskevich on 11/10/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Helper Category

@class StorageCtrlBase;

@interface NSObject (StorageCtrlBaseExt)

@property (readonly, nonatomic) StorageCtrlBase *storageCtrl;

@end

#pragma mark - Class

@interface StorageCtrlBase : NSObject

+ (instancetype)sharedInstance;

@end