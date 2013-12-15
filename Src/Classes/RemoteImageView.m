//
//  RemoteImageView.m
//  MyHelpers
//
//  Created by Maxim Khatskevich on 6/16/13.
//  Copyright (c) 2013 Maxim Khatskevich. All rights reserved.
//

#import "RemoteImageView.h"

//===

NSString *webViewSnippetTemplateTransparent = @"\
<html><head>\
<style type=\"text/css\">\
body {\
background-color: transparent;\
color: white;\
margin: 0;\
margin-top:0;\
}\
</style>\
</head><body> \
<img src=\"%@\" width=\"%f\">\
</body></html>";

//===

@interface RemoteImageView ()

@property (weak, nonatomic) UIWebView *webView;
@property (strong, nonatomic) WebVisibilityCtrl *updateCtrl;

@end

@implementation RemoteImageView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //===
    
    UIWebView *webView = [UIWebView newWithSuperview:self];
    
    webView.autoresizingMask = UIViewAutoresizingAll;
    webView.userInteractionEnabled = NO;
    webView.opaque = YES;
    webView.backgroundColor = [UIColor clearColor];
    
    self.webView = webView;
    
    //===
    
    weakSelfMacro;
    
    self.updateCtrl =
    [WebVisibilityCtrl
     ctrlWithWebView:self.webView
     HTMLPreparation:^NSString *(id targetContentObject) {
         return [NSString
                 stringWithFormat:
                 webViewSnippetTemplateTransparent,
                 targetContentObject,
                 weakSelf.webView.frame.size.width];
     }];
}

- (void)configureWithObject:(id)object
{
    [super configureWithObject:object];
    
    //===
    
    if (!object) // nil
    {
        [self.updateCtrl hideView];
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        // it should be a remote image URL
        
        object =
        [object
         stringByTrimmingCharactersInSet:
         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [self.updateCtrl updateWithObject:object];
    }
}

- (void)hideAnimated
{
    [super hideAnimated];
    
    //===
    
    [self.updateCtrl hideView];
}

@end
