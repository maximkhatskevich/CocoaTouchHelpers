//
//  UIViewController+KeyboardHelpers.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 7/24/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "UIViewController+KeyboardHelpers.h"

#import "MacrosBase.h"
#import "UIScrollView+Helpers.h"

static CGSize __keyboardSize;
static float __keyboardAnimationDuration = 0.0;
static KeyboardState __keyboardState = kUnknownKeyboardState;

//===

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
    return __keyboardSize;
}

- (CGSize)realKeyboardSize
{
    return [[self class] realKeyboardSize];
}

- (float)keyboardAnimationDuration
{
    return __keyboardAnimationDuration;
}

- (KeyboardState)keyboardState
{
    return __keyboardState;
}

- (UIScrollView *)keyboardScrollView
{
    // override and return target scrollview for keyboard support
    return nil;
}

- (BOOL)allowScrollViewBounce
{
    return NO;
}

#pragma mark - Helpers

+ (CGSize)keyboardSize
{
    return __keyboardSize;
}

+ (CGSize)realKeyboardSize
{
    return (isUILandscape ?
            CGSizeMake(__keyboardSize.height, __keyboardSize.width) :
            CGSizeMake(__keyboardSize.width, __keyboardSize.height));
}

+ (float)keyboardAnimationDuration
{
    return __keyboardAnimationDuration;
}

+ (KeyboardState)keyboardState
{
    return __keyboardState;
}

- (void)trackKeyboardEvents
{
    __keyboardSize = CGSizeZero;
    __keyboardState = kHiddenKeyboardState;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidShow:)
     name:UIKeyboardDidShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardDidHide:)
     name:UIKeyboardDidHideNotification
     object:nil];
}

- (void)stopTrackingKeyboardEvents
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardDidShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardDidHideNotification
     object:nil];
    
    __keyboardSize = CGSizeZero;
    __keyboardState = kUnknownKeyboardState;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    
    __keyboardSize =
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    __keyboardAnimationDuration =
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    __keyboardState = kAnimatingUpKeyboardState;
    
    //===
    
    __weak UIScrollView *scrollView = self.keyboardScrollView;
    
    if (scrollView)
    {
        scrollView.bounces = YES;
        [scrollView adjustWithKeyboard];
    }
    
    //===
    
    [self adjustInterfaceWithKeyboard];
}

- (void)keyboardDidShow:(NSNotification *)aNotification
{
    __keyboardState = kShownKeyboardState;
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    __weak UIScrollView *scrollView = self.keyboardScrollView;
    
    if (scrollView)
    {
        [UIView
         animateWithDuration:self.keyboardAnimationDuration
         animations:^{
             
             [scrollView resetInsets];
         }
         completion:^(BOOL finished) {
             
             scrollView.bounces = self.allowScrollViewBounce;
         }];
    }
    
    //===
    
    __keyboardSize = CGSizeZero;
    __keyboardAnimationDuration = 0.0;
    __keyboardState = kAnimatingDownKeyboardState;
    
    //===
    
    [self adjustInterfaceWithKeyboard];
}

- (void)keyboardDidHide:(NSNotification *)aNotification
{
    __keyboardState = kHiddenKeyboardState;
}

- (void)adjustInterfaceWithKeyboard
{
    // override in subclass to adjust UI for keyboard...
    // generally - to set proper contentOffset on scrollView
    
    //===
    
    [self.keyboardScrollView adjustWithFirstResponder];
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
    if ([UIViewController keyboardState] > kHiddenKeyboardState)
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
