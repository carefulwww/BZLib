//
//  CenterFooterVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/11/16.
//

#import "CenterFooterVC.h"

@implementation CenterFooterVC

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
//        _titleLab = [[UILabel alloc]init];
//        _titleLab.frame = CGRectMake(0,0, self.frame.size.width,self.frame.size.height);
//        _titleLab.textAlignment = NSTextAlignmentCenter;
//        _titleLab.backgroundColor = [UIColor clearColor];
//        [self addSubview:_titleLab];
        
        _titleBtn = [[UIButton alloc] init];
        _titleBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleBtn.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleBtn];
    }
    
    return self;
    
}

@end
