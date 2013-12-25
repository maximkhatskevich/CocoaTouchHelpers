//
//  UIResponder+Helpers.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 5/27/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "UIResponder+Helpers.h"

#import "mach/mach.h"

static UIPopoverController *_currentPopover = nil;

@implementation UIResponder (Helpers)

#pragma mark - Property accessors

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

- (UIStoryboard *)currentStoryboard
{
    return [UIStoryboard currentStoryboard];
}

- (UIView *)firstResponder
{
    // http://www.cocoawithlove.com/2009/04/showing-message-over-iphone-keyboard.html
    // (see at the end of the article)
    
    return [[[UIApplication sharedApplication] keyWindow]
            performSelector:@selector(firstResponder)];
}

- (UIPopoverController *)currentPopover
{
    return _currentPopover;
}

- (void)setCurrentPopover:(UIPopoverController *)newValue
{
    if (_currentPopover != newValue)
    {
        if (_currentPopover) {
            // dissmiss the current one before set a new one:
            [_currentPopover dismissPopoverAnimated:YES]; // animated by default
        }
        
        _currentPopover = newValue;
    }
}

#pragma mark - Helpers

+ (UIPopoverController *)currentPopover
{
    return _currentPopover;
}

- (void)showMem
{
#ifdef DEBUG
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    /*kern_return_t kerr =*/ task_info(mach_task_self(),
                                       TASK_BASIC_INFO,
                                       (task_info_t)&info,
                                       &size);
    
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    
    host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    
    vm_size_t currentMem = info.resident_size;
    currentMem /= 1000000;
    
    NSLog(@"Memory in use (in MB): %lu", (unsigned long)currentMem);
#endif
}

@end
