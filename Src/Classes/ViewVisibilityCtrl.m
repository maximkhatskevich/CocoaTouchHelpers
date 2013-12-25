//
//  ViewVisibilityCtrl.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 4/25/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "ViewVisibilityCtrl.h"

@interface ViewVisibilityCtrl ()

@property ViewVisibilityCtrlState state;

@property BOOL isReadyToShow;
@property BOOL isReadyToHide;
@property (strong, nonatomic) id targetContentObject;
@property (weak, nonatomic) id currentObject;

@end

@implementation ViewVisibilityCtrl

#pragma mark - Creation

+ (id)ctrlWithView:(UIView *)targetView
       preparation:(PreparationBlock)preparationBlock
{
    ViewVisibilityCtrl *result = [[self class] new];
    
    //===
    
    targetView.alpha = 0.0; // invisible by default
    
    result.view = targetView;
    result.preparationBlock = preparationBlock;
    
    //===
    
    return result;
}

+ (id)ctrlWithView:(UIView *)targetView
{
    return [[self class] ctrlWithView:targetView
                          preparation:nil];
}

#pragma mark - Overrided methods

- (id)init
{
    self = [super init];
    if (self) {
        _isReadyToShow = NO;
        _isReadyToHide = NO;
        _targetContentObject = nil;
        
        _showImmediately = YES; // defaiult
        
        _cleanupBlock = nil;
        _preparationBlock = nil;
        _showingBlock = nil;
        _hidingBlock = nil;
        
        _duration = defaultAnimationDuration;
        _delay = 0.0;
        
        _state = vvcHiddenState;
    }
    return self;
}

#pragma mark -

- (void)updateWithObject:(id)targetContentObject
{
    self.targetContentObject =
    ([targetContentObject isKindOfClass:[NSString class]] ?
     [NSString stringWithString:targetContentObject] :
     targetContentObject);
    
    self.isReadyToShow = YES;
    
    //===
    
    switch (self.state)
    {
        case vvcHiddenState:
            [self prepareNextObject];
            break;
            
        case vvcShowingState:
            [self hideView];
            break;
            
        case vvcShownState:
            [self hideView];
            break;
            
        case vvcHidingState:
            //
            break;
            
        default:
            break;
    }
}

- (void)prepareNextObject
{
    if (self.targetContentObject)
    {
        self.currentObject = self.targetContentObject;
        self.targetContentObject = nil;
        self.isReadyToShow = NO;
        
        //===
        
        if (self.preparationBlock)
        {
            self.preparationBlock(self, self.currentObject);
        }
        
        //===
        
        if (self.showImmediately)
        {
            [self showView];
        }
    }
}

- (void)showView
{
    if ([self tryLock])
    {
        if (!self.showingBlock) // if not defined custom block...
        {
            // define default implementation:
            
            self.showingBlock = ^(UIView *targetView){
                targetView.alpha = 1.0;
            };
        }
        
        //===
        
        [UIView
         animateWithDuration:self.duration
         delay:self.delay // !!!
         options:UIViewAnimationOptionAllowAnimatedContent
         animations:^{
             
             if (!self.targetContentObject)
             {
                 [self.view show];
                 
                 self.state = vvcShowingState;
                 self.showingBlock(self.view);
             }
         }
         completion:^(BOOL finished) {
             
             [self unlock];
             
             //===
             
             if (self.state == vvcShowingState)
             {
                 self.state = vvcShownState;
                 
                 //===
                 
                 if (self.isReadyToHide)
                 {
                     self.isReadyToHide = NO;
                     [self hideView];
                 }
             }
             else
             {
                 self.state = vvcHiddenState;
             }
             
         }];
    }
    else
    {
        if (self.state == vvcHidingState)
        {
            self.isReadyToShow = YES;
        }
    }
}

- (void)hideView
{
    if (self.state != vvcHiddenState)
    {
        if ([self tryLock])
        {
            self.state = vvcHidingState;
            
            //===
            
            if (!self.hidingBlock) // if not defined custom block...
            {
                // define default implementation:
                
                self.hidingBlock = ^(UIView *targetView){
                    targetView.alpha = 0.0;
                };
            }
            
            //===
            
            [UIView
             animateWithDuration:self.duration
             animations:^{
                 
                 self.hidingBlock(self.view);
             }
             completion:^(BOOL finished) {
                 
                 [self unlock];
                 
                 //===
                 
                 self.state = vvcHiddenState;
                 
                 //===
                 
                 if (self.cleanupBlock)
                 {
                     self.cleanupBlock(self, self.currentObject);
                 }
                 
                 self.currentObject = nil;
                 
                 //===
                 
                 if (self.targetContentObject)
                 {
                     self.isReadyToShow = NO;
                     [self prepareNextObject];
                 }
                 else if (self.isReadyToShow)
                 {
                     self.isReadyToShow = NO;
                     [self showView];
                 }
             }];
        }
        else
        {
            if (self.state == vvcShowingState)
            {
                self.isReadyToHide = YES;
            }
        }
    }
}

@end
