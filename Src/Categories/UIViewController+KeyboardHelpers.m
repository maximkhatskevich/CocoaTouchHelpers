//
//  UIViewController+KeyboardHelpers.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 7/24/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "UIViewController+KeyboardHelpers.h"

static CGSize _keyboardSize;
static float _keyboardAnimationDuration = 0.0;

@implementation UIView (KeyboardHelpers)

- (CGRect)intersectionWithKeyboardFrame
{
    UIView *rootView = self.window.rootViewController.view;
    
    CGSize rootSize = rootView.bounds.size; // origin is always (0;0)
    CGRect ownFrame = [rootView convertRect:self.frame
                                   fromView:self.superview];
    
    CGSize kbSize = [UIViewController realKeyboardSize];
    CGRect kbFrame = CGRectMake(0,
                                rootSize.height - kbSize.height,
                                kbSize.width,
                                kbSize.height);
    
    return CGRectIntersection(ownFrame, kbFrame);
}

@end

//===

@implementation UIViewController (KeyboardHelpers)

#pragma mark - Property accessors

- (CGSize)keyboardSize
{
    return _keyboardSize;
}

- (void)setKeyboardSize:(CGSize)currentKeyboardSize
{
    _keyboardSize = currentKeyboardSize;
}

- (CGSize)realKeyboardSize
{
    return [[self class] realKeyboardSize];
}

- (float)keyboardAnimationDuration
{
    return _keyboardAnimationDuration;
}

- (void)setKeyboardAnimationDuration:(float)keyboardAnimationDuration
{
    _keyboardAnimationDuration = keyboardAnimationDuration;
}

- (BOOL)keyboardIsShown
{
    return [[self class] keyboardIsShown];
}

- (UIScrollView *)keyboardScrollView
{
    // override and return target scrollview for keyboard support
    return nil;
}

#pragma mark - Helpers

+ (CGSize)keyboardSize
{
    return _keyboardSize;
}

+ (CGSize)realKeyboardSize
{
    return (isUILandscape ?
            CGSizeMake(_keyboardSize.height, _keyboardSize.width) :
            CGSizeMake(_keyboardSize.width, _keyboardSize.height));
}

+ (float)keyboardAnimationDuration
{
    return _keyboardAnimationDuration;
}

+ (BOOL)keyboardIsShown
{
    return (self.keyboardSize.height != 0);
}

- (void)trackKeyboardEvents
{
    self.keyboardSize = CGSizeZero;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWasShown:)
     name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillBeHidden:)
     name:UIKeyboardWillHideNotification object:nil];
}

- (void)stopTrackingKeyboardEvents
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardDidShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize =
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.keyboardSize = kbSize;
    
    float kbAnimDuration =
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.keyboardAnimationDuration = kbAnimDuration;
    
    //===
    
    __weak UIScrollView *scrollView = self.keyboardScrollView;
    
    scrollView.bounces = YES;
    [scrollView adjustWithKeyboard];
    
    //===
    
    [self adjustInterfaceWithKeyboard];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    __weak UIScrollView *scrollView = self.keyboardScrollView;
    
    if (scrollView && self.keyboardIsShown) // just to make sure
    {
        [UIView
         animateWithDuration:self.keyboardAnimationDuration
         animations:^{
             
             [scrollView resetInsets];
         }
         completion:^(BOOL finished) {
             
             scrollView.bounces = NO;
         }];
    }
    
    //===
    
    self.keyboardSize = CGSizeZero;
    self.keyboardAnimationDuration = 0.0;
}

- (void)adjustInterfaceWithKeyboard
{
    // override in subclass to adjust UI for keyboard...
    // generally - to set proper contentOffset on scrollView
    
    //===
    
    __weak UIScrollView *scrollView = self.keyboardScrollView;
    
    if (scrollView && self.keyboardIsShown) // just to make sure
    {
        [scrollView adjustWithFirstResponder];
    }
}

- (IBAction)defaultDidBeginEditingHandler:(id)sender
{
    [self adjustInterfaceWithKeyboard];
}

@end

//===

@implementation UIScrollView (KeyboardHelpers)

- (void)adjustWithKeyboard
{
    if ([UIViewController keyboardIsShown])
    {
        UIScrollView *scrollView = self;
        
        //===
        
        UIView *rootView = self.window.rootViewController.view;
        
        CGSize rootSize = rootView.bounds.size; // origin is always (0;0)
        CGRect ownFrame = [rootView convertRect:scrollView.frame
                                       fromView:scrollView.superview];
        
        CGSize kbSize = [UIViewController realKeyboardSize];
        CGRect kbFrame = CGRectMake(0,
                                    rootSize.height - kbSize.height,
                                    kbSize.width,
                                    kbSize.height);
        
        CGRect interFrame = CGRectIntersection(ownFrame, kbFrame);
        
        //===
        
        scrollView.contentInset =
        UIEdgeInsetsMake(0, 0, interFrame.size.height, 0);
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset;
    }
}

@end
