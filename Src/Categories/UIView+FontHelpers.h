//
//  UIView+FontHelpers.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 11/8/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

//===

extern NSString *defaultFontName; // should be defined in the application

//===

@interface UIView (FontHelpers)

- (void)applyFontWithName:(NSString *)fontName andSize:(CGFloat)fontSize;
- (void)applyFontWithName:(NSString *)fontName;
- (void)applyDefaultFont;

@end
