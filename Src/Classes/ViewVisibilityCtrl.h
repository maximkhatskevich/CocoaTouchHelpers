//
//  ViewVisibilityCtrl.h
//  MyHelpers
//
//  Created by Maxim Khatskevich on 4/25/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Declarations

typedef enum {
    vvcHiddenState,
    vvcShowingState,
    vvcShownState,
    vvcHidingState
} ViewVisibilityCtrlState;

@class ViewVisibilityCtrl;

typedef void (^PreparationBlock)
(ViewVisibilityCtrl *ctrl, id targetContentObject);

typedef void (^VisibilityBlock)(UIView *targetView);

typedef void (^CleanUpBlock)
(ViewVisibilityCtrl *ctrl, id currentContentObject);

#pragma mark - Class

@interface ViewVisibilityCtrl : NSLock

@property (readonly) ViewVisibilityCtrlState state;

@property NSTimeInterval duration;
@property NSTimeInterval delay;

@property (weak, nonatomic) UIView *view; // target view instance

@property BOOL showImmediately;

@property (strong, nonatomic) PreparationBlock preparationBlock;
@property (strong, nonatomic) VisibilityBlock showingBlock;
@property (strong, nonatomic) VisibilityBlock hidingBlock;
@property (strong, nonatomic) CleanUpBlock cleanupBlock;

@property (readonly, nonatomic) id targetContentObject;
@property (readonly, nonatomic) id currentObject;

+ (id)ctrlWithView:(UIView *)targetView
       preparation:(PreparationBlock)preparationBlock;

+ (id)ctrlWithView:(UIView *)targetView;

//===

- (void)updateWithObject:(id)targetContentObject; // retain it!
- (void)prepareNextObject;
- (void)showView;
- (void)hideView;

@end
