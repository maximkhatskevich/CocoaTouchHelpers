//
//  PassthroughView.m 
//  MyHelpers
//
//  Created by Maxim Khatskevich on 12/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "PassthroughView.h"

@implementation PassthroughView

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // http://stackoverflow.com/a/4010809
    
    //===
    
    BOOL result = NO;
    
    //===
    
    for (UIView *view in self.subviews)
    {
        if (!view.hidden &&
            view.userInteractionEnabled &&
            [view pointInside:[self convertPoint:point toView:view] withEvent:event])
        {
            result = YES;
            break;
        }
    }
    
    //===
    
    return result;
}

@end
