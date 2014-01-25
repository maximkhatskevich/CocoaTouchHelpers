//
//  ResultContainer.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 1/25/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultContainer : NSObject

@property (readonly, nonatomic) id content;
@property (readonly, nonatomic) NSError *error;

@property (readonly) BOOL isFilled;
@property (readonly) BOOL shouldWait;

- (void)wait;
- (void)fillWithContent:(id)content andError:(NSError *)error;
- (void)reset; // for re-use

@end
