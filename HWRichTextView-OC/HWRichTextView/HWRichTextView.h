//
//  HWRichTextView.h
//  HWRichTextView-OC
//
//  Created by HuangWay on 16/1/27.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWMatchResult.h"

@protocol HWRichTextViewDelegate <NSObject>
@optional

/**
 *  url点击
 *
 *  @param url
 */
- (void)urlClick:(NSString *)url;
/**
 *  @ 点击
 *
 *  @param at 暂且叫它@功能
 */
- (void)atFunctionClick:(NSString *)at;
/**
 *  话题点击
 *
 *  @param topic 话题
 */
- (void)topicClick:(NSString *)topic;
/**
 *  昵称点击＝＝＝特殊
 *
 *  @param niceName 昵称
 */
- (void)niceClick:(NSString *)niceName;
@end

typedef enum : NSUInteger {
    HWRichTextTypeUrl = 1, //url类型
    HWRichTextTypeAt = 2,       //@类型
    HWRichTextTypeTopic = 3,    //话题类型
    HWRichTextTypeNiceName = 4, //昵称点击
    HWRichTextTypeError = 99999,//不是正常的富文本
} HWRichTextType;

@interface HWRichTextView : UIView
/**
 *  显示文本的控件
 */
@property(nonatomic,strong) UITextView *textView;

@property(nonatomic,weak) id<HWRichTextViewDelegate> delegate;
/**
 *  选中区域高亮的颜色
 */
@property(nonatomic,strong) UIColor *highlightColor;
/**
 *  文本
 */
@property(nonatomic,copy) NSString *text;
/**
 *  富文本的颜色
 */
@property(nonatomic,strong) UIColor *attributeColor;
/**
 *  普通文本的颜色
 */
@property(nonatomic,strong) UIColor *normalColor;
/**
 *  字体
 */
@property(nonatomic,strong) UIFont *font;
/**
 *  是不是输入模式，如果是YES，那么就是textView；如果是NO，可以当UILabel用
 */
@property(nonatomic,assign) BOOL inputMode;
/**********************这两个特殊，应用在一些类似微博的内容里***************************/
/**
 *  特殊字符串（不容易用正则匹配出来），例如昵称(某些app保留的字符比较少)
 */
@property(nonatomic,copy) NSString *niceName;
/**
 *  昵称的颜色
 */
@property(nonatomic,strong) UIColor *niceColor;
/**
 *  特殊字符串
 */
@property(nonatomic,copy) NSString *special_One;
/**
 *  特殊字符串颜色
 */
@property(nonatomic,strong) UIColor *special_One_Color;
/**************************其它的富文本属性******************************************/
/**
 *  图片
 */
@property(nonatomic,strong) NSTextAttachment *attach;
/**
 *  其它的富文本属性
 */
- (void)addOtherAttributes:(NSDictionary *)attr range:(NSRange)range;
/**
 *  获取attributeString，用来计算尺寸
 *
 *  @return attributeString
 */
- (NSMutableAttributedString *)getAttributeString;
/**
 *  手动调用touchbegin里的方法，使得富文本控件可以点击
 */
- (void)enableClick:(CGPoint)point;
@end

@interface HWAttributeModel : NSObject
@property(nonatomic,strong) NSDictionary *attr;
@property(nonatomic,assign) NSRange range;
@end
