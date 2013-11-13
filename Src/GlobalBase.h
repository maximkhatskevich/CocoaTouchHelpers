//
//  GlobalBase.h
//  MyHelpers
//
//  Created by Maxim Khatskevich on 11/4/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#ifndef MyHelpers_GlobalBase_h
#define MyHelpers_GlobalBase_h

//===

typedef void (^SimpleBlock)(void);

typedef void (^OperationCompletionBlock)(NSError *error);

typedef void (^IdResultBlock)(id result, NSError *error);
typedef void (^ObjectResultBlock)(NSObject *result, NSError *error);
typedef void (^NumberResultBlock)(NSNumber *result, NSError *error);
typedef void (^DataResultBlock)(NSData *result, NSError *error);
typedef void (^ArrayResultBlock)(NSArray *result, NSError *error);
typedef void (^DictionaryResultBlock)(NSDictionary *result, NSError *error);

//=== must be defined in an application which use this header:

extern NSTimeInterval defaultAnimationDuration;

//===

#endif
