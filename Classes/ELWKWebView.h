//
//  ELWebView.h
//  ELWebView
//
//  Created by xlitao on 2017/5/18.
//  Copyright © 2017年 eloancn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ELWKWebView : WKWebView

/**
 *  请求
 *
 *  @param url @"https://www.baidu.com"
 */
- (void)loadRequestWithUrl:(NSString *_Nonnull)url;
/**
 *  带参数 GET
 *
 *  @param url @"https://www.baidu.com"
 *  @param params @{@"name":@"jack"...}
 */
- (void)loadRequestWithUrl:(NSString *_Nonnull)url params:(NSDictionary *_Nullable)params;
/**
 *  带参数 POST
 *
 *  @param url @"https://www.baidu.com"
 *  @param params @{@"name":@"jack"...}
 */
- (void)loadPOSTRequestWithUrl:(NSString *_Nonnull)url params:(NSDictionary *_Nonnull)params;

/**
 *  调用JS方法（无返回值）
 *
 *  @param jsMethod @"jsMethod（)" or "jsMethod（‘name’，‘age’)"
 */
- (void)callJS:(nonnull NSString *)jsMethod;

/**
 *  调用JS方法（可处理返回值）
 *
 *  @param jsMethod @"jsMethod（)" or "jsMethod（‘name’，‘age’)"
 *  @param handler  回调block
 */
- (void)callJS:(nonnull NSString *)jsMethod handler:(nullable void(^)(__nullable id response))handler;

/**
 *  加载本地HTML页面
 *
 *  @param htmlName html页面文件名称
 */
- (void)loadLocalHTMLWithFileName:(nonnull NSString *)htmlName;

/**
 *  重新加载webview
 */
- (void)reloadWebView;

@end
