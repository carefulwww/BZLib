//
//  MCONoCodeTipVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/19.
//

#import "MCONoCodeTipVC.h"

@implementation MCONoCodeTipVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    self.bgView.frame = CGRectMake((ScreenWidth - 304)/2, (ScreenHeight - 200)/2, 304, 200);
    [self.closeBtn addTarget:self action:@selector(closePress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:self.closeBtn];
    

    //账号
//    UITextView *accountTV = [[UITextView alloc] init];
    UILabel *accountTV = [[UILabel alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-240)/2, (self.bgView.frame.size.height-100)/2, 240, 100)];
    accountTV.textAlignment = NSTextAlignmentCenter;
    NSString *text = [publicMath getLocalString:@"noCodeTips"];
    [accountTV setTextColor:[UIColor colorWithHexString:MCO_Grey_Color]];
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];
    [paragraphStyle1 setLineSpacing:1];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
    
    [accountTV setAttributedText:attributedString1];
    accountTV.numberOfLines = 0;
    [accountTV sizeToFit];
    accountTV.frame = CGRectMake((self.bgView.frame.size.width-accountTV.frame.size.width)/2, (self.bgView.frame.size.height-accountTV.frame.size.height)/2, accountTV.frame.size.width, accountTV.frame.size.height);
    [self.bgView addSubview:accountTV];
    
    [self.view addSubview:self.bgView];
}

-(void)closePress{
    MCOLog(@"closePress");
    [self.navigationController popViewControllerAnimated:NO];
}




@end
