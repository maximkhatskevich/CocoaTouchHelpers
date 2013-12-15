//
//  MacrosBase.h
//  MyHelpers
//
//  Created by Maxim Khatskevich on 11/4/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#ifndef MyHelpers_MacrosBase_h
#define MyHelpers_MacrosBase_h

//===

// http://stackoverflow.com/questions/3339722/check-iphone-ios-version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//===

// http://stackoverflow.com/questions/5559652/how-do-i-detect-the-orientation-of-the-device-on-ios

#define isDOrientationUnknown [[UIDevice currentDevice] orientation] == UIDeviceOrientationUnknown
#define isDPortraitNormal [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait
#define isDOrientationDefault isDPortraitNormal
#define isDPortraitUpsideDown [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown
#define isDPortrait isDPortraitNormal || isDPortraitUpsideDown
#define isDLandscapeLeft [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft
#define isDLandscapeRight [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight
#define isDLandscape isDLandscapeLeft || isDLandscapeRight
#define isDFaceUp [[UIDevice currentDevice] orientation] == UIDeviceOrientationFaceUp
#define isDFaceDown [[UIDevice currentDevice] orientation] == UIDeviceOrientationFaceDown

#define isUIPortraitNormal [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait
#define isUIOrientationDefault isUIPortraitNormal
#define isUIPortraitUpsideDown [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown
#define isUIPortrait isUIPortraitNormal || isUIPortraitUpsideDown
#define isUILandscapeLeft [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft
#define isUILandscapeRight [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight
#define isUILandscape isUILandscapeLeft || isUILandscapeRight

//===

#define thisMoment [NSDate date]

//===

#define isPhone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

// is it iPhone with retina 4 inches (iPhone 5)?
#define isRetina4 (isPhone && ([UIScreen mainScreen].bounds.size.height == 568))

#define isRetina ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

//===

#define UIViewAutoresizingAll UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

#define UIViewAutoresizingTop UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

#define UIViewAutoresizingBottom UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

//===

#define zeroView [[UIView alloc] initWithFrame:CGRectZero]

//===

#define bgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define mainQueue dispatch_get_main_queue()

//===

#define weakSelfMacro __weak typeof(self) weakSelf = self
#define thisOperationMacro __weak NSBlockOperation *thisOperation = nil
#define errorMacro NSError *error = nil

//===

#define isObjectForKeySupported(object) ([object isKindOfClass:[NSObject class]] && [object respondsToSelector:@selector(objectForKey:)])

#define isParseObjectReady(object) ([object isKindOfClass:[PFObject class]] && [(PFObject *)object isDataAvailable])

#define isParseObjectOfClassReady(object, className) (isParseObjectReady(object) && [((PFObject *)object).parseClassName isEqualToString:className])

#define notNull(object) (object ? object : [NSNull null])
#define notNullIf(object, condition) (condition ? object : [NSNull null])

//===

#define randInt(min, max) randIntValueBeweenMinAndMax(min, max)

static inline int
randIntValueBeweenMinAndMax(int min, int max)
{
    float r = (float)rand() / (float)RAND_MAX;
    return (int)((max-min) * r + min);
}

#define inRangeInt(value, min, max) isIntValueInRangeBetweenMinAndMax(value, min, max)

static inline int
isIntValueInRangeBetweenMinAndMax(int value, int min, int max)
{
    return ((min <= value) && (value <= max));
}

//===

#endif
