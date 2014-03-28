//
//  ExtMutableArray.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 28/03/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "ExtMutableArray.h"

@interface ExtMutableArray ()

// backing store
@property (readonly, nonatomic) NSMutableArray *store;

@end

@implementation ExtMutableArray
{
    NSMutableArray *_store;
}

- (NSMutableArray *)store
{
    @synchronized(self)
    {
        if (_store)
        {
            _store = [NSMutableArray array];
        }
        
        return _store;
    }
}

#pragma mark - Overrided methods



@end
