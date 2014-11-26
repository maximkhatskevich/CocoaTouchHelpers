//
//  NSString+Helpers.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 5/25/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "NSString+Helpers.h"

#import <UIKit/UIKit.h>
#import "MacrosBase.h"
#import <CommonCrypto/CommonDigest.h>

NSString *retina4postfix = @"-568h";

@implementation NSString (Helpers)

#pragma mark - Property accessors

- (BOOL)isValidEmail
{
    return [[self class] stringIsValidEmail:self];
}

- (BOOL)firstCharacterIsVowel
{
    BOOL result = NO;
    
    //===
    
    if (self.length)
    {
        NSString *vowelsStr = @"aeiouàèìòùáéíóúAEIOUÀÈÌÒÙÁÉÍÓÚ";
        NSString *firstCharStr =
        [self substringWithRange:NSMakeRange(0, 1)];
        
        // lets try to find first letter in vowels str
        
        if (((NSRange)[vowelsStr rangeOfString:firstCharStr]).length)
        {
            result = YES;
        }
    }
    
    //===
    
    return result;
}

- (BOOL)isPlural
{
    BOOL result = NO;
    
    //===
    
    if (self.length > 1)
    {
        NSString *selfInUpperCase = [self uppercaseString];
        
        NSUInteger count = self.length;
        
        NSString *preLastChar =
        [selfInUpperCase substringWithRange:NSMakeRange((count - 2), 1)];
        
        if ([selfInUpperCase hasSuffix:@"S"] &&
            ![preLastChar isEqualToString:@"S"])
        {
            result = YES;
        }
    }
    
    //===
    
    return result;
}

- (NSString *)recommendedArticle
{
    NSString *result = nil;
    
    //===
    
    if ((self.length > 1) && !self.isPlural)
    {
        if (self.firstCharacterIsVowel)
        {
            result = @"AN";
        }
        else
        {
            result = @"A";
        }
    }
    
    //===
    
    return result;
}

- (NSString *)withRecommendedArticle
{
    NSString *result = self.recommendedArticle;
    
    //===
    
    if (isNonZeroString(result))
    {
        result = [NSString stringWithFormat:@"%@ %@", result, self];
    }
    else
    {
        result = self;
    }
    
    //===
    
    return result;
}

#pragma mark - Generic

+ (BOOL)stringIsValidEmail:(NSString *)stringToCheck
{
    // based on 'bit_validateEmail' from <HockeySDK/BITHockeyHelper.h>
    
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *emailTest =
    [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:stringToCheck];
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

- (NSString *)retina4NameIfNeeded
{
    NSString *result = self;
    
    //===
    
    if (isRetina4)
    {
        NSString *extension = nil;
        NSRange dotRange = [result rangeOfString:@"."];
        
        if (dotRange.location != NSNotFound)
        {
            extension = [result substringFromIndex:dotRange.location];
            result = [result substringToIndex:dotRange.location];
        }
        
        //===
        
        NSRange atRange = [result rangeOfString:@"@"];
        
        if (atRange.location != NSNotFound)
        {
            result = [result substringToIndex:atRange.location];
        }
        
        //===
        
        NSString *retina4name = [result stringByAppendingString:retina4postfix];
        
        //===
        
        if (atRange.location != NSNotFound)
        {
            retina4name = [retina4name stringByAppendingString:@"@2x"];
        }
        
        //===
        
        if (extension)
        {
            retina4name = [retina4name stringByAppendingString:extension];
        }
        
        //===
        
        // http://stackoverflow.com/questions/5545504/checking-the-presence-of-a-file-in-the-bundle
        if([UIImage imageNamed:retina4name])
        {
            result = retina4name;
        }
    }
    
    //===
    
    return result;
}

-(NSString *)encodeURL
{
    // http://stackoverflow.com/questions/8086584/objective-c-url-encoding
    
    NSMutableString * output = [NSMutableString string];
    
    const char * source = [self UTF8String];
    unsigned long sourceLen = strlen(source);
    
    for (int i = 0; i < sourceLen; ++i)
    {
        const unsigned char thisChar = (const unsigned char)source[i];
        
        if (thisChar == ' ')
        {
            [output appendString:@"+"];
        }
        else if ((thisChar == '.') ||
                 (thisChar == '-') ||
                 (thisChar == '_') ||
                 (thisChar == '~') ||
                 ((thisChar >= 'a') && (thisChar <= 'z')) ||
                 ((thisChar >= 'A') && (thisChar <= 'Z')) ||
                 ((thisChar >= '0') && (thisChar <= '9')))
        {
            [output appendFormat:@"%c", thisChar];
        }
        else
        {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    
    //===
    
    return output;
}

#pragma mark - base64 encoding/decoding

+ (NSString*)base64forData:(NSData*)theData
{
    // http://stackoverflow.com/a/13245731/2312115
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (NSString*)encodeBase64
{
    return [self.class base64forData:
            [self dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *)stringByAppendingDeviceType
{
    return [self stringByAppendingString:(isPhone ? @"Phone" : @"Pad")];
}

- (NSString *)stringByAppendingScreenType
{
    return
    [self
     stringByAppendingFormat:@"%@%.0f",
     (isPhone ? @"Phone" : @"Pad"),
     mainScreenSize.height];
}

@end
