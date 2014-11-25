//
//  ViewController.m
//  CTHSamples
//
//  Created by Maxim Khatskevich on 25/11/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "ViewController.h"

#import "CocoaTouchHelpers.h"
#import "CTHMutableArray+ParseExt.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //===
    
    if (thisMoment &&
        [CTHMutableArray arrayWithParseSupport])
    {
        NSLog(@"It works!");
    }
}

@end
