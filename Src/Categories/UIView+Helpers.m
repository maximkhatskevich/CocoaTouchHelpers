//
//  UIView+Helpers.m
//  Spotlight-SE-iOS
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "UIView+Helpers.h"

static __weak UIView *sharedOverlay = nil;
static __weak UIActivityIndicatorView *sharedActivityIndicator = nil;

@implementation UIView (Helpers)

#pragma mark - Property accessors

- (BOOL)isVisible
{
    return !self.hidden;
}

- (void)setIsVisible:(BOOL)newValue
{
    self.hidden = !newValue;
}

#pragma mark - Helpers

+ (BOOL)isView:(UIView *)childView aSubviewOfView:(UIView *)superView
{
    BOOL result = NO;
    
    //===
    
    for (UIView * aView in superView.subviews)
    {
        if ([aView isEqual:childView])
        {
            result = YES;
        }
        else
        {
            result = [UIView isView:childView aSubviewOfView:aView];
        }
        
        //===
        
        if (result)
        {
            break;
        }
    }
    
    //===
    
    return result;
}

+ (id)newWithSuperview:(UIView *)targetSuperView
{
    UIView *result = [[self class] new];
    [result configureWithSuperview:targetSuperView];
    
    //===
    
    return result;
}

- (void)removeFromSuperviewAnimated
{
    [self hideAnimatedWithCompletion:^{
        
        [self removeFromSuperview];
    }];
}

- (void)hide
{
    self.hidden = YES;
}

- (void)hideAnimatedWithDuration:(NSTimeInterval)duration
                   andCompletion:(SimpleBlock)completionBlock
{
    if (self.alpha != 0.0)
    {
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             if (finished)
                             {
                                 [self hide];
                                 
                                 if (completionBlock)
                                 {
                                     completionBlock();
                                 }
                             }
                         }];
    }
    else
    {
        [self hide];
        
        if (completionBlock)
        {
            completionBlock();
        }
    }
}

- (void)hideAnimated
{
    [self hideAnimatedWithDuration:defaultAnimationDuration
                     andCompletion:nil];
}

- (void)hideAnimatedWithCompletion:(SimpleBlock)completionBlock
{
    [self hideAnimatedWithDuration:defaultAnimationDuration
                     andCompletion:completionBlock];
}

- (void)hideAnimatedIfNeededWithCompletion:(SimpleBlock)completionBlock
{
    if (self.isVisible &&
        (self.alpha > 0.0))
    {
        [self hideAnimatedWithCompletion:completionBlock];
    }
}

- (void)hideAnimatedIfNeeded
{
    [self hideAnimatedIfNeededWithCompletion:nil];
}

- (void)show
{
    self.hidden = NO;
}

- (void)showAnimatedWithDuration:(NSTimeInterval)duration
                   andCompletion:(SimpleBlock)completionBlock
{
    self.alpha = 0.0;
    
    [self show];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         
                         if (finished)
                         {
                             if (completionBlock)
                             {
                                 completionBlock();
                             }
                         }
                     }];
}

- (void)showAnimated
{
    [self showAnimatedWithDuration:defaultAnimationDuration
                     andCompletion:nil];
}

- (void)showAnimatedIfNeeded
{
    if (self.isHidden ||
        (self.alpha < 1.0))
    {
        [self showAnimated];
    }
}

- (void)showAnimatedWithCompletion:(SimpleBlock)completionBlock
{
    [self showAnimatedWithDuration:defaultAnimationDuration
                     andCompletion:completionBlock];
}

- (void)bringToFront
{
    [self.superview bringSubviewToFront:self];
}

- (void)sendToBack
{
    [self.superview sendSubviewToBack:self];
}

- (id)configureWithSuperview:(UIView *)targetSuperView
{
    self.frame = targetSuperView.bounds;
    [targetSuperView addSubview:self];
    
    return self;
}

- (void)placeInCenterOfSuperview
{
    CGRect superBounds = self.superview.bounds;
    CGRect targetFrame = self.frame;
    
    //===
    
    targetFrame.origin.x =
    (superBounds.size.width - targetFrame.size.width) / 2;
    
    targetFrame.origin.y =
    (superBounds.size.height - targetFrame.size.height) / 2;
    
    //===
    
    self.frame = targetFrame;
}

- (BOOL)showOverlay
{
    BOOL result = NO;
    
    //===
    
    if (!sharedOverlay)
    {
        UIView *view = [UIView new];
        view.alpha = 0.0;
        
        view.backgroundColor =
        ([self isKindOfClass:[UIButton class]] ?
         [UIColor clearColor] :
         [UIColor colorWithWhite:0.0 alpha:0.6]);
        
        [view configureWithSuperview:self];
        
        sharedOverlay = view;
        
        //===
        
        UIView *indicatorBgView = [UIView new];
        indicatorBgView.autoresizingMask = 0;
        indicatorBgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        indicatorBgView.layer.cornerRadius = 3;
        indicatorBgView.layer.masksToBounds = YES;
        
        [sharedOverlay addSubview:indicatorBgView];
        
        //===
        
        result = YES;
    }
    
    //===
    
    return result;
}

- (void)showOverlaySmall
{
    if ([self showOverlay])
    {
        UIActivityIndicatorView *indicator =
        [[UIActivityIndicatorView alloc]
         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        indicator.autoresizingMask = 0;
        indicator.hidesWhenStopped = YES;
        [indicator startAnimating];
        
        [sharedOverlay.subviews.firstObject addSubview:indicator];
        
        //===
        
        indicator.superview.frame = indicator.bounds;
        [indicator placeInCenterOfSuperview];
        [indicator.superview placeInCenterOfSuperview];
        
        //===
        
        [sharedOverlay showAnimatedIfNeeded];
    }
}

- (void)showOverlayLarge
{
    if ([self showOverlay])
    {
        UIActivityIndicatorView *indicator =
        [[UIActivityIndicatorView alloc]
         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        indicator.autoresizingMask = 0;
        indicator.hidesWhenStopped = YES;
        [indicator startAnimating];
        
        [sharedOverlay.subviews.firstObject addSubview:indicator];
        
        //===
        
        indicator.superview.frame = indicator.bounds;
        [indicator placeInCenterOfSuperview];
        [indicator.superview placeInCenterOfSuperview];
        
        //===
        
        [sharedOverlay showAnimatedIfNeeded];
    }
}

- (void)hideOverlay
{
    [self hideOverlayWithCompetion:nil];
}

- (void)hideOverlayWithCompetion:(SimpleBlock)completionBlock
{
    if (completionBlock)
    {
        [sharedOverlay hideAnimatedWithCompletion:^{
            
            [sharedOverlay removeFromSuperview];
            completionBlock();
        }];
    }
    else
    {
        [sharedOverlay removeFromSuperviewAnimated];
    }
}

@end
