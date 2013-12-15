//
//  WebVisibilityCtrl.h
//  MyHelpers
//
//  Created by Maxim Khatskevich on 4/26/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "ViewVisibilityCtrl.h"

typedef NSString *(^HTMLPreparationBlock)(id targetContentObject);

@interface WebVisibilityCtrl : ViewVisibilityCtrl

+ (id)ctrlWithWebView:(UIWebView *)targetWebView
      HTMLPreparation:(HTMLPreparationBlock)htmlPreparationBlock;

@end
