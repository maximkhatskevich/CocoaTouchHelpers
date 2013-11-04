//
//  UIImageView+Helpers.h
//  Spotlight-SE-iOS
//
//  Created by Maxim Khatskevich on 5/9/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    UIImageScaleFactorTypeNone,
	UIImageScaleFactorTypeWidth,
	UIImageScaleFactorTypeHeight
} UIImageScaleFactorType;

@interface UIImageView (Helpers)

@property (readonly) CGFloat aspectFitImageScale;
@property (readonly) CGRect aspectFitImageFrame; // AspectFitOnly, fact iimage frame (scaled)

@end
