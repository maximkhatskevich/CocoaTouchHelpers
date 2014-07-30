//
//  NSDate+Helpers.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 11/15/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "NSDate+Helpers.h"

#import "MacrosBase.h"

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
        targetCalendar.timeZone = targetTimeZone;
        
        //===
        
        NSDateComponents *targetComponents =
        [targetCalendar
         components:unitFlags
         fromDate:sourceDateInUTC]; // given dateAndTime in UTC
        
        // lets re-set time zone to avoid
        // back date and time conversion when we
        // will convert components into NSDate instance
        
        targetComponents.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        
        //===
        
        result = [targetCalendar dateFromComponents:targetComponents];
    }
    
    //===
    
    return result;
}

- (NSString *)dayOfWeek
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"EEEE"];
    
    //===
    
    return [dateFormatter stringFromDate:self];
}

- (NSString *)relativeDayName
{
    NSString *result = nil;
    
    //===
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval diff;
    
    diff = [self timeIntervalSinceDate:currentDate];
    double secondsInAnHour = 3600;
    
    NSInteger daysBetweenDates = diff / (secondsInAnHour * 24);
    
    //===
    
    switch (daysBetweenDates)
    {
        case -1:
            result = @"Yesterday";
            break;
            
        case 0:
            result = @"Today";
            break;
            
        case 1:
            result = @"Tomorrow";
            break;
            
        case 2:
            result = @"Day after";
            break;
            
        default:
            break;
    }
    
    //===
    
    return result;

}

- (NSDateComponents *)defaultComponents
{
    NSCalendarUnit unitFlags = (NSCalendarUnitSecond |
                                NSCalendarUnitMinute |
                                NSCalendarUnitHour |
                                NSCalendarUnitDay |
                                NSCalendarUnitMonth |
                                NSCalendarUnitYear);
    
    return
    [[NSCalendar currentCalendar] components:unitFlags
                                    fromDate:self];
}

- (NSString *)stringInUTCWithFormat:(NSString *)format
{
    NSString *result = nil;
    
    //===
    
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    });
    
    //===
    
    [dateFormatter setDateFormat:format];
    result = [dateFormatter stringFromDate:self];

    //===
    
    return result;
}

+ (NSCalendarUnit)defaultCalendarUnits
{
    return (NSCalendarUnitTimeZone |
            NSCalendarUnitYear |
            NSCalendarUnitMonth |
            NSCalendarUnitDay |
            NSCalendarUnitHour |
            NSCalendarUnitMinute |
            NSCalendarUnitSecond);
}

+ (NSDate *)dateFromString:(NSString *)dateStr withFormat:(NSString *)dateFormat
{
    NSDate *result = nil;
    
    //===
    
    if (isNonZeroString(dateStr) && isNonZeroString(dateFormat))
    {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = dateFormat;
        
        result = [formatter dateFromString:dateStr];
    }
    
    //===
    
    return result;
}

@end
