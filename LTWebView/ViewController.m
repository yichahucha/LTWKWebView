//
//  ViewController.m
//  LTWebView
//
//  Created by xlitao on 2017/5/18.
//  Copyright © 2017年 me. All rights reserved.
//

#import "ViewController.h"
#import "LTWKWebView.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"LTWKWebView";
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.text = @"点击";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    TestViewController *vc = [[TestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
