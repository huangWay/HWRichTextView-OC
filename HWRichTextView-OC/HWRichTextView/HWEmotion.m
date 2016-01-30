//
//  HWEmotion.m
//  HWRichTextView-OC
//
//  Created by HuangWay on 16/1/28.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

#import "HWEmotion.h"

@implementation HWEmotion
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)emotionWithDict:(NSDictionary *)dict {
    return [[self alloc]initWithDict:dict];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}
@end
