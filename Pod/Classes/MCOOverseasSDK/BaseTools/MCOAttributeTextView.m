//
//  MCOAttributeTextView.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/14.
//

#import "MCOAttributeTextView.h"

@implementation MCOAttributeTextView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.myTextView];
    }
    return self;
    
}

-(UITextView *)myTextView{
    if (!_myTextView) {
        self.myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.myTextView.delegate = self;
        self.myTextView.editable = NO;
        self.myTextView.scrollEnabled = NO;
    }
    return _myTextView;
}

- (void)setTitleTapColor:(UIColor *)titleTapColor{
    // 设置可点击富文本字体颜色
    _myTextView.linkTextAttributes = @{NSForegroundColorAttributeName:titleTapColor};
}
// 字符串内容
- (void)setContent:(NSString *)content{
    _content = content;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:content];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 5;
    NSDictionary *attributes = @{
        NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize],
        NSParagraphStyleAttributeName:style
    };
    // 如果有三个点击事件在下面添加
    if (self.numClickEvent == 1) {
        [attStr addAttribute:NSLinkAttributeName value:@"click://" range:NSMakeRange(self.oneClickLeftBeginNum, self.oneTitleLength)];
        [attStr addAttributes:attributes range:NSMakeRange(0, self.oneTitleLength)];
    }else if (self.numClickEvent == 2){
        
        [attStr addAttribute:NSLinkAttributeName value:@"click://" range:NSMakeRange(self.oneClickLeftBeginNum, self.oneTitleLength)];
        [attStr addAttribute:NSLinkAttributeName value:@"click1://" range:NSMakeRange(self.twoClickLeftBeginNum, self.twoTitleLength)];
        [attStr addAttributes:attributes range:NSMakeRange(0, self.oneTitleLength)];
        
        [attStr addAttributes:attributes range:NSMakeRange(0, self.twoTitleLength)];
    }
    _myTextView.attributedText = attStr;
    
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    if ([[URL scheme] isEqualToString:@"click"]) {
        NSAttributedString *abStr = [textView.attributedText attributedSubstringFromRange:characterRange];
        if (self.eventblock) {
            self.eventblock(abStr);
        }
        return NO;
    }
    if ([[URL scheme] isEqualToString:@"click1"]) {
        NSAttributedString *abStr = [textView.attributedText attributedSubstringFromRange:characterRange];
        if (self.eventblock) {
            self.eventblock(abStr);
        }
        return NO;
    }
    return YES;
}
// 按钮点击事件
- (void)leftAgreeBtnClick:(UIButton *)sender{
    if (self.agreeBtnClick) {
        self.agreeBtnClick(sender);
    }
}

@end
