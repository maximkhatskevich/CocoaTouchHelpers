//
//  NSDate+Helpers.m
//  MyHelpers
//
//  Created by Maxim Khatskevich on 11/15/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "NSDate+Helpers.h"

@implementation NSDate (Helpers)

+ (NSDate *)currentDateForTimeZone:(NSTimeZone *)targetTimeZone
{
    return [[self class] dateForDate:[NSDate date] andTimeZone:targetTimeZone];
}

+ (NSDate *)dateForDate:(NSDate *)sourceDateInUTC andTimeZone:(NSTimeZone *)targetTimeZone
{
    NSDate *result= nil;
    
    //===
    
    if (targetTimeZone)
    {
        NSCalendarUnit unitFlags =
        (NSCalendarUnitMinute |
         NSCalendarUnitHour |
         NSCalendarUnitDay |
         NSCalendarUnitMonth |
         NSCalendarUnitYear |
         NSCalendarUnitTimeZone);
        
        //===
        
        NSCalendar *targetCalendar = [NSCalendar currentCalendar];
        targetCalendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        
        //===
        
        NSDateComponents *targetComponents =
        [targetCalendar
         components:unitFlags
         fromDate:sourceDateInUTC]; // given dateAndTime in UTC
        
        targetComponents.timeZone = targetTimeZone;
        
        //===
        
        result = [targetCalendar dateFromComponents:targetComponents];
    }
    
    //===
    
    return result;
}

@end
