//
//  UIViewController+KeyboardHelpers.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 7/24/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

//===

typedef enum
{
    kUnknownKeyboardState = 0,
    kHiddenKeyboardState,
    kAnimatingUpKeyboardState,
    kShownKeyboardState,
    kAnimatingDownKeyboardState
}
KeyboardState;

//===

@interface UIView (KeyboardHelpers)

- (CGRect)intersectionWithKeyboardFrame;

@end

@interface UIViewController (KeyboardHelpers)

@property (readonly) CGSize keyboardSize;
@property (readonly) CGSize realKeyboardSize;
@property (readonly) float keyboardAnimationDuration;
@property (readonly) KeyboardState keyboardState;
@property (readonly, nonatomic) UIScrollView *keyboardScrollView;
@property (readonly) BOOL allowScrollViewBounce;

+ (CGSize)keyboardSize;
+ (CGSize)realKeyboardSize;
+ (float)keyboardAnimationDuration;
+ (KeyboardState)keyboardState;

- (void)trackKeyboardEvents;
- (void)stopTrackingKeyboardEvents; // call it in dealloc or earlier!

- (void)keyboardWillShow:(NSNotification*)aNotification;
- (void)keyboardDidShow:(NSNotification*)aNotification;
- (void)keyboardWillHide:(NSNotification*)aNotification;
- (void)keyboardDidHide:(NSNotification*)aNotification;
- (void)adjustInterfaceWithKeyboard;

- (IBAction)defaultDidBeginEditingHandler:(id)sender;

@end

//===

@interface UIScrollView (KeyboardHelpers)

- (void)adjustWithKeyboard;

@end
