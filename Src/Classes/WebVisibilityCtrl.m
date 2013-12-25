//
//  WebVisibilityCtrl.m
//  CocoaTouchHelpers
//
//  Created by Maxim Khatskevich on 4/26/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "WebVisibilityCtrl.h"

@interface WebVisibilityCtrl () <UIWebViewDelegate>

@end

@implementation WebVisibilityCtrl

#pragma mark - Creation

+ (id)ctrlWithWebView:(UIWebView *)targetWebView
      HTMLPreparation:(HTMLPreparationBlock)htmlPreparationBlock
{
    // will use default implementation of preparationBlock
    // together with HTMLStringPreparationBlock result
    
    WebVisibilityCtrl *result =
    [[self class]
     ctrlWithView:targetWebView
     preparation:^(ViewVisibilityCtrl *ctrl, id targetContentObject) {
         
         ctrl.showImmediately = NO;
         
         NSString *trimmedStr =
         [targetContentObject stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceAndNewlineCharacterSet]];
         [targetWebView
          loadHTMLString:htmlPreparationBlock(trimmedStr)
          baseURL:nil];
     }];
    
    //===
    
    return result;
}

#pragma mark - Overrided methods

+ (id)ctrlWithView:(UIView *)targetView
       preparation:(PreparationBlock)preparationBlock
{
    WebVisibilityCtrl *result =
    [super ctrlWithView:targetView
            preparation:preparationBlock];
    
    //===
    
    if ([targetView isKindOfClass:[UIWebView class]])
    {
        ((UIWebView *)targetView).delegate = result;
    }
    
    //===
    
    return result;
}

- (void)dealloc
{
    [self unlock];
    
    if ([self.view isKindOfClass:[UIWebView class]])
    {
        UIWebView *webView = (UIWebView *)self.view;
        
        for (id subview in webView.subviews){
            if ([[subview class] isSubclassOfClass:[UIScrollView class]])
            {
                [subview setContentOffset:CGPointZero animated:NO];
            }
        }
        
        webView.delegate = nil;
        [webView stopLoading];
    }
}

#pragma mark - WebView notifications handlers

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self showView];
}

@end
