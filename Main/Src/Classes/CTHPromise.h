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

@class CTHPromise;

typedef id (^CTHPromiseInitialBlock)(void);
typedef id (^CTHPromiseGenericBlock)(id object);
typedef CTHPromise *(^CTHPromiseFinalBlock)(id);

//===

@interface CTHPromise : NSObject

+ (void)setDefaultQueue:(NSOperationQueue *)defaultQueue;

+ (instancetype)execute:(CTHPromiseInitialBlock)block;

- (instancetype)then:(CTHPromiseGenericBlock)block;
//- (instancetype)finally:(CTHPromiseFinalBlock)block;
- (CTHPromiseFinalBlock)finally;
- (instancetype)error:(CTHErrorBlock)block;

@end
