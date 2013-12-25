//
//  UIImageView+Helpers.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 5/9/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "UIImageView+Helpers.h"

@implementation UIImageView (Helpers)

- (CGFloat)aspectFitImageScale
{
    CGFloat result = 0.0;
    
    //===
    
    if (self.image)
    {
        CGSize imageSize = self.image.size;
        
        result = fminf(self.bounds.size.width / imageSize.width,
                       self.bounds.size.height / imageSize.height);
    }
    
    //===
    
    return result;
}

- (CGRect)aspectFitImageFrame
{
    // http://stackoverflow.com/questions/4711615/how-to-get-the-displayed-image-frame-from-uiimageview
    
    //===
    
    CGRect result = CGRectZero;
    
    //===
    
    if (self.image)
    {
        CGSize imageSize = self.image.size;
        
        CGFloat imageScale =
        fminf(self.bounds.size.width / imageSize.width,
              self.bounds.size.height / imageSize.height);
        
        CGSize scaledImageSize =
        CGSizeMake(imageSize.width * imageScale,
                   imageSize.height * imageScale);
        
        result =
        CGRectMake(0.5f * (self.bounds.size.width - scaledImageSize.width),
                   0.5f * (self.bounds.size.height - scaledImageSize.height),
                   scaledImageSize.width,
                   scaledImageSize.height);
    }
    
    //===
    
    return result;
}

@end
