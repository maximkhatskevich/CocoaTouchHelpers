//
//  ExtMutableArray+CTHPair.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 25/09/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "ExtMutableArray.h"

@class CTHPair;

@interface ExtMutableArray (CTHPair)

- (CTHPair *)pairForKey:(id)key;

@end
