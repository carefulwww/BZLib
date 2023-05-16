//
//  DisagreenTipVC.m
//  MCOOverseasProject
//

#import "DisagreenTipVC.h"

@implementation DisagreenTipVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setUI];
    
}

-(void)setUI{
    
    
    NSString *tipString = [publicMath getLocalString:@"closePolicyTip"];
    self.tipLabel.numberOfLines = 0;
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:tipString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];
    [paragraphStyle1 setLineSpacing:3];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [tipString length])];
    [self.tipLabel setAttributedText:attributedString1];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.font = [UIFont systemFontOfSize:14];
    
    if (ScreenWidth > ScreenHeight) {
        //水平布局
        self.bgView.frame = CGRectMake((ScreenWidth-364)/2, (ScreenHeight-196)/2, 364, 196);
        self.cancelBtn.frame = CGRectMake(20, 136, 139, 36);
        self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-306)/2, 24, 306, (self.bgView.frame.size.height-24-self.cancelBtn.frame.size.height-12-24));
        self.publicBtn.frame = CGRectMake(self.cancelBtn.frame.size.width+self.cancelBtn.frame.origin.x+26, self.cancelBtn.frame.origin.y, 141, 36);
    }else{
        //竖直布局
        self.bgView.frame = CGRectMake((self.view.frame.size.width-303)/2, (self.view.frame.size.height-220)/2, 303, 220);
        self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-263)/2, 36, 263, 40);
        self.cancelBtn.frame = CGRectMake(20, 160, 122, 36);
        self.publicBtn.frame = CGRectMake(self.cancelBtn.frame.size.width+self.cancelBtn.frame.origin.x+19, self.cancelBtn.frame.origin.y, 122, 36);
    }
    
    [self.publicBtn setTitle:[publicMath getLocalString:@"agreenTerm"] forState:UIControlStateNormal];
    [self.publicBtn addTarget:self action:@selector(surePress) forControlEvents:UIControlEventTouchUpInside];
 
    [self.bgView addSubview:self.tipLabel];
    [self.bgView addSubview:self.publicBtn];
    
    [self.bgView addSubview:self.cancelBtn];
    [self.view addSubview:self.bgView];
}

-(void)surePress{
    [self dismissViewControllerAnimated:NO completion:^{
//        [[MCOOSSDKCenter MCOShareSDK] touristLogin];
        [[MCOOSSDKCenter MCOShareSDK] initSuccess:self.dic];
        //回调
        [[MCOOSSDKCenter MCOShareSDK] clauseClickBtnBack];
    }];
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.layer.borderColor = [UIColor colorWithHexString:MCO_Main_Theme_Color].CGColor;
        self.cancelBtn.layer.borderWidth = 1;
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.cancelBtn setTitleColor:[UIColor colorWithHexString:MCO_Main_Theme_Color] forState:UIControlStateNormal];
        self.cancelBtn.layer.cornerRadius = 4;
        [self.cancelBtn setTitle:[publicMath getLocalString:@"exitGame"] forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelPress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(void)cancelPress{
    NSLog(@"退出游戏");
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:@(0) forKey:@"isOpenPolicy"];
    [user synchronize];
//    [self dismissViewControllerAnimated:NO completion:nil];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.5f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.height / 2, window.bounds.size.width, 0.5);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}


@end
