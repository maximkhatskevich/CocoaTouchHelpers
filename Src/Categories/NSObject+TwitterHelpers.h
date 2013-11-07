//
//  NSObject+TwitterHelpers.h
//  MyHelpers
//
//  Created by Maxim Khatskevich on 10/15/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TwitterHelpers)

@property (readonly) BOOL isSocialFrameworkAvailable;
@property (readonly) BOOL userHasAccessToTwitter;
@property (readonly) BOOL userHasAccessToFacebook;

@end
