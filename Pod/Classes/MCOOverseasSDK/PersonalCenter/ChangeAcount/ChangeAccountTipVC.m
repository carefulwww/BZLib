//
//  ChangeAccountTipVC.m
//  MCOOverseasProject
//

#import "ChangeAccountTipVC.h"

@implementation ChangeAccountTipVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setUI];
    
}

-(void)setUI{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    int third_login_type = [[user objectForKey:@"third_login_type"] intValue];
    NSString *tipString;
    if (third_login_type == 1) {
        //google
        tipString = [publicMath getLocalString:@"changeGoogleAccountFaliTip"];
    }else if(third_login_type == 2){
        //facebook
        tipString = [publicMath getLocalString:@"changeFacebookAccountFaliTip"];
    }else if (third_login_type == 3){
        tipString = [publicMath getLocalString:@"changeAppleAccountFaliTip"];
    }else if(third_login_type == 6){
        tipString = [publicMath getLocalString:@"changeEmailFailTip"];
    }else{
        tipString = @"null";
    }
    
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
        self.bgView.frame = CGRectMake((ScreenWidth-298)/2, (ScreenHeight-148)/2, 298, 148);
        self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-250)/2, 22, 250, 60);
        self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-226)/2, self.tipLabel.frame.origin.y+self.tipLabel.frame.size.height+12, 226, 36);
    }else{
        //竖直布局
        self.bgView.frame = CGRectMake((self.view.frame.size.width-267)/2, (self.view.frame.size.height-160)/2, 267, 160);
        self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-195)/2, 16, 195, 80);
        self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-195)/2, self.tipLabel.frame.origin.y+self.tipLabel.frame.size.height+12, 195, 36);
    }
    self.publicBtn.layer.cornerRadius = 4;
    [self.publicBtn setTitle:[publicMath getLocalString:@"sure"] forState:UIControlStateNormal];
    [self.publicBtn addTarget:self action:@selector(surePress) forControlEvents:UIControlEventTouchUpInside];
 
    [self.bgView addSubview:self.tipLabel];
    [self.bgView addSubview:self.publicBtn];
    
    [self.view addSubview:self.bgView];
}

-(void)surePress{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
