//
//  UIImage+Helpers.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 9/4/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "UIImage+Helpers.h"

@implementation UIImage (Helpers)

+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIImage *result = nil;
    
    //===
    
    if (image)
    {
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    //===
    
    return result;
}

- (UIImage *)imageScaledToSize:(CGSize)newSize
{
    return [[self class] imageWithImage:self scaledToSize:newSize];
}

@end
