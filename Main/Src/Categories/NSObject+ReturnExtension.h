//
//  NSObject+ReturnExtension.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 03/09/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

//===

typedef void (^CTHReturnBlock)(id aValue);

//===

@interface NSObject (ReturnExtension)

@property (strong, nonatomic) CTHReturnBlock onReturn;

- (void)setOnReturn:(CTHReturnBlock)onReturn;

- (void)returnWithValue:(id)aValue;
- (IBAction)returnDefaultHandler:(id)sender;

@end
