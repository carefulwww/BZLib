//
//  TouristChangeAccountTipVC.m
//  MCOOverseasProject
//

#import "TouristChangeAccountTipVC.h"

@implementation TouristChangeAccountTipVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setUI];
    
}

-(void)setUI{
    
    NSString *tipString = [publicMath getLocalString:@"changeAccountLoseDataTip"];
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
        self.bgView.frame = CGRectMake((ScreenWidth-346)/2, (ScreenHeight-196)/2, 346, 196);
        self.cancelBtn.frame = CGRectMake(20, 136, 139, 36);
        self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-306)/2, 18, 306, (self.cancelBtn.frame.origin.y-18-11));
        self.publicBtn.frame = CGRectMake(self.cancelBtn.frame.size.width+self.cancelBtn.frame.origin.x+26, self.cancelBtn.frame.origin.y, 139, 36);
    }else{
        //竖直布局
        self.bgView.frame = CGRectMake((self.view.frame.size.width-303)/2, (self.view.frame.size.height-220)/2, 303, 220);
        self.cancelBtn.frame = CGRectMake(20, 160, 122, 36);
        self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-196)/2, 18, 196, (self.bgView.frame.size.height-18-self.cancelBtn.frame.size.height-24-11));
        self.publicBtn.frame = CGRectMake(self.cancelBtn.frame.size.width+self.cancelBtn.frame.origin.x+19, self.cancelBtn.frame.origin.y, 122, 36);
    }
    self.publicBtn.layer.cornerRadius = 4;
    [self.publicBtn setTitle:[publicMath getLocalString:@"continueChange"] forState:UIControlStateNormal];
    [self.publicBtn addTarget:self action:@selector(surePress) forControlEvents:UIControlEventTouchUpInside];
 
    [self.bgView addSubview:self.tipLabel];
    [self.bgView addSubview:self.publicBtn];
    
    [self.bgView addSubview:self.cancelBtn];
    [self.view addSubview:self.bgView];
}

-(void)surePress{
    [self dismissViewControllerAnimated:NO completion:^{
        NSNotification *notification =[NSNotification notificationWithName:@"continueBind" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
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
        [self.cancelBtn setTitle:[publicMath getLocalString:@"cancelChange"] forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelPress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(void)cancelPress{
    MCOLog(@"取消切换");
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
