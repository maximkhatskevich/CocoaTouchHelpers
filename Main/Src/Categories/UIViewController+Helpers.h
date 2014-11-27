//
//  UIViewController+Helpers.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GlobalBase.h"

@interface UIViewController (Helpers)

@property (readonly) BOOL isNavigationRootCtrl;
@property (readonly) BOOL isNavigationTopCtrl;
@property (readonly, nonatomic) UIViewController *selfOrNavigationRoot;

+ (id)instantiate;
+ (id)instantiateCtrlWithName:(NSString *)ctrlStoryboardName;

- (UIViewController *)goBackAnimated:(BOOL)animated;
- (IBAction)goBack:(id)sender;
- (IBAction)removeAnimated:(id)sender;
- (IBAction)dismissDefault:(id)sender;

+ (id)instantiateWithSuperview:(UIView *)targetSuperView;
+ (id)instantiateWithSuperview:(UIView *)targetSuperView andParent:(UIViewController *)parentCtrl;

+ (id)newWithDeviceNib; // with device-specific NIB file
+ (BOOL)nibExists:(NSString *)xibName;
+ (id)newWithScreenNib; // with screen-specific NIB file

+ (id)newWithSuperview:(UIView *)targetSuperView;
+ (id)newWithSuperview:(UIView *)targetSuperView andParent:(UIViewController *)parentCtrl;
+ (id)newWithNibName:(NSString *)nibNameInMainBundle superview:(UIView *)targetSuperView andParent:(UIViewController *)parentCtrl;

- (void)configureWithParent:(UIViewController *)parentCtrl;
- (id)configureWithParent:(UIViewController *)parentCtrl
             andSuperview:(UIView *)targetSuperView;

- (void)remove;
- (void)removeAnimated;
- (void)removeAnimatedWithCompletion:(SimpleBlock)completionBlock;

- (void)applyCustomAppearance;

@end
