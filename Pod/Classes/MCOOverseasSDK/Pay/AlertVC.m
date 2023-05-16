//
//  AlertVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/7/6.
//

#import "AlertVC.h"

@implementation AlertVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.bgView.frame = CGRectMake((ScreenWidth-303)/2, (ScreenHeight-200)/2, 303, 200);

    self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-244)/2, 140, 244, 36);
    NSString *btnString = [publicMath getLocalString:@"sure"];
    [self.publicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.publicBtn setTitle:btnString forState:UIControlStateNormal];
    [self.publicBtn addTarget:self action:@selector(surePress) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *tipString = [publicMath getLocalString:@"reorderTip"];
    self.tipLabel.numberOfLines = 0;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:tipString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];
    [paragraphStyle1 setLineSpacing:3];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [tipString length])];
    [self.tipLabel setAttributedText:attributedString1];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    
    self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-244)/2, 30, 244, (self.bgView.frame.size.height-30-self.publicBtn.frame.size.height-24-11));
    
    
    [self.bgView addSubview:self.tipLabel];
    [self.bgView addSubview:self.publicBtn];
    [self.view addSubview:self.bgView];
}


-(void)surePress{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
