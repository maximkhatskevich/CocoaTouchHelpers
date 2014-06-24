//
//  UIViewController+Helpers.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "UIViewController+Helpers.h"

#import "UINavigationController+Helpers.h"
#import "UIStoryboard+Helpers.h"
#import "UIView+Helpers.h"
#import "NSString+Helpers.h"
#import "UIResponder+Helpers.h"

@implementation UIViewController (Helpers)

#pragma mark - Property accessors

- (BOOL)isNavigationRootCtrl
{
    BOOL result = NO;
    
    //===
    
    if (self.navigationController)
    {
        result = [self isEqual:
                  self.navigationController.viewControllers.firstObject];
    }
    
    //===
    
    return result;
}

- (BOOL)isNavigationTopCtrl
{
    BOOL result = NO;
    
    //===
    
    if (self.navigationController)
    {
        result = [self isEqual:
                  self.navigationController.topViewController];
    }
    
    //===
    
    return result;
}

- (UIViewController *)selfOrNavigationRoot
{
    return ([self isKindOfClass:[UINavigationController class]] ?
            ((UINavigationController *)self).rootViewController : // self root ctrl
            self); // scene itself
}

#pragma mark - Helpers

+ (id)instantiate
{
    return
    [[self class] instantiateCtrlWithName:NSStringFromClass([self class])];
}

+ (id)instantiateCtrlWithName:(NSString *)ctrlStoryboardName
{
    return
    [[UIStoryboard currentStoryboard]
     instantiateViewControllerWithIdentifier:ctrlStoryboardName];
}

- (UIViewController *)goBackAnimated:(BOOL)animated
{
    UIViewController *result = nil;
    
    //===
    
    if (self.navigationController)
    {
        result = [self.navigationController popViewControllerAnimated:animated];
    }
    
    //===
    
    return result;
}

- (IBAction)goBack:(id)sender
{
    if (self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)removeAnimated:(id)sender
{
    [self removeAnimated];
}

- (IBAction)dismissDefault:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (id)instantiateWithSuperview:(UIView *)targetSuperView
{
    return [[self class] instantiateWithSuperview:targetSuperView andParent:nil];
}

+ (id)instantiateWithSuperview:(UIView *)targetSuperView andParent:(UIViewController *)parentCtrl
{
    UIViewController *result = [[self class] instantiate];
    
    //===
    
    [result configureWithParent:parentCtrl];
    [result.view configureWithSuperview:targetSuperView];
    
    //===
    
    return result;
}

+ (id)newWithDeviceNib
{
    NSString *nibFileName = NSStringFromClass([self class]);
    nibFileName = [nibFileName stringByAppendingDeviceType];
    
    return [[[self class] alloc]
            initWithNibName:nibFileName bundle:nil];
}

+ (id)newWithScreenNib
{
    NSString *nibFileName = NSStringFromClass([self class]);
    nibFileName = [nibFileName stringByAppendingScreenType];
    
    return [[[self class] alloc]
            initWithNibName:nibFileName bundle:nil];
}

+ (id)newWithSuperview:(UIView *)targetSuperView
{
    return [[self class] newWithSuperview:targetSuperView andParent:nil];
}

+ (id)newWithSuperview:(UIView *)targetSuperView andParent:(UIViewController *)parentCtrl
{
    UIViewController *result = [[self class] new];
    
    //===
    
    [result configureWithParent:parentCtrl];
    [result.view configureWithSuperview:targetSuperView];
    
    //===
    
    return result;
}

+ (id)newWithNibName:(NSString *)nibNameInMainBundle superview:(UIView *)targetSuperView andParent:(UIViewController *)parentCtrl
{
    UIViewController *result =
    [[[self class] alloc] initWithNibName:nibNameInMainBundle bundle:nil];
    
    //===
    
    [result configureWithParent:parentCtrl];
    [result.view configureWithSuperview:targetSuperView];
    
    //===
    
    return result;
}

- (void)configureWithParent:(UIViewController *)parentCtrl
{
    [parentCtrl addChildViewController:self];
}

- (id)configureWithParent:(UIViewController *)parentCtrl
               andSuperview:(UIView *)targetSuperView
{
    [self configureWithParent:parentCtrl];
    [self.view configureWithSuperview:targetSuperView];
    
    //===
    
    return (id)self;
}

- (void)remove
{
    UIView *firstResponder = self.view.firstResponder;
    
    if (firstResponder &&
        [UIView isView:firstResponder aSubviewOfView:self.view])
    {
        [firstResponder resignFirstResponder];
    }
    
    //===
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)removeAnimated
{
    [self removeAnimatedWithCompletion:nil];
}

- (void)removeAnimatedWithCompletion:(SimpleBlock)completionBlock
{
    [self.view hideAnimatedWithCompletion:^{
        
        [self remove];
        
        if (completionBlock)
        {
            completionBlock();
        }
    }];
}

- (void)applyCustomAppearance
{
    //
}

@end
