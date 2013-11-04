//
//  Base64.h
//  SixHelpers
//
//  Created by Maxim Khatskevich on 6/26/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject

+ (NSString*) encode:(const void*) input length:(size_t) length;
+ (NSString*) encode:(NSData*) rawBytes;
+ (NSData*) decode:(const char*) string length:(size_t) inputLength;
+ (NSData*) decode:(NSString*) string;

/** Decodes the URL-safe Base64 variant that uses '-' and '_' instead of '+' and '/', and omits trailing '=' characters. */
+ (NSData*) decodeURLSafe: (NSString*)string;
+ (NSData*) decodeURLSafe: (const char*)string length: (size_t)inputLength;

@end
