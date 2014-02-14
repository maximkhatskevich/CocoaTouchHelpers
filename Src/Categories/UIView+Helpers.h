//
//  UIView+Helpers.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AnimationCompletionBlock)(BOOL finished);

@interface UIView (Helpers)

@property BOOL visible;

@property CGFloat originX;
@property CGFloat originY;
@property CGPoint origin;
@property CGFloat height;
@property CGFloat width;
@property CGSize size;

- (void)setOriginX:(CGFloat)newValue animated:(BOOL)animated
    withCompletion:(AnimationCompletionBlock)completionBlock;
- (void)setOriginY:(CGFloat)newValue animated:(BOOL)animated
    withCompletion:(AnimationCompletionBlock)completionBlock;
- (void)setOrigin:(CGPoint)newValue animated:(BOOL)animated
   withCompletion:(AnimationCompletionBlock)completionBlock;
- (void)setWidth:(CGFloat)newValue animated:(BOOL)animated
  withCompletion:(AnimationCompletionBlock)completionBlock;
- (void)setHeight:(CGFloat)newValue animated:(BOOL)animated
   withCompletion:(AnimationCompletionBlock)completionBlock;
- (void)setSize:(CGSize)newValue animated:(BOOL)animated
 withCompletion:(AnimationCompletionBlock)completionBlock;
- (void)setFrame:(CGRect)newValue animated:(BOOL)animated
  withCompletion:(AnimationCompletionBlock)completionBlock;

- (void)setOriginX:(CGFloat)newValue animated:(BOOL)animated;
- (void)setOriginY:(CGFloat)newValue animated:(BOOL)animated;
- (void)setOrigin:(CGPoint)newValue animated:(BOOL)animated;
- (void)setWidth:(CGFloat)newValue animated:(BOOL)animated;
- (void)setHeight:(CGFloat)newValue animated:(BOOL)animated;
- (void)setSize:(CGSize)newValue animated:(BOOL)animated;
- (void)setFrame:(CGRect)newValue animated:(BOOL)animated;

//=== Helpers

+ (BOOL)isView:(UIView *)childView aSubviewOfView:(UIView *)superView;

+ (id)newWithSuperview:(UIView *)targetSuperView;

- (void)removeFromSuperviewAnimated;

- (void)hide;
- (void)makeTransparent;
- (void)hideAndMakeTransparent;
- (void)hideAnimatedWithDuration:(NSTimeInterval)duration
                   andCompletion:(SimpleBlock)completionBlock;
- (void)hideAnimated;
- (void)hideAnimatedWithCompletion:(SimpleBlock)completionBlock;
- (void)hideAnimatedIfNeededWithCompletion:(SimpleBlock)completionBlock;
- (void)hideAnimatedIfNeeded;

- (void)show;
- (void)prepareToShow;
- (void)showAnimatedWithDuration:(NSTimeInterval)duration
                   andCompletion:(SimpleBlock)completionBlock;
- (void)showAnimated;
- (void)showAnimatedWithCompletion:(SimpleBlock)completionBlock;
- (void)showAnimatedIfNeeded;

- (void)appearWithDuration:(NSTimeInterval)duration
                     delay:(NSTimeInterval)delay
                   options:(UIViewAnimationOptions)options
                  ifNeeded:(BOOL)ifNeeded
                completion:(void (^)(BOOL finished))completionBlock;

- (void)disappearWithDuration:(NSTimeInterval)duration
                        delay:(NSTimeInterval)delay
                      options:(UIViewAnimationOptions)options
                     ifNeeded:(BOOL)ifNeeded
                   completion:(void (^)(BOOL finished))completionBlock;

- (void)bringToFront;
- (void)sendToBack;

- (id)configureWithSuperview:(UIView *)targetSuperView;

- (void)placeInCenterOfSuperview;

- (void)showOverlaySmall;
- (void)showOverlayLarge;
- (void)hideOverlay;
- (void)hideOverlayWithCompetion:(SimpleBlock)completionBlock;

@end
