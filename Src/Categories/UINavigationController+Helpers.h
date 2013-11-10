//
//  UINavigationController+Helpers.h
//  Toni&Guy-SE-iOS
//
//  Created by Maxim Khatskevich on 6/12/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Helpers)

@property (readonly) BOOL isRootCtrlShown;
@property (readonly, nonatomic) UIViewController *rootViewController;

- (void)popViewControllerAnimated;
- (void)popViewController;

@end
