//
//  CancelTipVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2022/1/14.
//

#import "CancelTipVC.h"

@implementation CancelTipVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    self.bgView.frame = CGRectMake((ScreenWidth-304)/2, (ScreenHeight-241)/2, 304, 241);
    
    self.titleLabel.text = [publicMath getLocalString:@"cancelAccountItem"];
    self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-200)/2, 16, 200, 25);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.closeBtn addTarget:self action:@selector(closePress) forControlEvents:UIControlEventTouchUpInside];
    
    //注销提示
    UILabel *cancelTip = [[UILabel alloc] init];
    cancelTip.textAlignment = NSTextAlignmentCenter;
    
    NSString *text;
    //是否删除账号提示
    text = [publicMath getLocalString:@"deleteTip"];
    cancelTip.frame = CGRectMake((self.bgView.frame.size.width-159)/2, (self.bgView.frame.size.height-100)/2, 159, 100);
    
    [cancelTip setTextColor:[UIColor colorWithHexString:MCO_Gray_Color]];
    [cancelTip setFont:[UIFont systemFontOfSize:12]];
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];
    [paragraphStyle1 setLineSpacing:3];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
    cancelTip.textAlignment = NSTextAlignmentCenter;
    
    [cancelTip setAttributedText:attributedString1];
    cancelTip.numberOfLines = 0;
    
    
    [self.mcoCancelBtn setTitle:[publicMath getLocalString:@"cancel"] forState:UIControlStateNormal];
    self.mcoCancelBtn.frame = CGRectMake(38,200, 107.5, 30.5);
    [self.mcoCancelBtn addTarget:self action:@selector(cancelPress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sureBtn setTitle:[publicMath getLocalString:@"sure"] forState:UIControlStateNormal];
    self.sureBtn.frame = CGRectMake((self.mcoCancelBtn.frame.size.width+self.mcoCancelBtn.frame.origin.x+12), self.mcoCancelBtn.frame.origin.y, 107.5, 30.5);
    [self.sureBtn addTarget:self action:@selector(surePress) forControlEvents:UIControlEventTouchUpInside];
    

    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.closeBtn];
    [self.bgView addSubview:cancelTip];
    [self.bgView addSubview:self.mcoCancelBtn];
    [self.bgView addSubview:self.sureBtn];
    

    [self.view addSubview:self.bgView];
}

-(void)closePress{
    MCOLog(@"关闭");
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[CancelTreatyVC class]]) {
            
            NSNotification *notification =[NSNotification notificationWithName:@"cancelBack" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
}

-(void)cancelPress{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)surePress{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[MCOOSSDKCenter currentViewController].view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSDictionary *dic = @{
        @"uuid":[MCOOSSDKCenter MCOShareSDK].saveUUID,
    };
    [HttpRequest POSTRequestWithUrlString:MCO_Delete_Account isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
        MCOLog(@"注销账号，result = %@",result);
        [hud hideAnimated:YES];
        CancelMessageVC *messageVC = [[CancelMessageVC alloc] init];
        messageVC.timeStr = result[@"data"][@"create_time"];
        messageVC.dayStr = [result[@"data"][@"off_day"] intValue];
        messageVC.timeStamp = [result[@"data"][@"create_timestamp"] intValue];
        [self.navigationController pushViewController:messageVC animated:NO];
    } serverErrorBlock:^(id result) {
        [hud hideAnimated:YES];
        MCOLog(@"注销账号失败 result = %@",result);
        [publicMath MCOHub:[publicMath getLocalString:@"netError"] messageView:[MCOOSSDKCenter currentViewController].view];
    } failBlock:^{
        [hud hideAnimated:YES];
        MCOLog(@"注销账号失败--error");
        [publicMath MCOHub:[publicMath getLocalString:@"netError"] messageView:[MCOOSSDKCenter currentViewController].view];
    }];
}


@end
