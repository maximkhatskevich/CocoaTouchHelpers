//
//  UIView+FontHelpers.m
//  MyHelpers
//
//  Created by Maxim Khatskevich on 11/8/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "UIView+FontHelpers.h"

//===

NSString *defaultFontName = nil; // do not forget to define it before use!

//===

@implementation UIView (FontHelpers)

- (void)applyFontWithName:(NSString *)fontName andSize:(CGFloat)fontSize
{
    __weak id targetView = nil;
    
    //===
    
    if ([self isKindOfClass:[UILabel class]] ||
        [self isKindOfClass:[UITextView class]] ||
        [self isKindOfClass:[UITextField class]])
    {
        targetView = self;
    }
    
    //===
    
    if (targetView)
    {
        CGFloat targetFontSize =
        (fontSize == 0.0 ?
         [[targetView performSelector:@selector(font)] pointSize] :
         fontSize);
        
        [targetView
         performSelector:@selector(setFont:)
         withObject:[UIFont fontWithName:fontName size:targetFontSize]];
    }
}

- (void)applyFontWithName:(NSString *)fontName
{
    
    [self applyFontWithName:fontName andSize:0.0];
}

- (void)applyDefaultFont
{
    [self applyFontWithName:defaultFontName];
}

@end
