//
//  TestViewController.m
//  LTWebView
//
//  Created by xlitao on 2017/5/18.
//  Copyright © 2017年 eloancn. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

-(void)dealloc
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadLocalHTMLWithFileName:@"test"];
    //添加监听方法名
    [self.webView addScriptMessage:@"test"];
    [self.webView addScriptMessage:@"test2"];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [super webView:webView didFinishNavigation:navigation];
}

-(void)webView:(ELWKWebView *)webview didReceivedScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"test"]) {
        //NSString *method = [NSString stringWithFormat:@"callJs('%@')",message.body];
        //[self.webView callJS:method handler:^(id  _Nullable response) {}];
    }else if ([message.name isEqualToString:@"test2"]) {
        
    }
}
@end
