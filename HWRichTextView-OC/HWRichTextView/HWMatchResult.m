//
//  HWMatchResult.m
//  HWRichTextView-OC
//
//  Created by HuangWay on 16/1/27.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

#import "HWMatchResult.h"

@implementation HWMatchResult
+ (instancetype)result{
    return [[self alloc]init];
}

@end

@implementation HWStringMatching

static HWStringMatching *_instance;
+(instancetype)shareStringMatching{
    if (_instance == nil) {
        _instance = [[self alloc]init];
    }
    return _instance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (NSArray *)matchSpecialString:(NSString *)specialString inString:(NSString *)string {
    NSMutableArray *resultM = [NSMutableArray array];
    if (specialString && specialString.length > 0) {
        NSRange range = [string rangeOfString:specialString];
        if (range.length > 0) {
            HWMatchResult *matchResult = [HWMatchResult result];
            matchResult.range = range;
            matchResult.cutStrs = specialString;
            matchResult.matchType = @"specialString";
            [resultM addObject:matchResult];
        }
    }
    return [resultM copy];
}
- (NSArray *)matchString:(NSString *)string pattern:(NSString *)pattern {
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"%s_%@",__func__,error);
    }
    NSArray *results = [expression matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    
    NSMutableArray *resultM = [NSMutableArray array];
    for (NSTextCheckingResult *result in results) {
        HWMatchResult *matchResult = [HWMatchResult result];
        matchResult.range = result.range;
        matchResult.cutStrs = [string substringWithRange:result.range];
        if (self.matchType) {
            matchResult.matchType = self.matchType;
        }
        [resultM addObject:matchResult];
    }
    return [resultM copy];
}

- (NSArray *)separateString:(NSString *)string pattern:(NSString *)pattern {
    NSArray *matchedResults = [self matchString:string pattern:pattern];
    NSMutableArray *noMatchedResults = [NSMutableArray array];
    if (matchedResults.count == 0) {
        HWMatchResult *noMatchResult = [HWMatchResult result];
        noMatchResult.range = NSMakeRange(0, string.length);
        noMatchResult.cutStrs = [string substringWithRange:noMatchResult.range];
        noMatchResult.matchType = self.matchType;
        [noMatchedResults addObject:noMatchResult];
    }
    
    [matchedResults enumerateObjectsUsingBlock:^(HWMatchResult *matchResult, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            if (matchResult.range.location != 0) {
                HWMatchResult *nomatch = [HWMatchResult result];
                nomatch.range = matchResult.range;
                nomatch.cutStrs = [string substringWithRange:matchResult.range];
                nomatch.matchType = self.matchType;
                [noMatchedResults addObject:nomatch];
            }
            return;
        }
        
        if (idx > 0) {
            HWMatchResult *preResult = noMatchedResults[idx - 1];
            NSUInteger endPosition = preResult.range.location + preResult.range.length;
            if (matchResult.range.location != endPosition) {
                HWMatchResult *nomatch = [HWMatchResult result];
                nomatch.range = NSMakeRange(endPosition, matchResult.range.location - endPosition);
                nomatch.cutStrs = [string substringWithRange:nomatch.range];
                nomatch.matchType = self.matchType;
                [noMatchedResults addObject:nomatch];
            }
        }
        
        if (idx == matchedResults.count - 1) {
            NSUInteger endPosition = matchResult.range.location + matchResult.range.length;
            if (endPosition != string.length) {
                HWMatchResult *nomatch = [HWMatchResult result];
                nomatch.range = NSMakeRange(endPosition, string.length - endPosition);
                nomatch.cutStrs = [string substringWithRange:nomatch.range];
                nomatch.matchType = self.matchType;
                [noMatchedResults addObject:nomatch];
            }
        }
    }];
    return [noMatchedResults copy];
}
@end