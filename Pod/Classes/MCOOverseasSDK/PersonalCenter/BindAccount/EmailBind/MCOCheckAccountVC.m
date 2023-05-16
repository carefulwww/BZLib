//
//  MCOCheckAccountVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/14.
//

#import "MCOCheckAccountVC.h"

@implementation MCOCheckAccountVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    self.bgView.frame = CGRectMake((ScreenWidth - 304)/2, (ScreenHeight - 200)/2, 304, 200);
    [self.closeBtn addTarget:self action:@selector(closePress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:self.closeBtn];
    
    //账号
    [self setUserNameLabelCopyBtn:[NSString stringWithFormat:@"%@:%@",[publicMath getLocalString:@"account"],self.account]];
    
    [self.bgView addSubview:self.userNameLabel];
    
    [self.view addSubview:self.bgView];
}

-(void)setUserNameLabelCopyBtn:(NSString *)text{
    
    //初始化
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    //图片
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    
    attachment.image = [UIImage imageNamed:MCO_Fuzhi_Black];
    
    attachment.bounds = CGRectMake(10, 0, 14, 14);

    NSAttributedString *imageAttachment = [NSAttributedString attributedStringWithAttachment:attachment];
    
    [attributedString appendAttributedString:imageAttachment];
    
    [self.userNameLabel setAttributedText:attributedString];
    
    self.userNameLabel.frame = CGRectMake((self.bgView.frame.size.width-200)/2, (self.bgView.frame.size.height-50)/2, 250, 50);
    
}

-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
        self.userNameLabel = [[UILabel alloc] init];
        [self.userNameLabel setFont:[UIFont systemFontOfSize:14]];
        [self.userNameLabel setTextColor:[UIColor colorWithHexString:MCO_Grey_Color]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyUserName)];
        [self.userNameLabel addGestureRecognizer:tapGesture];
        self.userNameLabel.userInteractionEnabled = YES;
    }
    return _userNameLabel;
}

-(void)copyUserName{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.account;
    NSString *tip = [publicMath getLocalString:@"copySuccess"];
    [publicMath MCOHub:tip messageView:self.view];
}

-(void)closePress{
    MCOLog(@"closePress");
    [self.navigationController popViewControllerAnimated:NO];
}

@end
