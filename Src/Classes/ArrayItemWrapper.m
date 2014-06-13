//
//  ArrayItemWrapper.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 14/06/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import "ArrayItemWrapper.h"

@implementation ArrayItemWrapper

+ (instancetype)wrapperWithContent:(id)content
{
    return [self wrapperWithContent:content selected:NO];
}

+ (instancetype)wrapperWithContent:(id)content selected:(BOOL)selected
{
    ArrayItemWrapper *result = [ArrayItemWrapper new];
    
    //===
    
    result.content = content;
    result.selected = selected;
    
    //===
    
    return result;
}

@end
