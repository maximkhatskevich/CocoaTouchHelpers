//
//  CTHPromise.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 30/11/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GlobalBase.h"

//===

#define CTHNewPromise CTHPromise *promise = [CTHPromise new]

//===

//@class CTHPromise;

typedef id (^CTHPromiseInitialBlock)(void);
typedef id (^CTHPromiseGenericBlock)(id object);
typedef void (^CTHPromiseFinalBlock)(id object);

//===

@interface CTHPromise : NSObject

+ (void)setDefaultQueue:(NSOperationQueue *)defaultQueue;

+ (instancetype)execute:(CTHPromiseInitialBlock)block;

- (instancetype)then:(CTHPromiseGenericBlock)block;
- (instancetype)finally:(CTHPromiseFinalBlock)block;
- (instancetype)error:(CTHErrorBlock)block;

- (void)cancel;

@end
