//
//  LTWebViewController.m
//  LTWebView
//
//  Created by xlitao on 2017/5/18.
//  Copyright © 2017年 eloancn. All rights reserved.
//

#import "ELWKWebViewController.h"

@interface ELWKWebViewController () <WKUIDelegate ,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *closeBarButtonItem;
@property (nonatomic, strong) id <UIGestureRecognizerDelegate>delegate;
@property (nonatomic, strong) UIProgressView *loadingProgressView;

@end

@implementation ELWKWebViewController

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.loadingProgressView];
    
    [self showLeftBarButtonItem];
    [self setUpPropertyKVO];
    
    if (self.url.length > 0) {
        if (self.params) {
            if (self.requestType == POST) {
                [self.webView loadPOSTRequestWithUrl:self.url params:self.params];
            }else {
                [self.webView loadRequestWithUrl:self.url params:self.params];
            }
        }else {
            [self.webView loadRequestWithUrl:self.url];
        }
    }else {
        //异常处理
    }
    
    //[self.webView addScriptMessage:@""];
}

#pragma mark --手势失效
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        self.delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self.delegate;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.navigationController.viewControllers.count > 1;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

#pragma mark --属性监听
- (void)setUpPropertyKVO {
    //监听标题
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    //进度
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        if (self.webTitle.length == 0) {
            self.title = self.webView.title;
        }
    }else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self progressChanged:change[NSKeyValueChangeNewKey]];
    }
}

#pragma mark-- WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"%s：%@", __FUNCTION__,webView.URL);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
    [self showLeftBarButtonItem];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s %@", __FUNCTION__ ,error);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    NSLog(@"%s", __FUNCTION__);
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"URL: %@", navigationAction.request.URL.absoluteString);
    decisionHandler(WKNavigationActionPolicyAllow);
}

//https 权限认证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}
#pragma mark --ELWKWebViewMessageHandlerDelegate
-(void)webView:(ELWKWebView *)webview didReceivedScriptMessage:(WKScriptMessage *)message {
    //message.name判断可以知道监听的是JS的哪个方法
    //message.body就是JS传过来的参数，可以是字符串，可以是数组，也可以是字典
    //js开发人员必须这样实现 window.webkit.messageHandlers. Share.postMessage(null) "Share"为方法名
    //if ([message.name isEqualToString:@"openPage"]) {}
}
#pragma mark - WKUIDelegate

/**
 *  处理js里的alert
 *
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  处理js里的confirm
 */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(ELWKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        _webView = [[ELWKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.messageHandlerDelegate = self;
        //开启侧滑返回效果
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    return _webView;
}

#pragma mark -- nav button
- (void)showLeftBarButtonItem {
    if ([_webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.backBarButtonItem,self.closeBarButtonItem];
    } else {
        self.navigationItem.leftBarButtonItem = self.backBarButtonItem;
    }
}

- (UIBarButtonItem*)backBarButtonItem {
    if (!_backBarButtonItem) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_back-whitebackground(22x22)"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 22, 22);
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem*)closeBarButtonItem {
    if (!_closeBarButtonItem) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        [button addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 35, 22);
        _closeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _closeBarButtonItem;
}

- (void)back:(UIBarButtonItem*)item {
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)close:(UIBarButtonItem*)item {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --progress
- (UIProgressView*)loadingProgressView {
    if (!_loadingProgressView) {
        _loadingProgressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 2)];
        _loadingProgressView.progressTintColor = [UIColor redColor];
        _loadingProgressView.trackTintColor = [UIColor clearColor];
    }
    return _loadingProgressView;
}

- (void)progressChanged:(NSNumber *)newValue {
    if (self.loadingProgressView.alpha == 0) {
        self.loadingProgressView.alpha = 1.f;
    }
    
    [self.loadingProgressView setProgress:newValue.floatValue animated:YES];
    
    if (self.loadingProgressView.progress == 1) {
        [UIView animateWithDuration:.5f animations:^{
            self.loadingProgressView.alpha = 0;
        } completion:^(BOOL finished) {
            self.loadingProgressView.progress = 0;
        }];
    } else if (self.loadingProgressView.alpha == 0){
        [UIView animateWithDuration:.1f animations:^{
            self.loadingProgressView.alpha = 1.f;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
