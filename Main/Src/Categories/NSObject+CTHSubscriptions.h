//
//  NSObject+CTHSubscriptions.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 30/09/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CTHSubscriptions)

- (NSMapTable *)subscriptionForKey:(NSString *)subscriptionKey;

@end
