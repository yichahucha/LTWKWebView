//
//  LTWebView.h
//  LTWebView
//
//  Created by xlitao on 2017/5/18.
//  Copyright © 2017年 me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class LTWKWebView;

@protocol ELWKWebViewMessageHandlerDelegate <NSObject>
-(void)webView:(LTWKWebView *_Nonnull)webview didReceivedScriptMessage:(WKScriptMessage *_Nullable)message;

@end

@interface LTWKWebView : WKWebView

@property (nonatomic ,weak) _Nullable id <ELWKWebViewMessageHandlerDelegate>messageHandlerDelegate;

#pragma mark-- 请求
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
 *  加载本地HTML页面
 *
 *  @param htmlName html页面文件名称
 */
- (void)loadLocalHTMLWithFileName:(nonnull NSString *)htmlName;

/**
 *  重新加载webview
 */
- (void)reloadWebView;

#pragma mark --oc调用js方法
/**
 *  调用JS方法（无返回值）
 *
 *  @param jsMethod @"jsMethod（)" or "jsMethod（'name'，'age')"
 */
- (void)callJS:(nonnull NSString *)jsMethod;

/**
 *  调用JS方法（可处理返回值）
 *
 *  @param jsMethod @"jsMethod（)" or "jsMethod（'name'，'age')"
 *  @param handler  回调block
 */
- (void)callJS:(nonnull NSString *)jsMethod handler:(nullable void(^)(__nullable id response))handler;

#pragma mark --js调用oc方法
/**
 *  js调用oc监听的方法名
 *
 *  @param name 监听的方法名要和JS开发的人商量好
 */
- (void)addScriptMessage:(NSString *_Nonnull)name;
@end
