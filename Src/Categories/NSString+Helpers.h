//
//  NSString+Helpers.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 5/25/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *retina4postfix;

@interface NSString (Helpers)

@property (readonly) BOOL isValidEmail;
@property (readonly) BOOL firstCharacterIsVowel;
@property (readonly) NSString *recommendedArticle;
@property (readonly) NSString *withRecommendedArticle;

+ (BOOL)stringIsValidEmail:(NSString *)stringToCheck;

+ (NSString *)md5:(NSString *)str;
- (NSString *)retina4NameIfNeeded;
-(NSString *)encodeURL;

+ (NSString*)base64forData:(NSData*)theData;
- (NSString*)encodeBase64;

- (NSString *)stringByAppendingDeviceType;
- (NSString *)stringByAppendingScreenType;

@end
