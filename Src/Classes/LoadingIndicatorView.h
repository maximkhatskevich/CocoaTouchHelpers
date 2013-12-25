//
//  LoadingIndicatorView.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 12/10/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingIndicatorView : UIProgressView

- (void)startAnimating;
- (void)finishAnimating;
- (void)invalidate;

@end
