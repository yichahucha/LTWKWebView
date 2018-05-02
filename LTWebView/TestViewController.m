//
//  TestViewController.m
//  LTWebView
//
//  Created by xlitao on 2017/5/18.
//  Copyright © 2017年 me. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //加载测试HTML
    [self.webView loadLocalHTMLWithFileName:@"test"];
    //添加监听方法（js调用oc方法）
    [self.webView addScriptMessage:@"calloc"];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [super webView:webView didFinishNavigation:navigation];
    
    //调用js的方法(test.js里边的方法 "calljs()")，需等到webview加载完成
    [self.webView callJS:@"calljs('js方法被调用')"];
}

-(void)webView:(LTWKWebView *)webview didReceivedScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"calloc"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message.body preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
@end
