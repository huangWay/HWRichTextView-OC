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
    rich.text = @"屌得飞起:危旧房屋@好友的名字老长了， 金额放假啊放假啊http://baidu.com是一个好网站一二三文啊饿啊饿啊我哎哟喂我看看流量较大空间打开";
    rich.normalColor = [UIColor greenColor];
    rich.attributeColor = [UIColor blueColor];
    rich.highlightColor = [UIColor blueColor];
    rich.niceName = @"屌得飞起:";
    rich.inputMode = NO;
    rich.niceColor = [UIColor redColor];
    rich.special_One = @"哎哟喂我看看";
    rich.special_One_Color = [UIColor orangeColor];
    rich.delegate = self;
//    rich.frame = CGRectMake(0, 100, 320, 400);
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithWhite:0 alpha:0.5f];
    shadow.shadowOffset = CGSizeMake(0.5, 0);
    [rich addOtherAttributes:@{NSShadowAttributeName:shadow,NSVerticalGlyphFormAttributeName:@0} range:NSMakeRange(0, rich.text.length)];
    
    
    UIFont *font = [UIFont systemFontOfSize:15.f];
    UIImage *img = [UIImage imageNamed:@"JULiveGift_car"];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = img;
    attach.bounds = (CGRect){0,-3,font.lineHeight,font.lineHeight};
//    NSDictionary *test = @{NSShadowAttributeName:shadow,NSVerticalGlyphFormAttributeName:@0};
    rich.attach = attach;
    
    
//    CGSize size = [rich.textView.text boundingRectWithSize:CGSizeMake(320, MAXFLOAT) options: context:nil].size;
//    CGSize size = [rich.text boundingRectWithSize:CGSizeMake(320, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    CGSize size = [[rich getAttributeString] boundingRectWithSize:CGSizeMake(320, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    rich.frame = (CGRect){0, 100,size};
    [self.view addSubview:rich];
//    [rich addAttributes:test attatch:attach];
    
    
    UIAlertController *altC = [UIAlertController alertControllerWithTitle:@"title" message:@"msg" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [altC addAction:actCancle];
    [altC addAction:sure];
    [self presentViewController:altC animated:YES completion:^{
        
    }];
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
