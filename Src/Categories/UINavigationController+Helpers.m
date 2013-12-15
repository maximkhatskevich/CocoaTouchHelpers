//
//  UINavigationController+Helpers.m
//  MyHelpers
//
//  Created by Maxim Khatskevich on 6/12/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "UINavigationController+Helpers.h"

@implementation UINavigationController (Helpers)

- (BOOL)isRootCtrlShown
{
    return (self.viewControllers.count == 1);
}

- (UIViewController *)rootViewController
{
    return (UIViewController *)self.viewControllers.firstObject;
}

- (void)popViewControllerAnimated
{
    [self popViewControllerAnimated:YES];
}

- (void)popViewController
{
    [self popViewControllerAnimated:NO];
}

@end
