//
//  UIScrollView+Helpers.h
//  Toni&Guy-SE-iOS
//
//  Created by Maxim Khatskevich on 5/29/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Helpers)

@property (readonly) NSUInteger currentHorizontalPageNumber;

- (CGSize)defaultContentSizeWithMargins:(CGPoint)margins;
- (void)applyDefaultContentSize;

- (void)adjustWithKeyboard;
- (void)adjustWithFirstResponder; // adjust contentOffset while keyboard is visible
- (void)resetInsets;

@end
