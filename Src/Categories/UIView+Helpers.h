//
//  UIView+Helpers.h
//  Spotlight-SE-iOS
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

//===

extern NSString *defaultFontName; // must be defined in an application

//===

@interface UIView (Helpers)

@property BOOL isVisible;

//@property (readonly, nonatomic) UIView *firstResponder;

//=== Helpers

+ (BOOL)isView:(UIView *)childView aSubviewOfView:(UIView *)superView;

+ (id)newWithSuperview:(UIView *)targetSuperView;

- (void)removeFromSuperviewAnimated;

- (void)hide;
- (void)hideAnimatedWithDuration:(NSTimeInterval)duration
                   andCompletion:(SimpleBlock)completionBlock;
- (void)hideAnimated;
- (void)hideAnimatedWithCompletion:(SimpleBlock)completionBlock;
- (void)hideAnimatedIfNeededWithCompletion:(SimpleBlock)completionBlock;
- (void)hideAnimatedIfNeeded;

- (void)show;
- (void)showAnimatedWithDuration:(NSTimeInterval)duration
                   andCompletion:(SimpleBlock)completionBlock;
- (void)showAnimated;
- (void)showAnimatedWithCompletion:(SimpleBlock)completionBlock;
- (void)showAnimatedIfNeeded;

- (void)bringToFront;
- (void)sendToBack;

- (id)configureWithSuperview:(UIView *)targetSuperView;

- (void)applyFontWithName:(NSString *)fontName andSize:(CGFloat)fontSize;
- (void)applyFontWithName:(NSString *)fontName;
- (void)applyDefaultFont;

- (void)placeInCenterOfSuperview;

//- (void)applyCustomAppearance;

@end
