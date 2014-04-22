//
//  BaseGenericCtrl.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 2/14/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "BaseGenericCtrl.h"

#import "UIViewController+Helpers.h"

@interface BaseGenericCtrl ()

@end

@implementation BaseGenericCtrl

#pragma mark - Overrided methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    //===
    
    if (self)
    {
        [self prepare];
    }
    
    //===
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//===
    
    [self prepareUI];
    [self applyCustomAppearance];
}

#pragma mark - Generic

- (void)prepare
{
    // Prepare here any non-UI stuff.
}

- (void)prepareUI
{
    // Prepare here any UI-related stuff.
}

@end
