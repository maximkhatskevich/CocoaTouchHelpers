//
//  UIView+Helpers.m
//  MyHelpers
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "UIView+Helpers.h"

static __weak UIView *sharedOverlay = nil;
static __weak UIActivityIndicatorView *sharedActivityIndicator = nil;

@implementation UIView (Helpers)

#pragma mark - Property accessors

- (BOOL)visible
{
    return !self.hidden;
}

- (void)setVisible:(BOOL)newValue
{
    self.hidden = !newValue;
}

-(CGFloat)originX
{
    return self.frame.origin.x;
}

- (void)setOriginX:(CGFloat)newValue
{
    CGRect frame = self.frame;
    
    //===
    
    if (frame.origin.x != newValue)
    {
        frame.origin.x = newValue;
        
        //===
        
        self.frame = frame;
    }
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

- (void)setOriginY:(CGFloat)newValue
{
    CGRect frame = self.frame;
    
    //===
    
    if (frame.origin.y != newValue)
    {
        frame.origin.y = newValue;
        
        //===
        
        self.frame = frame;
    }
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)newValue
{
    CGRect frame = self.frame;
    
    //===
    
    if (!CGPointEqualToPoint(frame.origin, newValue))
    {
        frame.origin = newValue;
        
        //===
        
        self.frame = frame;
    }
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newValue
{
    CGRect frame = self.frame;
    
    //===
    
    if (frame.size.height != newValue)
    {
        frame.size.height = newValue;
        
        //===
        
        self.frame = frame;
    }
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newValue
{
    CGRect frame = self.frame;
    
    //===
    
    if (frame.size.width != newValue)
    {
        frame.size.width = newValue;
        
        //===
        
        self.frame = frame;
    }
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)newValue
{
    CGRect frame = self.frame;
    
    //===
    
    if (!CGSizeEqualToSize(frame.size, newValue))
    {
        frame.size = newValue;
        
        //===
        
        self.frame = frame;
    }
}

#pragma mark - Helpers

- (void)setOriginX:(CGFloat)newValue animated:(BOOL)animated withCompletion:(AnimationCompletionBlock)completionBlock
{
    SimpleBlock executionBlock = ^{
        
        self.originX = newValue;
    };
    
    if (animated)
    {
        [UIView
         animateWithDuration:defaultAnimationDuration
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             
             executionBlock();
         }
         completion:completionBlock];
    }
    else
    {
        executionBlock();
    }
}

- (void)setOriginY:(CGFloat)newValue animated:(BOOL)animated withCompletion:(AnimationCompletionBlock)completionBlock
{
    SimpleBlock executionBlock = ^{
        
        self.originY = newValue;
    };
    
    if (animated)
    {
        [UIView
         animateWithDuration:defaultAnimationDuration
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             
             executionBlock();
         }
         completion:completionBlock];
    }
    else
    {
        executionBlock();
    }
}

- (void)setOrigin:(CGPoint)newValue animated:(BOOL)animated withCompletion:(AnimationCompletionBlock)completionBlock
{
    SimpleBlock executionBlock = ^{
        
        self.origin = newValue;
    };
    
    if (animated)
    {
        [UIView
         animateWithDuration:defaultAnimationDuration
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             
             executionBlock();
         }
         completion:completionBlock];
    }
    else
    {
        executionBlock();
    }
}

- (void)setWidth:(CGFloat)newValue animated:(BOOL)animated withCompletion:(AnimationCompletionBlock)completionBlock
{
    SimpleBlock executionBlock = ^{
        
        self.width = newValue;
    };
    
    if (animated)
    {
        [UIView
         animateWithDuration:defaultAnimationDuration
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             
             executionBlock();
         }
         completion:completionBlock];
    }
    else
    {
        executionBlock();
    }
}

- (void)setHeight:(CGFloat)newValue animated:(BOOL)animated withCompletion:(AnimationCompletionBlock)completionBlock
{
    SimpleBlock executionBlock = ^{
        
        self.height = newValue;
    };
    
    if (animated)
    {
        [UIView
         animateWithDuration:defaultAnimationDuration
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             
             executionBlock();
         }
         completion:completionBlock];
    }
    else
    {
        executionBlock();
    }
}

- (void)setSize:(CGSize)newValue animated:(BOOL)animated withCompletion:(AnimationCompletionBlock)completionBlock
{
    SimpleBlock executionBlock = ^{
        
        self.size = newValue;
    };
    
    if (animated)
    {
        [UIView
         animateWithDuration:defaultAnimationDuration
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             
             executionBlock();
         }
         completion:completionBlock];
    }
    else
    {
        executionBlock();
    }
}

- (void)setFrame:(CGRect)newValue animated:(BOOL)animated withCompletion:(AnimationCompletionBlock)completionBlock
{
    SimpleBlock executionBlock = ^{
        
        self.frame = newValue;
    };
    
    if (animated)
    {
        [UIView
         animateWithDuration:defaultAnimationDuration
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             
             executionBlock();
         }
         completion:completionBlock];
    }
    else
    {
        executionBlock();
    }
}

- (void)setOriginX:(CGFloat)newValue animated:(BOOL)animated
{
    [self setOriginX:newValue animated:animated withCompletion:nil];
}

- (void)setOriginY:(CGFloat)newValue animated:(BOOL)animated
{
    [self setOriginY:newValue animated:animated withCompletion:nil];
}

- (void)setOrigin:(CGPoint)newValue animated:(BOOL)animated
{
    [self setOrigin:newValue animated:animated withCompletion:nil];
}

- (void)setWidth:(CGFloat)newValue animated:(BOOL)animated
{
    [self setWidth:newValue animated:animated withCompletion:nil];
}

- (void)setHeight:(CGFloat)newValue animated:(BOOL)animated
{
    [self setHeight:newValue animated:animated withCompletion:nil];
}

- (void)setSize:(CGSize)newValue animated:(BOOL)animated
{
    [self setSize:newValue animated:animated withCompletion:nil];
}

- (void)setFrame:(CGRect)newValue animated:(BOOL)animated
{
    [self setFrame:newValue animated:animated withCompletion:nil];
}

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
    if (self.visible &&
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
        view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        view.autoresizingMask = UIViewAutoresizingAll;
        [view configureWithSuperview:self];
        
        sharedOverlay = view;
        
        //===
        
        result = YES;
    }
    
    //===
    
    return result;
}

- (void)addOverlayIndicatorWithStule:(UIActivityIndicatorViewStyle)style
{
    UIActivityIndicatorView *indicator =
    [[UIActivityIndicatorView alloc]
     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    indicator.autoresizingMask =
    (UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleLeftMargin |
     UIViewAutoresizingFlexibleBottomMargin |
     UIViewAutoresizingFlexibleTopMargin);
    
    indicator.hidesWhenStopped = YES;
    [indicator startAnimating];
    
    [sharedOverlay addSubview:indicator];
    
    [indicator placeInCenterOfSuperview];
}

- (void)showOverlaySmall
{
    if ([self showOverlay])
    {
        [self addOverlayIndicatorWithStule:UIActivityIndicatorViewStyleWhite];
        [sharedOverlay showAnimatedIfNeeded];
    }
}

- (void)showOverlayLarge
{
    if ([self showOverlay])
    {
        [self addOverlayIndicatorWithStule:UIActivityIndicatorViewStyleWhiteLarge];
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
