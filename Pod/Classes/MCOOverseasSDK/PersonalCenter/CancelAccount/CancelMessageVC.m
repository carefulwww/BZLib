//
//  CancelMessageVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2022/1/18.
//

#import "CancelMessageVC.h"

@implementation CancelMessageVC

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
    //提示已经完成注销
//    text = [publicMath getLocalString:@"countDownTip"];
    NSString *timeStr = [[publicMath getLocalString:@"countDownTips"] stringByReplacingOccurrencesOfString:@"%" withString:self.timeStr];
    text = [timeStr stringByReplacingOccurrencesOfString:@"$" withString:[NSString stringWithFormat:@"%d",self.dayStr]];
    
    cancelTip.frame = CGRectMake((self.bgView.frame.size.width-252)/2, (self.bgView.frame.size.height-150)/2, 252, 150);
    [cancelTip setTextColor:[UIColor colorWithHexString:MCO_Gray_Color]];
    [cancelTip setFont:[UIFont systemFontOfSize:12]];
    
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:12]};
    NSData *data = [text dataUsingEncoding:NSUnicodeStringEncoding];
    
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    
//    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];
    [paragraphStyle1 setLineSpacing:3];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [attributedString1 length])];
    cancelTip.textAlignment = NSTextAlignmentCenter;
    
    [cancelTip setAttributedText:attributedString1];
    cancelTip.numberOfLines = 0;
    
    
    [self.mcoCancelBtn setTitle:[publicMath getLocalString:@"cancelDeleteBtn"] forState:UIControlStateNormal];
    self.mcoCancelBtn.frame = CGRectMake(38,200, 107.5, 30.5);
    [self.mcoCancelBtn addTarget:self action:@selector(cancelPress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sureBtn setTitle:[publicMath getLocalString:@"knownBtn"] forState:UIControlStateNormal];
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
    //取消撤销
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[MCOOSSDKCenter currentViewController].view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSDictionary *dic = @{
        @"uuid":[MCOOSSDKCenter MCOShareSDK].saveUUID
    };
    
    [HttpRequest POSTRequestWithUrlString:MCO_Cancel_Delete isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
        MCOLog(@"取消注销账号，%@",result);
        [hud hideAnimated:YES];
        for (UIViewController *temp in self.navigationController.viewControllers) {
            NSNotification *notification =[NSNotification notificationWithName:@"cancelDeleteBack" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self.navigationController popToViewController:temp animated:YES];
        }
        [publicMath MCOHub:[publicMath getLocalString:@"cancelDeleteSuccess"] messageView:[MCOOSSDKCenter currentViewController].view];
    } serverErrorBlock:^(id result) {
        [hud hideAnimated:YES];
        MCOLog(@"取消注销账号失败，%@",result);
        [publicMath MCOHub:[publicMath getLocalString:@"netError"] messageView:[MCOOSSDKCenter currentViewController].view];
    } failBlock:^{
        [hud hideAnimated:YES];
        MCOLog(@"取消账号失败--网络错误");
        [publicMath MCOHub:[publicMath getLocalString:@"netError"] messageView:[MCOOSSDKCenter currentViewController].view];
    }];
    
}

-(void)surePress{
    //我知道了
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[CancelTreatyVC class]]) {
                        
            NSDictionary *backInfo = @{
                @"timeStamp":@(self.timeStamp),
                @"day":@(self.dayStr)
            };
//
            NSNotification *notification =[NSNotification notificationWithName:@"deleteUserBack" object:nil userInfo:backInfo];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
}

@end
