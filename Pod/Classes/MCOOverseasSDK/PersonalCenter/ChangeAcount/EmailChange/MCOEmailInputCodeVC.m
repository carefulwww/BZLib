//
//  MCOEmailInputCodeVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/14.
//

#import "MCOEmailInputCodeVC.h"

@implementation MCOEmailInputCodeVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCodeSucBack:) name:@"retryCheckCodeSucBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCodeFailBack) name:@"retryCheckCodeFailBack" object:nil];
    
    [self initView];
    self.nowTime = [[GetDeviceData getTimeStp] intValue];
    [self countDown:self.time];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"retryCheckCodeSucBack" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"retryCheckCodeFailBack" object:nil];
}

-(void)checkCodeSucBack:(NSNotification *)notification{
    MCOLog(@"check code success");
    NSDictionary *data = [notification userInfo];
    [self getCode:data];
}

-(void)checkCodeFailBack{
    MCOLog(@"check code fail");
    [[MBProgressHUD HUDForView:self.view] hideAnimated:NO];
    [publicMath MCOHub:@"失败" messageView:self.view];
}

-(void)initView{
    self.bgView.frame = CGRectMake((ScreenWidth-304)/2, (ScreenHeight-241)/2, 304, 241);
    
    [self.mcoBackBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.text = self.titleStr;
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-self.titleLabel.frame.size.width)/2, 17, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    
    NSString *tipString = [NSString stringWithFormat:@"%@:\n%@",[publicMath getLocalString:@"sendEmail"],self.emailStr];
    CGSize sizeName = [tipString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(250, 50) lineBreakMode:NSLineBreakByWordWrapping];
    self.tipLabel.frame = CGRectMake(24, 58, 250, sizeName.height);
    self.tipLabel.text = tipString;
    self.tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.tipLabel.textAlignment = NSTextAlignmentLeft;
    self.tipLabel.numberOfLines = 0;
    
    //输入框
    self.inputCodeTF = [[MCOTextField alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-255)/2, (self.tipLabel.frame.size.height+self.tipLabel.frame.origin.y+8), 255, 35)];
    self.inputCodeTF.imageName = MCO_Shield_Small_Image;
    self.inputCodeTF.attributedPlaceholder = [[NSMutableAttributedString alloc]
                                     initWithString:[publicMath getLocalString:@"sendCodeTip"]
                                     attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:11]}];
    
    //获取验证码按钮
    self.getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 0, 90, 24)];
    self.getCodeBtn.layer.cornerRadius = 8;
    self.getCodeBtn.layer.masksToBounds = YES;
    [self.getCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [self.getCodeBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Btn_Gray]];
    self.getCodeBtn.enabled = NO;
    [self.getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIView *rightVIew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 24)];
    [rightVIew addSubview:self.getCodeBtn];
    self.inputCodeTF.rightView = rightVIew;
    self.inputCodeTF.rightViewMode = UITextFieldViewModeAlways;
    [self.inputCodeTF addTarget:self action:@selector(inputCodeDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-254)/2, (self.inputCodeTF.frame.size.height+self.inputCodeTF.frame.origin.y+43), 254, 31);
    [self.publicBtn setTitle:[publicMath getLocalString:@"next"] forState:UIControlStateNormal];
    self.publicBtn.enabled = NO;
    self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Btn_Gray];
    [self.publicBtn addTarget:self action:@selector(nextPress) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *noCodeBtn = [[UIButton alloc] init];
    [noCodeBtn setTitleColor:[UIColor colorWithHexString:MCO_Btn_Gray] forState:UIControlStateNormal];
    [noCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[publicMath getLocalString:@"noCodeBtn"]];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [noCodeBtn setAttributedTitle:str forState:UIControlStateNormal];
    [noCodeBtn sizeToFit];
    noCodeBtn.frame = CGRectMake(24, (self.inputCodeTF.frame.size.height+self.inputCodeTF.frame.origin.y+8), noCodeBtn.frame.size.width, noCodeBtn.frame.size.height);
    [noCodeBtn addTarget:self action:@selector(noCodePress) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.bgView addSubview:self.mcoBackBtn];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.tipLabel];
    [self.bgView addSubview:self.inputCodeTF];
    [self.bgView addSubview:noCodeBtn];
    [self.bgView addSubview:self.publicBtn];
    
    [self.view addSubview:self.bgView];
}

-(void)noCodePress{
    MCOLog(@"没有验证码");
    MCONoCodeTipVC *tipVC = [[MCONoCodeTipVC alloc] init];
    [self.navigationController pushViewController:tipVC animated:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.inputCodeTF resignFirstResponder];
}

//判断是否输入Code
-(void)inputCodeDidChange:(id)sender{
    UITextField *field = (UITextField *)sender;
    if ([publicMath isBlankString:[field text]]) {
        //不为空
        self.publicBtn.enabled = YES;
        self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Main_Theme_Color];
    }else{
        self.publicBtn.enabled = NO;
        self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Btn_Gray];
    }
}

