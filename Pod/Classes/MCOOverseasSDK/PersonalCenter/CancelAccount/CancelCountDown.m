//
//  CancelCountDown.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2022/1/14.
//

#import "CancelCountDown.h"

@implementation CancelCountDown

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
    
    //倒计时时间戳
    self.timeDisplay = [[UITextView alloc] init];
    [self.timeDisplay setFont:[UIFont systemFontOfSize:14]];
    [self.timeDisplay setTextColor:[UIColor colorWithHexString:MCO_CheckTip_Gray]];
    self.timeDisplay.text = [NSString stringWithFormat:@"%@99:99:99 ",[publicMath getLocalString:@"deleteUserCountDown"]];
    self.timeDisplay.textAlignment = NSTextAlignmentLeft;
    [self resetCountdown:self.countDownTime timeTip:self.timeDisplay];
    [self.timeDisplay sizeToFit];
    self.timeDisplay.frame = CGRectMake((self.bgView.frame.size.width-self.timeDisplay.frame.size.width)/2, 80, self.timeDisplay.frame.size.width, 25);
    
    //注销提示
    UILabel *cancelTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 100)];
    cancelTip.textAlignment = NSTextAlignmentCenter;
    [cancelTip setFont:[UIFont systemFontOfSize:12]];
//    NSString *text = @"倒计时结束后，您将无法登入该账号，是否取消注销？";
    NSString *text = [publicMath getLocalString:@"cancelCountDownTip"];
    [cancelTip setTextColor:[UIColor colorWithHexString:MCO_Gray_Color]];
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];
    [paragraphStyle1 setLineSpacing:1];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
    
    [cancelTip setAttributedText:attributedString1];
    cancelTip.numberOfLines = 0;
    [cancelTip sizeToFit];
    cancelTip.frame = CGRectMake((self.bgView.frame.size.width-cancelTip.frame.size.width)/2, self.timeDisplay.frame.origin.y+self.timeDisplay.frame.size.height+17, cancelTip.frame.size.width, cancelTip.frame.size.height);
    
    [self.mcoCancelBtn setTitle:[publicMath getLocalString:@"noDeal"] forState:UIControlStateNormal];
    self.mcoCancelBtn.frame = CGRectMake(38,200, 107.5, 30.5);
    [self.mcoCancelBtn addTarget:self action:@selector(cancelPress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sureBtn setTitle:[publicMath getLocalString:@"cancelDeleteBtn"]    forState:UIControlStateNormal];
    self.sureBtn.frame = CGRectMake((self.mcoCancelBtn.frame.size.width+self.mcoCancelBtn.frame.origin.x+12), self.mcoCancelBtn.frame.origin.y, 107.5, 30.5);
    [self.sureBtn addTarget:self action:@selector(surePress) forControlEvents:UIControlEventTouchUpInside];
    

    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.closeBtn];
    [self.bgView addSubview:self.timeDisplay];
    [self.bgView addSubview:self.tipLabel];
    [self.bgView addSubview:cancelTip];
    [self.bgView addSubview:self.mcoCancelBtn];
    [self.bgView addSubview:self.sureBtn];
    

    [self.view addSubview:self.bgView];
}

-(void)resetCountdown:(int)count timeTip:(UITextView *)timeTip{
    [self cancelCountDownTimer];
//    NSInteger nowTime = [[GetDeviceData getTimeStp] intValue];;
//    NSInteger count = endTime - nowTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _countdownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    [self countDownWithTimer:_countdownTimer timeInterval:count complete:^{
        //完成操作
        [publicMath closeGame];
    } progress:^(int mHours, int mMinute, int mSecond) {
        MCOLog(@"倒计时 : %d时 %d分 %d秒",mHours,mMinute,mSecond);
        NSString *timeStr = [NSString stringWithFormat:@"%@%02d:%02d:%02d ",[publicMath getLocalString:@"deleteUserCountDown"],mHours,mMinute,mSecond];
        timeTip.text = timeStr;
    }];
}

-(void)cancelCountDownTimer{
    if (_countdownTimer) {
        dispatch_source_cancel(_countdownTimer);
        _countdownTimer = nil;
    }
}

-(void)dealloc{
    if (_countdownTimer) {
        dispatch_source_cancel(_countdownTimer);
        _countdownTimer = nil;
    }
}

/**
 倒计时
 */
-(void)countDownWithTimer:(dispatch_source_t)timer timeInterval:(NSTimeInterval)timeInterval complete:(void(^)(void))completeBlock progress:(void(^)(int mHours, int mMinute, int mSecond))progressBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        __block int timeout = timeInterval; //倒计时时间
        if (timeout!=0) {
            dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(timer);
                    dispatch_async(dispatch_get_main_queue(), ^{ // block 回调
                        if (completeBlock) {
                            completeBlock();
                        }
                    });
                }else{
                    int hours = (int)((timeout)/3600);
                    int minute = (int)(timeout-hours*3600)/60;
                    int second = (int)(timeout-hours*3600-minute*60);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressBlock) { //进度回调
                            progressBlock(hours, minute, second);
                        }
                    });
                    timeout--;
                }
            });
            dispatch_resume(timer);
        }
    });
}

-(void)closePress{
    MCOLog(@"关闭");
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)surePress{
    //取消撤销
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[MCOOSSDKCenter currentViewController].view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSDictionary *dic = @{
        @"uuid":[MCOOSSDKCenter MCOShareSDK].saveUUID
    };
    [HttpRequest POSTRequestWithUrlString:MCO_Cancel_Delete isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
        MCOLog(@"取消注销账号，%@",result);
        [hud hideAnimated:YES];
        [self dismissViewControllerAnimated:NO completion:^{
            NSNotification *notification =[NSNotification notificationWithName:@"cancelDeleteBack" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [publicMath MCOHub:[publicMath getLocalString:@"cancelDeleteSuccess"] messageView:[MCOOSSDKCenter currentViewController].view];
            
        }];
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

-(void)cancelPress{
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
