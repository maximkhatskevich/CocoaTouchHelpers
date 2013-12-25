//
//  UIView+FontHelpers.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 11/8/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

//===

extern NSString *defaultFontName; // must be defined in an application

//===

@interface UIView (FontHelpers)

- (void)applyFontWithName:(NSString *)fontName andSize:(CGFloat)fontSize;
- (void)applyFontWithName:(NSString *)fontName;
- (void)applyDefaultFont;

@end
