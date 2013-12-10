//
//  NSObject+Observers.h
//  MyHelpers
//
//  Created by Maxim Khatskevich on 12/10/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <THObserversAndBinders/THObserversAndBinders.h>

@interface NSObject (Observers)

@property (readonly, nonatomic) NSMutableArray *observerList;

- (void)removeObservers;

@end
