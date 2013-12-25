//
//  UIImage+Helpers.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 9/4/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helpers)

+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
- (UIImage *)imageScaledToSize:(CGSize)newSize;

@end
