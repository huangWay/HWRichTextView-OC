//
//  HWTestVC.m
//  HWRichTextView-OC
//
//  Created by HuangWay on 16/1/28.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

#import "HWTestVC.h"

@implementation HWTestVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *webV = [[UIWebView alloc]initWithFrame:self.view.bounds];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [webV loadRequest:request];
    [self.view addSubview:webV];
    
}
@end
