//
//  RemoteImageView.h
//  Toni&Guy-SE-iOS
//
//  Created by Maxim Khatskevich on 6/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import <UIKit/UIKit.h>

//===

@class WebVisibilityCtrl;

@interface RemoteImageView : UIImageView

@property (readonly, nonatomic) WebVisibilityCtrl *updateCtrl;
@property (readonly, nonatomic) UIWebView *webView;

@end
