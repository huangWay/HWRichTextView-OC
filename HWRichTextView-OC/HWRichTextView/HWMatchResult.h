//
//  HWMatchResult.h
//  HWRichTextView-OC
//
//  Created by HuangWay on 16/1/27.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWMatchResult : NSObject
/**
 *  匹配结果的范围
 */
@property(nonatomic,assign) NSRange range;
/**
 *  匹配结果后截取的字符串
 */
@property(nonatomic,copy) NSString *cutStrs;
/**
 *  匹配类型
 */
@property(nonatomic,copy) NSString *matchType;
/**
 *  类型
 */
@property(nonatomic,assign) NSInteger type;
//
+(instancetype)result;

@end

@interface HWStringMatching : NSObject
/**
 *  匹配类型的标识，会添加到HWMatchResult的matchType
 */
@property(nonatomic,copy) NSString *matchType;


+(instancetype)shareStringMatching;
/**
 *  匹配指定字符串
 *
 *  @param specialString 指定字符串
 *  @param string 原始字符串
 *
 *  @return HWMatchResult类型的数组
 */
- (NSArray *)matchSpecialString:(NSString *)specialString inString:(NSString *)string;
/**
 *  根据正则表达式匹配结果
 *
 *  @param string  被匹配的字符串
 *  @param pattern 正则表达式
 *
 *  @return HWMatchResult类型的数组
 */
- (NSArray *)matchString:(NSString *)string pattern:(NSString *)pattern;
/**
 *  按照正则拆分字符串，返回未匹配的结果
 *
 *  @param string  被匹配的字符串
 *  @param pattern 正则表达式
 *
 *  @return 未被匹配的NSString数组
 */
- (NSArray *)separateString:(NSString *)string pattern:(NSString *)pattern;
@end