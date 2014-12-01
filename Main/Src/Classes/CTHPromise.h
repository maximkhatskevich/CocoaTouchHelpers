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
typedef id (^CTHPromiseGenericBlock)(id previousResult);
typedef void (^CTHPromiseFinalBlock)(id lastResult);

//===

@interface CTHPromise : NSObject

@property (weak, nonatomic) NSOperationQueue *targetQueue;

+ (void)setDefaultQueue:(NSOperationQueue *)defaultQueue;
+ (void)setDefaultErrorHandler:(CTHErrorBlock)defaultErrorBlock;

+ (instancetype)newWithName:(NSString *)sequenceName;
+ (instancetype)execute:(CTHPromiseInitialBlock)firstOperation;

- (instancetype)then:(CTHPromiseGenericBlock)operation;
- (instancetype)finally:(CTHPromiseFinalBlock)completion;
- (instancetype)errorHandler:(CTHErrorBlock)errorHandling;

- (void)cancel;

@end
