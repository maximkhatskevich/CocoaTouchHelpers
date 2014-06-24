//
//  FlexiblePageControl.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 2/2/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//
//  Based on class PageControl which was
//  created by Morten Heiberg <morten@heiberg.net> on November 1, 2010.
//  http://iphonedevelopmentkit.blogspot.ru/2011/05/customize-color-and-size-of-page.html
//

#import "FlexiblePageControl.h"

@interface FlexiblePageControl ()
{
    NSInteger _currentPage;
    NSInteger _numberOfPages;
}

@end

@implementation FlexiblePageControl

- (NSInteger)currentPage
{
    return _currentPage;
}

- (void)setCurrentPage:(NSInteger)page
{
    _currentPage = MIN(MAX(0, page), _numberOfPages - 1);
    [self setNeedsDisplay];
}

- (NSInteger)numberOfPages
{
    return _numberOfPages;
}

- (void)setNumberOfPages:(NSInteger)pages
{
    _numberOfPages = MAX(0, pages);
    _currentPage = MIN(MAX(0, _currentPage), _numberOfPages-1);
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.currentPageIndicatorColor = [UIColor blackColor];
        self.pageIndicatorColor = [UIColor lightGrayColor];
        
        self.dotDiameter = 7.0;
        self.intervalBetweenDots = 7.0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = (self.numberOfPages * self.dotDiameter +
                         MAX(0, self.numberOfPages-1) * self.intervalBetweenDots);
    
    CGFloat x = CGRectGetMidX(currentBounds) - dotsWidth / 2;
    CGFloat y = CGRectGetMidY(currentBounds) - self.dotDiameter / 2;
    
    for (int i = 0; i < _numberOfPages; i++)
    {
        CGRect circleRect = CGRectMake(x, y,
                                       self.dotDiameter, self.intervalBetweenDots);
        
        if (i == _currentPage)
        {
            CGContextSetFillColorWithColor(context,
                                           self.currentPageIndicatorColor.CGColor);
        }
        else
        {
            CGContextSetFillColorWithColor(context,
                                           self.pageIndicatorColor.CGColor);
        }
        
        CGContextFillEllipseInRect(context, circleRect);
        
        x += self.dotDiameter + self.intervalBetweenDots;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.onPageDidChange)
    {
        CGPoint touchPoint =
        [[[event touchesForView:self] anyObject] locationInView:self];
        
        CGFloat dotSpanX = self.numberOfPages * (self.dotDiameter +
                                                 self.intervalBetweenDots);
        
        CGFloat dotSpanY = self.dotDiameter + self.intervalBetweenDots;
        
        CGRect currentBounds = self.bounds;
        CGFloat x = touchPoint.x + dotSpanX/2 - CGRectGetMidX(currentBounds);
        CGFloat y = touchPoint.y + dotSpanY/2 - CGRectGetMidY(currentBounds);
        
        if ((x < 0) || (x > dotSpanX) || (y < 0) || (y > dotSpanY)) return;
        
        self.currentPage = floor(x / (self.dotDiameter + self.intervalBetweenDots));
        
        self.onPageDidChange(self);
    }
}

@end
