//
//  UITableView+Helpers.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 4/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "UITableView+Helpers.h"

#import "MacrosBase.h"

@implementation UITableView (Helpers)

- (void)selectFirstRow
{
    NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self selectRowAtIndexPath:targetIndexPath
                      animated:YES
                scrollPosition:UITableViewScrollPositionTop];
    
    [self.delegate tableView:self didSelectRowAtIndexPath:targetIndexPath];
}

- (void)registerNibWithName:(NSString *)nibName forCellReuseIdentifier:(NSString *)reuseIdentifier
{
    if (isNonZeroString(nibName))
    {
        [self
         registerNib:[UINib nibWithNibName:nibName bundle:nil]
         forCellReuseIdentifier:reuseIdentifier];
    }
}

@end
