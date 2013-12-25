//
//  UIViewController+KeyboardHelpers.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 7/24/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (KeyboardHelpers)

- (CGRect)intersectionWithKeyboardFrame;

@end

@interface UIViewController (KeyboardHelpers)

@property CGSize keyboardSize;
@property (readonly) CGSize realKeyboardSize;
@property float keyboardAnimationDuration;
@property (readonly) BOOL keyboardIsShown;
@property (readonly, nonatomic) UIScrollView *keyboardScrollView;

+ (CGSize)keyboardSize;
+ (CGSize)realKeyboardSize;
+ (float)keyboardAnimationDuration;
+ (BOOL)keyboardIsShown;

- (void)trackKeyboardEvents;
- (void)stopTrackingKeyboardEvents; // call it in dealloc or earlier!
- (void)keyboardWasShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;
- (void)adjustInterfaceWithKeyboard;

- (IBAction)defaultDidBeginEditingHandler:(id)sender;

@end
