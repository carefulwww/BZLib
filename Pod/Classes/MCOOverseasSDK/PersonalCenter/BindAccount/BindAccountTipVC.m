//
//  BindAccountTipVC.m
//  MCOOverseasProject
//

#import "BindAccountTipVC.h"

@implementation BindAccountTipVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initView];
}

-(void)initView{
    
    NSString *tipString = [publicMath getLocalString:@"accountNoBind"];
    self.tipLabel.numberOfLines = 0;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:tipString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];
    [paragraphStyle1 setLineSpacing:3];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [tipString length])];
    [self.tipLabel setAttributedText:attributedString1];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    
    if (ScreenWidth > ScreenHeight) {
        //水平
        self.bgView.frame = CGRectMake((ScreenWidth - 346)/2, (ScreenHeight - 196)/2, 346, 196);
        self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-306)/2, 136, 306, 36);
        self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-306)/2, 30, 306, (self.bgView.frame.size.height-30-self.publicBtn.frame.size.height-24-11));
    }else{
        self.bgView.frame = CGRectMake((ScreenWidth - 303)/2, (ScreenHeight - 220)/2, 303, 220);
        self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-263)/2, 168, 263, 36);
        self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-196)/2, 18, 196, 142);
    }
    
    [self.publicBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Main_Theme_Color]];
    
    NSString *btnString = [publicMath getLocalString:@"sure"];
    [self.publicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.publicBtn setTitle:btnString forState:UIControlStateNormal];
    [self.publicBtn addTarget:self action:@selector(suerPress) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.bgView addSubview:self.publicBtn];
    [self.bgView addSubview:self.tipLabel];
    [self.view addSubview: self.bgView];
}

-(void)suerPress{
    [self dismissViewControllerAnimated:NO completion:^{
        NSNotification *notification =[NSNotification notificationWithName:@"bindThirdLoginSuc" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }];
}

@end
