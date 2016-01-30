//
//  HWRichTextView.m
//  HWRichTextView-OC
//
//  Created by HuangWay on 16/1/27.
//  Copyright © 2016年 HuangWay. All rights reserved.
//

#import "HWRichTextView.h"

@interface HWRichTextView()<UITextViewDelegate>
@property(nonatomic,strong) NSMutableArray *selectables;
@property(nonatomic,strong) UITextView *textView;
@property(nonatomic,strong) NSMutableArray *backgrounds;
@end

static NSString *url = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
static NSString *AtFunc = @"(@[^\\s]{1,}\\s)|(@[^\\s]{1,}$)";
static NSString *topic = @"#[^#]+#";

@implementation HWRichTextView
- (NSMutableArray *)backgrounds {
    if (_backgrounds == nil) {
        _backgrounds = [NSMutableArray array];
    }
    return _backgrounds;
}
- (NSMutableArray *)selectables {
    if (_selectables == nil) {
        _selectables = [NSMutableArray array];
    }
    return _selectables;
}
- (instancetype)init {
    if (self = [super init]) {
        _textView = [[UITextView alloc]init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        _textView.delegate = self;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self addSubview:_textView];
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.textView.frame = self.bounds;
    self.textView.attributedText = [self textAttributeWithText:self.text];
    
}
- (void)setInputMode:(BOOL)inputMode {
    _inputMode = inputMode;
    _textView.scrollEnabled = inputMode;
    _textView.userInteractionEnabled = inputMode;
    _textView.editable = inputMode;
}
-(NSAttributedString *)textAttributeWithText:(NSString *)text {
    if (text != nil && text.length > 0) {
        NSAttributedString *result = [self attributeStringWithText:text];
        NSMutableAttributedString *attrM = [[NSMutableAttributedString alloc]initWithAttributedString:result];
        if (self.normalColor == nil) {
            self.normalColor = [UIColor blackColor];
        }
        [attrM addAttribute:NSForegroundColorAttributeName value:self.normalColor range:NSMakeRange(0, text.length)];
        //要匹配其它的在这加
        [self attributeString:attrM withPattern:topic niceName:self.niceName];
        [self attributeString:attrM withPattern:AtFunc niceName:nil];
        [self attributeString:attrM withPattern:url niceName:nil];
        
        return [attrM copy];
    }
    return nil;
}
- (NSAttributedString *)attributeStringWithText:(NSString *)string {
    NSMutableArray *mutArr = [NSMutableArray array];
    HWStringMatching *strMatch = [HWStringMatching shareStringMatching];
    strMatch.matchType = @"emoji";
    NSString *emopattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    NSArray *emojis = [strMatch matchString:string pattern:emopattern];
    
    strMatch.matchType = @"notEmoji";
    NSArray *notEmojis = [strMatch separateString:string pattern:emopattern];
    [mutArr addObjectsFromArray:emojis];
    [mutArr addObjectsFromArray:notEmojis];
    
    [mutArr sortUsingComparator:^NSComparisonResult(HWMatchResult *obj1, HWMatchResult *obj2) {
        if (obj1.range.location < obj2.range.location) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];
    UIFont *font = self.font;
    if (font == nil) {
        font = [UIFont systemFontOfSize:17.f];
    }
    NSMutableAttributedString *attrM = [[NSMutableAttributedString alloc]init];
    for (HWMatchResult *matchRes in mutArr) {
        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:matchRes.cutStrs];
        [attrM appendAttributedString:attrStr];
    }
    [attrM addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attrM.length)];
    return attrM;
}
- (void)attributeString:(NSMutableAttributedString *)attributeString withPattern:(NSString *)pattern niceName:(NSString *)niceName{
    HWStringMatching *strMatch = [HWStringMatching shareStringMatching];
    NSArray *matchResults = [strMatch matchString:attributeString.string pattern:pattern];
    
    UIColor *color = self.attributeColor;
    if (color == nil) {
        color = [UIColor orangeColor];
    }
    
    if (niceName && niceName.length > 0) {
        NSArray *match = [strMatch matchSpecialString:self.niceName inString:attributeString.string];
        if (match.count == 1) {
            id matchRes = [match firstObject];
            if ([matchRes isKindOfClass:[HWMatchResult class]]) {
                HWMatchResult *result = (HWMatchResult *)matchRes;
                result.matchType = pattern;
                if (self.niceColor == nil) {
                    self.niceColor = [UIColor blackColor];
                }
                result.cutStrs = self.niceName;
                [attributeString addAttribute:NSForegroundColorAttributeName value:self.niceColor range:result.range];
                result.type = HWRichTextTypeNiceName;
                [self.selectables addObject:result];
            }
        }
    }
    HWRichTextType type = [self typeWithPattern:pattern];
    for (HWMatchResult *matchRes in matchResults) {
        [attributeString addAttribute:NSForegroundColorAttributeName value:color range:matchRes.range];
        matchRes.type = type;
        [self.selectables addObject:matchRes];
    }
}
- (HWRichTextType)typeWithPattern:(NSString *)pattern {
    if ([pattern isEqualToString:url]) {
        return HWRichTextTypeUrl;
    }else if ([pattern isEqualToString:AtFunc]) {
        return HWRichTextTypeAt;
    }else if ([pattern isEqualToString:topic]) {
        return HWRichTextTypeTopic;
    }
    return HWRichTextTypeError;
}
- (void)clickWithType:(HWRichTextType )type cutStr:(NSString *)cutStr{
    switch (type) {
        case HWRichTextTypeUrl:
            if ([self.delegate respondsToSelector:@selector(urlClick:)]) {
                [self.delegate urlClick:cutStr];
            }
            break;
        case HWRichTextTypeAt:
            if ([self.delegate respondsToSelector:@selector(atFunctionClick:)]) {
                [self.delegate atFunctionClick:cutStr];
            }
            break;
        case HWRichTextTypeTopic:
            if ([self.delegate respondsToSelector:@selector(topicClick:)]) {
                [self.delegate topicClick:cutStr];
            }
            break;
        case HWRichTextTypeNiceName:
            if ([self.delegate respondsToSelector:@selector(niceClick:)]) {
                [self.delegate niceClick:cutStr];
            }
            break;
        default:
            break;
    }
}
- (void)textViewDidChange:(UITextView *)textView {
    //记录一下光标
    NSRange range = textView.selectedRange;
    //这两个可以得到当前高亮选择的字（就是中文输入状态下，英文被选中的那个状态）
    UITextRange *selectRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectRange.start offset:0];
    
    if (!position) {
        self.textView.attributedText = [self textAttributeWithText:textView.text];
    }
    textView.selectedRange = range;
}
#pragma mark -----------------富文本区域点🐔-----------------------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    UITextRange *textRange = [self.textView characterRangeAtPoint:point];
    self.textView.selectedTextRange = textRange;
    NSRange range = self.textView.selectedRange;
    for (HWMatchResult *matchResult in self.selectables) {
        HWRichTextType type = HWRichTextTypeError;
        if (NSLocationInRange(range.location, matchResult.range)) {
            self.textView.selectedRange = matchResult.range;
            type = matchResult.type;
            NSArray *rects = [self.textView selectionRectsForRange:self.textView.selectedTextRange];
            
            for (UITextSelectionRect *rect in rects) {
                
                UIView *back = [[UIView alloc]init];
                
                UIColor *backColor = self.highlightColor;
                if (backColor == nil) {
                    backColor = [UIColor orangeColor];
                }
                back.backgroundColor = backColor;
                
                back.frame = rect.rect;
                
                back.layer.cornerRadius = 5;
                
                back.layer.masksToBounds = YES;
                
                back.alpha = 0.5;
                
                [self.textView insertSubview:back atIndex:0];
                
                [self.backgrounds addObject:back];
            }
            if (type != HWRichTextTypeError) {
                [self clickWithType:type cutStr:matchResult.cutStrs];
            }
            break;
        }
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UIView *view in self.backgrounds) {
        [view removeFromSuperview];
    }
    [self.backgrounds removeAllObjects];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

@end
