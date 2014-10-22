//
//  CTHRequestResult.h
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 22/10/14.
//  Copyright (c) 2014 Maxim Khatskevich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTHRequestResult : NSObject

@property (strong, nonatomic) NSError *error;

@property (copy, nonatomic) NSDictionary *parameters;
@property (copy, nonatomic) NSURLRequest *originalRequest;
@property (copy, nonatomic) NSURLResponse *response;

@property (readonly, strong, nonatomic) id content;

- (void)wait;
- (void)allowToProceed;

@end
