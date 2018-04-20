//
//  ELWebViewController.h
//  ELWebView
//
//  Created by xlitao on 2017/5/18.
//  Copyright © 2017年 eloancn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELWKWebView.h"

typedef NS_OPTIONS(NSUInteger, WebRequestType) {
    GET = 1,
    POST = 2
};

@interface ELWKWebViewController : UIViewController <WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic ,strong) ELWKWebView *webView;
@property (nonatomic ,copy) NSString *url; //url
@property (nonatomic ,copy) NSDictionary *params; //参数
@property (nonatomic ,assign) WebRequestType requestType; //请求类型
@end
