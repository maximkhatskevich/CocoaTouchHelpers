//
//  CTHUtils.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 14/11/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#ifndef CocoaTouchHelpers_CTHUtils_h
#define CocoaTouchHelpers_CTHUtils_h

#import <UIKit/UIKit.h>

//===

// http://stackoverflow.com/questions/3339722/check-iphone-ios-version

bool SYSTEM_VERSION_EQUAL_TO(v)
{
    return ([[[UIDevice currentDevice] systemVersion]
             compare:v options:NSNumericSearch] == NSOrderedSame);
}

//#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
//#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
//#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
//#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//===

#endif
