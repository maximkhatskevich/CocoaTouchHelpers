//
//  UIScrollView+Helpers.m
//  MyHelpers
//
//  Created by Maxim Khatskevich on 5/29/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "UIScrollView+Helpers.h"

@implementation UIScrollView (Helpers)

- (NSUInteger)currentHorizontalPageNumber
{
    return (NSUInteger)(floor(self.contentOffset.x/self.frame.size.width));
}

- (CGSize)defaultContentSizeWithMargins:(CGPoint)margins
{
    CGFloat maxHeight = self.frame.size.height;
    
    for (UIView* view in self.subviews)
    {
        if (![view isKindOfClass:[UIImageView class]])
        {
            CGFloat value =
            view.frame.origin.y + view.frame.size.height;
            
            if (value > maxHeight)
            {
                maxHeight = value;
            }
        }
    }
    
    if (maxHeight > self.frame.size.height)
    {
        maxHeight += margins.y;
    }
    
    //===
    
    CGFloat maxWidth = self.frame.size.width;
    
    for (UIView* view in self.subviews)
    {
        if (![view isKindOfClass:[UIImageView class]])
        {
            CGFloat value =
            view.frame.origin.x + view.frame.size.width;
            
            if (value > maxWidth)
            {
                maxWidth = value;
            }
        }
    }
    
    if (maxWidth > self.frame.size.width)
    {
        maxWidth += margins.x;
    }
    
    //===
    
    return CGSizeMake(maxWidth, maxHeight);
}

- (void)applyDefaultContentSize
{
    self.contentSize =
    [self defaultContentSizeWithMargins:CGPointMake(0.0, 20.0)];
}

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

- (void)adjustWithFirstResponder
{
    if ([UIViewController keyboardIsShown])
    {
        UIView *rootView = self.window.rootViewController.view;
        UIScrollView *scrollView = self;
        UIView *activeField = self.firstResponder;
        
        //===
        
        CGRect interFrame = [self intersectionWithKeyboardFrame];
        
        //===
        
        CGRect activeFrame = [rootView convertRect:activeField.frame
                                          fromView:activeField.superview];
        
        //===
        
        CGFloat diff =
        (activeFrame.origin.y + activeFrame.size.height) -
        interFrame.origin.y;
        
        // NSLog(@"Current diff ->> %f", diff);
        
        if (diff > 0.0)
        {
            diff += scrollView.contentOffset.y; // do not forget current offset!
            
            // NSLog(@"Target offset (y) ->> %f", diff);
            
            // implement it this way due to a bug with not accurate scrolling
            // http://stackoverflow.com/questions/5446156/uiscrollview-not-scrolling-to-proper-location-with-setcontentoffsetanimated
            // http://stackoverflow.com/questions/10970710/uiscrollview-setcontentoffset-with-non-linear-animation
            
            [UIView
             animateWithDuration:defaultAnimationDuration / 2.0
             animations:^{
                 
                 [scrollView
                  setContentOffset:CGPointMake(0.0, diff)
                  animated:NO];
             }];
        }
    }
}

- (void)resetInsets
{
    self.contentInset = UIEdgeInsetsZero;
    self.scrollIndicatorInsets = self.contentInset;
}

@end
