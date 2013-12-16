//
//  LoadingIndicatorView.m
//  MyHelpers
//
//  Created by Maxim Khatskevich on 12/10/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "LoadingIndicatorView.h"

#define progressUpdateInterval 0.1f
#define progressUpdateDelta 0.03f // 3%

@interface LoadingIndicatorView ()

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation LoadingIndicatorView

#pragma mark - Overrided methods

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //===
    
    self.hidden = YES;
    [self setProgress:0.0 animated:NO];
}

#pragma mark - Helpers

- (void)startAnimating
{
    [self invalidate];
    
    //===
    
    [self setProgress:0.0 animated:NO];
    
    [self performSelector:@selector(showAnimated)
               withObject:nil
               afterDelay:0.1];
    
    //===
    
    weakSelfMacro;
    
    self.timer =
    [NSTimer
     scheduledTimerWithTimeInterval:progressUpdateInterval
     target:weakSelf
     selector:@selector(updateProgress:)
     userInfo:nil
     repeats:YES];
}

- (void)updateProgress:(NSTimer *)timer
{
    if (self.timer)
    {
        CGFloat delta = progressUpdateDelta;
        
        //===
        
        if (self.progress >= 0.5)
        {
            delta = (0.8 - self.progress) / 2;
        }
        
        //===
        
        [self
         setProgress:(self.progress + delta)
         animated:YES];
    }
}

- (void)finishAnimating
{
    [self invalidate];
    
    //===
    
    [self setProgress:1.0 animated:YES];
    [self hideAnimated];
}

- (void)invalidate
{
    [self.timer invalidate];
    self.timer = nil;
}

@end
