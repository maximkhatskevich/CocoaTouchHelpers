//
//  UIView+FontHelpers.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 11/8/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "UIView+FontHelpers.h"

//===

NSString *defaultFontName = nil; // do not forget override value before use!

//===

@implementation UIView (FontHelpers)

- (void)applyFontWithName:(NSString *)fontName andSize:(CGFloat)fontSize
{
    if (isNonZeroString(fontName))
    {
        __weak id targetView = nil;
        
        //===
        
        if ([self isKindOfClass:[UILabel class]] ||
            [self isKindOfClass:[UITextView class]] ||
            [self isKindOfClass:[UITextField class]])
        {
            targetView = self;
        }
        else if ([UIButton isClassOfObject:self])
        {
            targetView = [(UIButton *)self titleLabel];
        }
        
        //===
        
        if ([targetView respondsToSelector:@selector(setFont:)])
        {
            CGFloat targetFontSize =
            (fontSize == 0.0 ?
             [[targetView performSelector:@selector(font)] pointSize] :
             fontSize);
            
            UIFont *targetFont =
            [UIFont fontWithName:fontName size:targetFontSize];
            
            if (targetFont)
            {
                [targetView
                 performSelector:@selector(setFont:)
                 withObject:targetFont];
            }
        }
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
