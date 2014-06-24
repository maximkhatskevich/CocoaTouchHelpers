//
//  FlexiblePageControl.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 2/2/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//
//  Based on class PageControl which was
//  created by Morten Heiberg <morten@heiberg.net> on November 1, 2010.
//  http://iphonedevelopmentkit.blogspot.ru/2011/05/customize-color-and-size-of-page.html
//

#import <UIKit/UIKit.h>

@interface FlexiblePageControl : UIView

@property NSInteger currentPage;
@property NSInteger numberOfPages;

@property (strong, nonatomic) UIColor *currentPageIndicatorColor;
@property (strong, nonatomic) UIColor *pageIndicatorColor;

@property (strong, nonatomic) void (^onPageDidChange)(FlexiblePageControl *pageControl);

@property CGFloat dotDiameter;
@property CGFloat intervalBetweenDots;

@end