//
//  UIResponder+Helpers.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 5/27/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Helpers)

@property (readonly, nonatomic) NSURL *applicationDocumentsDirectory;
@property (readonly, nonatomic) NSUserDefaults *userDefaults;
@property (readonly, nonatomic) UIStoryboard *currentStoryboard;
@property (readonly, nonatomic) UIView *firstResponder;

@property (weak, nonatomic) UIPopoverController *currentPopover;

+ (UIPopoverController *)currentPopover;

- (void)showMem;

@end