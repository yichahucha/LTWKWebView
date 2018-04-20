//
//  LTWebViewController.h
//  LTWebView
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

@interface ELWKWebViewController : UIViewController <WKNavigationDelegate ,ELWKWebViewMessageHandlerDelegate> //子类可以重写父类实现的代理
/*
 *  webview
 */
@property (nonatomic ,strong) ELWKWebView *webView;

/*
 *  请求url字符串
 */
@property (nonatomic ,copy) NSString *url;

/*
 *  参数 （默认无参数）
 */
@property (nonatomic ,copy) NSDictionary *params;

/*
 *  请求类型 （默认GET）
 */
@property (nonatomic ,assign) WebRequestType requestType;

/*
 *  标题 （默认显示h5的'title'）
 */
@property (nonatomic ,copy) NSString *webTitle;

@end
