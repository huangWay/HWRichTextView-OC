//
//  ViewController.m
//  HWRichTextView-OC
//
//  Created by HuangWay on 16/1/27.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

#import "ViewController.h"
//#import "PPSSignatureView.h"
#import "HWRichTextView.h"
#import "HWTestVC.h"
@interface ViewController ()<HWRichTextViewDelegate>
//@property(nonatomic,strong) PPSSignatureView *signatureView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor lightGrayColor];
//    PPSSignatureView *signatureView = [[PPSSignatureView alloc]initWithFrame:self.view.bounds context:[EAGLContext currentContext]];
//    signatureView.backgroundColor = [UIColor redColor];
//    signatureView.strokeColor = [UIColor blackColor];
//    [self.view addSubview:signatureView];
//    self.signatureView = signatureView;
    
    HWRichTextView *rich = [[HWRichTextView alloc] init];
    rich.text = @"屌得飞起:危旧房屋@好友的名字老长了，长的飞起 金额放假啊放假啊http://baidu.com是一个好网站一二三文啊饿啊饿啊我";
    rich.normalColor = [UIColor greenColor];
    rich.attributeColor = [UIColor blueColor];
    rich.highlightColor = [UIColor blueColor];
    rich.niceName = @"屌得飞起:";
    rich.inputMode = YES;
    rich.niceColor = [UIColor redColor];
    rich.delegate = self;
    rich.frame = CGRectMake(0, 100, 320, 400);
    [self.view addSubview:rich];
}
- (void)urlClick:(NSString *)url {
    HWTestVC *vc = [[HWTestVC alloc]init];
    vc.url = url;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)niceClick:(NSString *)niceName {
    NSLog(@"点击了昵称，昵称是：%@",niceName);
}
- (void)atFunctionClick:(NSString *)at {
    NSLog(@"点击了@功能：%@",at);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)clear:(UIButton *)sender {
//    [self.signatureView erase];
//}

@end
