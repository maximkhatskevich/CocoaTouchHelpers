//
//  CTHDeviceHardware.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 19/08/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//
// Used to determine EXACT version of device software is running on.
// https://gist.github.com/Jaybles/1323251

#import <Foundation/Foundation.h>

@interface CTHDeviceHardware : NSObject

+ (NSString *)platformId;
+ (NSString *)platformName;

@end
