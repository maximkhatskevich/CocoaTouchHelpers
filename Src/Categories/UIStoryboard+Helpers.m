//
//  UIStoryboard+Helpers.m
//  MyHelpers
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "UIStoryboard+Helpers.h"

@implementation UIStoryboard (Helpers)

+ (UIStoryboard *)currentStoryboard
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    return [UIStoryboard
            storyboardWithName:[mainBundle.infoDictionary objectForKey:@"UIMainStoryboardFile"]
            bundle:mainBundle];
}

@end
