//
//  NSDate+Helpers.h
//  MyHelpers
//
//  Created by Maxim Khatskevich on 11/15/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helpers)

// returns local date/time for 'sourceDateInUTC' and 'targetTimeZone', NOT in UTC:
+ (NSDate *)dateForDate:(NSDate *)sourceDateInUTC andTimeZone:(NSTimeZone *)targetTimeZone;

// returns local current date/time for 'targetTimeZone', NOT in UTC:
+ (NSDate *)currentDateForTimeZone:(NSTimeZone *)targetTimeZone;

@end
