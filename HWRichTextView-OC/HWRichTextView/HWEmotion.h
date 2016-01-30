//
//  HWEmotion.h
//  HWRichTextView-OC
//
//  Created by HuangWay on 16/1/28.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWEmotion : NSObject
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *type;
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)emotionWithDict:(NSDictionary *)dict;
@end
