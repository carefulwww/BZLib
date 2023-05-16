//
//  MCOTextField.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/13.
//

#import "MCOTextField.h"

@implementation MCOTextField

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self setBackground:[UIImage imageNamed:MCO_TextInput_Background]];
    self.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageName]];
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 30, 20)];
    leftImage.center = CGPointMake(lv.center.x-5,lv.center.y);
    [lv addSubview:leftImage];
    [self setFont:[UIFont systemFontOfSize:13]];
    [self setTextColor:[UIColor colorWithHexString:@"#3E3E3E"]];
    self.leftView = lv;
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    
    // 计算占位文字的 Size
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#BDBDBD"],
                                 NSFontAttributeName : [UIFont systemFontOfSize:11],
                                 };
    
    CGSize placeholderSize = [self.placeholder sizeWithAttributes:attributes];
    
    [self.placeholder drawInRect:CGRectMake(0, (rect.size.height - placeholderSize.height)/2, placeholderSize.width, rect.size.height) withAttributes: attributes];
}

@end
