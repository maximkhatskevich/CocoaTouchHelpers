//
//  NSObject+Observers.h
//  Rezzie
//
//  Created by Maxim Khatskevich on 12/10/13.
//  Copyright (c) 2013 SixAgency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <THObserversAndBinders/THObserversAndBinders.h>

@interface NSObject (Observers)

@property (readonly, nonatomic) NSMutableArray *observerList;

- (void)removeObservers;

@end
