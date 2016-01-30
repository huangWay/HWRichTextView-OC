//
//  HWEmotionTool.m
//  HWRichTextView-OC
//
//  Created by HuangWay on 16/1/28.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

#import "HWEmotionTool.h"
static NSArray *_emojiEmotions;
@implementation HWEmotionTool
+ (NSArray *)emojiEmotions {
    if (_emojiEmotions == nil) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"emoji.plist" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSMutableArray *mutArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *temp = [NSMutableArray array];
        for (id sub in mutArr) {
            if ([sub isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)sub;
                HWEmotion *emo = [HWEmotion emotionWithDict:dict];
                [temp addObject:emo];
            }
        }
        _emojiEmotions = [temp copy];
    }
    return _emojiEmotions;
}

@end
