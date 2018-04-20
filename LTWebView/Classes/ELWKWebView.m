//
//  LTWebView.m
//  LTWebView
//
//  Created by xlitao on 2017/5/18.
//  Copyright © 2017年 eloancn. All rights reserved.
//

#import "ELWKWebView.h"

@interface ELWKWebView ()   <WKScriptMessageHandler>
@property (nonatomic ,strong) NSURLRequest *URLRequest;
@end

@implementation ELWKWebView

- (void)reloadWebView {
    [self loadRequest:_URLRequest];
}

- (void)loadRequestWithUrl:(NSString *)url {
    [self loadRequestWithUrl:url params:nil];
}

- (void)loadRequestWithUrl:(NSString *)url params:(NSDictionary *)params{
    
    NSURL *URL = [self generateUrl:url params:params];
    _URLRequest = [NSURLRequest requestWithURL:URL];
    [self loadRequest:_URLRequest];
}

- (void)loadPOSTRequestWithUrl:(NSString *)url params:(NSDictionary *)params {
    NSURL *URL = [self dealRelativeUrl:url];
    NSString *body = [self dealParams:params];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    _URLRequest = request;
    [self loadRequest:_URLRequest];
}

- (void)loadLocalHTMLWithFileName:(nonnull NSString *)htmlName {
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:htmlName
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    
    [self loadHTMLString:htmlCont baseURL:baseURL];
}

- (void)callJS:(nonnull NSString *)jsMethod {
    [self callJS:jsMethod handler:nil];
}

- (void)callJS:(nonnull NSString *)jsMethod handler:(nullable void(^)(__nullable id response))handler {
    [self evaluateJavaScript:jsMethod completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (handler) {
            handler(response);
        }
    }];
}

- (void)addScriptMessage:(NSString *_Nonnull)name {
    [self.configuration.userContentController addScriptMessageHandler:self name:name];
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (_messageHandlerDelegate && [_messageHandlerDelegate respondsToSelector:@selector(webView:didReceivedScriptMessage:)]) {
        [self.messageHandlerDelegate webView:self didReceivedScriptMessage:message];
    }
}

- (NSURL *)generateUrl:(NSString*)baseURL params:(NSDictionary*)params {
    NSString *query = [self dealParams:params];
    baseURL = [baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* url = @"";
    if ([baseURL containsString:@"?"]) {
        url = [NSString stringWithFormat:@"%@&%@",baseURL, query];
    }
    else {
        url = [NSString stringWithFormat:@"%@?%@",baseURL, query];
    }
    NSURL *URL = [self dealRelativeUrl:url];
    return URL;
}

-(NSString *)dealParams:(NSDictionary *)params {
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:params];
    
    NSMutableArray* pairs = [NSMutableArray array];
    
    for (NSString* key in param.keyEnumerator) {
        
        NSString *value = [NSString stringWithFormat:@"%@",[param objectForKey:key]];
        
        NSString* escaped_value = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                        (__bridge CFStringRef)value,
                                                                                                        NULL,                                          (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                                        kCFStringEncodingUTF8);
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

-(NSURL *)dealRelativeUrl:(NSString *)url {
    //绝对路径
    if ([url.lowercaseString hasPrefix:@"http"]) {
        return [NSURL URLWithString:url];
    }
    //相对路径
    else {
        return [NSURL URLWithString:url relativeToURL:[NSURL URLWithString:@""]];
    }
}
@end
