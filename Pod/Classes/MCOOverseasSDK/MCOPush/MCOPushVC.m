//
//  MCOPushVC.m
//  MCOOverseasProject
//

#import "MCOPushVC.h"

@implementation MCOPushVC

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI{
    self.bgView.frame = CGRectMake((ScreenWidth-303)/2, (ScreenHeight-241)/2, 303, 241);
    
    self.titleLabel.text = [publicMath getLocalString:@"settingTitle"];
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-self.titleLabel.frame.size.width)/2, 17, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    
    [self.closeBtn addTarget:self action:@selector(closePress) forControlEvents:UIControlEventTouchUpInside];
    
    self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-244)/2, (self.bgView.frame.size.height-36-10), 244, 36);
    NSString *btnString = [publicMath getLocalString:@"goSetting"];
    [self.publicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.publicBtn setTitle:btnString forState:UIControlStateNormal];
    [self.publicBtn addTarget:self action:@selector(surePress) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *tipString = [publicMath getLocalString:@"settingMsg"];
    self.tipLabel.numberOfLines = 0;
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:tipString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setAlignment:NSTextAlignmentLeft];
    [paragraphStyle1 setLineSpacing:3];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [tipString length])];
    [self.tipLabel setAttributedText:attributedString1];
    self.tipLabel.textAlignment = NSTextAlignmentLeft;
    self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-244)/2, (self.titleLabel.frame.size.height+self.titleLabel.frame.origin.y), 244,100);
    [self.tipLabel sizeToFit];
    self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-244)/2, (self.bgView.frame.size.height-self.tipLabel.frame.size.height)/2, 244,self.tipLabel.frame.size.height);

    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.tipLabel];
    [self.bgView addSubview:self.publicBtn];
    [self.bgView addSubview:self.closeBtn];
    [self.view addSubview:self.bgView];
}

/**
 关闭
 */
-(void)closePress{
    [self dismissViewControllerAnimated:NO completion:nil];
}

/**
 去设置
 */
-(void)surePress{
    [self dismissViewControllerAnimated:NO completion:^{
        if(@available(iOS 10.0,*)){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {}];
        }else{
            NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=NOTIFICATIONS_ID&path=%@",bundleID]]];
        }
    }];
}

@end
