//
//  GlobalBase.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 11/4/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#ifndef CocoaTouchHelpers_GlobalBase_h
#define CocoaTouchHelpers_GlobalBase_h

//===

typedef void (^SimpleBlock)(void);

typedef void (^OperationCompletionBlock)(NSError *error);

typedef void (^BoolResultBlock)(BOOL successful, NSError *error);
typedef void (^IdResultBlock)(id result, NSError *error);
typedef void (^ObjectResultBlock)(NSObject *result, NSError *error);
typedef void (^NumberResultBlock)(NSNumber *result, NSError *error);
typedef void (^DataResultBlock)(NSData *result, NSError *error);
typedef void (^ArrayResultBlock)(NSArray *result, NSError *error);
typedef void (^DictionaryResultBlock)(NSDictionary *result, NSError *error);

//===

// must be defined in the application
extern NSTimeInterval defaultAnimationDuration;
extern UIViewAnimationOptions defaultAnimationOptions;

//===

#endif
