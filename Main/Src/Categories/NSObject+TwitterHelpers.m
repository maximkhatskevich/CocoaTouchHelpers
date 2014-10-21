//
//  NSObject+TwitterHelpers.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 10/15/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "NSObject+TwitterHelpers.h"

#import <Social/Social.h>
#import <Twitter/Twitter.h>

@implementation NSObject (TwitterHelpers)

#pragma mark - Property accessors

- (BOOL)isSocialFrameworkAvailable
{
    // is Social (iOS 6+) framework is available?
    return (NSClassFromString(@"SLComposeViewController") != nil);
}

- (BOOL)userHasAccessToTwitter
{
    BOOL result = NO;
    
    //===
    
    if (self.isSocialFrameworkAvailable)
    {
        // iOS 6.0+
        result = [SLComposeViewController
                  isAvailableForServiceType:SLServiceTypeTwitter];
    }
    else
    {
        // prior iOS 6.0
        // result = [TWTweetComposeViewController canSendTweet];
    }
    
    //===
    
    return result;
}

- (BOOL)userHasAccessToFacebook
{
    BOOL result = NO;
    
    //===
    
    if (self.isSocialFrameworkAvailable)
    {
        result = [SLComposeViewController
                  isAvailableForServiceType:SLServiceTypeFacebook];
    }
    else
    {
//        result = ???;
    }
    
    //===
    
    return result;
}

@end