//倒计时
-(void)countDown:(NSInteger )t{
    __block NSInteger time = 59;
    if (t!=0) {
        time = t;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        if (time <= 0) {
            //倒计时结束
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //需要变化的内容
                [self.getCodeBtn setTitle:[publicMath getLocalString:@"getCodeBtn"] forState:UIControlStateNormal];
                self.getCodeBtn.enabled = YES;
                [self.getCodeBtn addTarget:self action:@selector(reGetCodePress) forControlEvents:UIControlEventTouchUpInside];
                [self.getCodeBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Main_Theme_Color]];
            });
        }else{
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //需要变化的东西
                [self.getCodeBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Btn_Gray]];
                self.getCodeBtn.enabled = NO;
                NSString *timeStr = [[publicMath getLocalString:@"countDownBtn"] stringByReplacingOccurrencesOfString:@"6" withString:[NSString stringWithFormat:@"%d",seconds]];
                [self.getCodeBtn setTitle:timeStr forState:UIControlStateNormal];
            });
            
            time--;
        }
    });
    dispatch_resume(_timer);
}

-(void)backPress{
    MCOLog(@"backPress");
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setInteger:self.nowTime forKey:@"countDownTime"];
    [user synchronize];
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

-(void)reGetCodePress{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    MCOLog(@"重新获取验证码");
    
    //检查滑块
    if([MCOOSSDKCenter MCOShareSDK].pic_code_open == 1){
        ShowPicCode *showPicCodeVC = [[ShowPicCode alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@/show?platform_id=%d&game_id=0&callback=getData&title=testtest&agent=2",[MCOOSSDKCenter MCOShareSDK].picVerifyUrl,[MCOOSSDKCenter MCOShareSDK].pic_platform_id];
        showPicCodeVC.pathUrl = url;
        showPicCodeVC.type = 2;
        [self.navigationController pushViewController:showPicCodeVC animated:NO];
    }else{
        [self getCode:nil];
    }
    
    
}


-(void)getCode:(NSDictionary *)verifyDic{
    
    NSMutableDictionary *codeDic = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@(6),@"open_id":self.emailStr}];
        
    if (verifyDic != nil) {
        [codeDic setValue:verifyDic[@"ticket"] forKey:@"ticket"];
        [codeDic setValue:verifyDic[@"randstr"] forKey:@"randstr"];
    }
   
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    
    [HttpRequest POSTRequestWithUrlString:MCO_Verify_Code isPay:NO headerDic:nil parameters:codeDic successBlock:^(id result) {
        MCOLog(@"重新获取验证码成功 result = %@",result);
        [hud hideAnimated:NO];
        self.nowTime = [[GetDeviceData getTimeStp] intValue];
        [self countDown:0];
    } serverErrorBlock:^(id result) {
        MCOLog(@"重新获取验证码失败 result = %@",result);
        [hud hideAnimated:NO];
        [publicMath MCOHub:@"Error" messageView:self.view];
    } failBlock:^{
        MCOLog(@"重新获取验证失败 网络错误");
        [hud hideAnimated:NO];
        [publicMath MCOHub:[publicMath getLocalString:@"netError"] messageView:self.view];
    }];
    
}

-(void)nextPress{
    MCOLog(@"下一步");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSDictionary *dic = @{
        @"type":@"6",
        @"open_id":self.emailStr,
        @"token":[self.inputCodeTF text]
    };
    
    [HttpRequest POSTRequestWithUrlString:MCO_Code_Verfiy isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
        MCOLog(@"验证码结果：%@",result);
        [hud hideAnimated:NO];
        //进入输入密码状态
        MCOEmailInputPasswordVC *inputPasswordVC = [[MCOEmailInputPasswordVC alloc] init];
        inputPasswordVC.emailStr = self.emailStr;
        inputPasswordVC.titleStr = self.titleStr;
        inputPasswordVC.btnStr = self.btnStr;
        inputPasswordVC.type = self.type;
        inputPasswordVC.token = [self.inputCodeTF text];
        if (self.type == 4 || self.type == 5 || self.type == 6) {
            MCOLog(@"忘记密码输入验证码");
            inputPasswordVC.tipStr = [publicMath getLocalString:@"inputNewPassword"];
        }
        [self.navigationController pushViewController:inputPasswordVC animated:NO];
    } serverErrorBlock:^(id result) {
        MCOLog(@"验证码结果：%@",result);
        [hud hideAnimated:NO];
        if([result[@"error"] intValue]==12){
            //失效
            [publicMath MCOHub:[publicMath getLocalString:@"codeInvalid"] messageView:self.view];
        }else if([result[@"error"] intValue]==13){
            //验证码错误
            [publicMath MCOHub:[publicMath getLocalString:@"codeError"] messageView:self.view];
        }else{
            //其他错误
            [publicMath MCOHub:[publicMath getLocalString:@"codeInvalid"] messageView:self.view];
        }
    } failBlock:^{
        MCOLog(@"验证码结果验证失败 网络错误");
        [hud hideAnimated:NO];
        [publicMath MCOHub:[publicMath getLocalString:@"netError"] messageView:self.view];
    }];
    
}

@end
