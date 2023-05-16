//
//  MCOEmailGetCodeVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/14.
//

#import "MCOEmailGetCodeVC.h"

@implementation MCOEmailGetCodeVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCodeSucBack:) name:@"checkCodeSucBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCodeFailBack) name:@"checkCodeFailBack" object:nil];
    
    [self initView];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"checkCodeSucBack" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"checkCodeFailBack" object:nil];
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
    
    self.bgView.frame = CGRectMake((ScreenWidth - 304)/2, (ScreenHeight - 241)/2, 304, 241);
    
    self.titleLabel.text = self.titleStr;
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-self.titleLabel.frame.size.width)/2, 17, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    
    [self.mcoBackBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.emailTF = [[MCOTextField alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-255)/2, 61, 255, 35)];
    self.emailTF.imageName = MCO_Email_Small_Image;
    self.emailTF.attributedPlaceholder = [[NSMutableAttributedString alloc]
                                     initWithString:[publicMath getLocalString:@"enterCorrectAccount"]
                                     attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:11]}];
    [self.emailTF addTarget:self action:@selector(inputEmailDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-255)/2, (self.emailTF.frame.size.height+self.emailTF.frame.origin.y+13), 255,31);
    [self.publicBtn setTitle:[publicMath getLocalString:@"getCodeBtn"] forState:UIControlStateNormal];
    self.publicBtn.enabled = NO;
    self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Btn_Gray];
    [self.publicBtn addTarget:self action:@selector(getCodePress) forControlEvents:UIControlEventTouchUpInside];
    
    //注册表示您同意《用户协议》
    UIButton *agreemTV = [[UIButton alloc] init];
    NSString *terms = [publicMath getLocalString:@"regAgreenTerms"];
    NSInteger localRange = [terms rangeOfString:@":"].location;
    NSRange range = {localRange+1,(terms.length-localRange-1)};
    NSRange range2 = {0,localRange+1};
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:terms];
    [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:MCO_Main_Theme_Color]} range:range];
    [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:MCO_Btn_Gray]} range:range2];
    
    [agreemTV setAttributedTitle:attribute forState:UIControlStateNormal];
    [agreemTV.titleLabel setFont:[UIFont systemFontOfSize:12]];
//    [agreemTV setTitleColor:[UIColor colorWithHexString:MCO_Btn_Gray] forState:UIControlStateNormal];
    [agreemTV sizeToFit];
    agreemTV.frame = CGRectMake(25, (self.publicBtn.frame.origin.y+self.publicBtn.frame.size.height+9), agreemTV.frame.size.width, agreemTV.frame.size.height);
    [agreemTV addTarget:self action:@selector(agreenPress) forControlEvents:UIControlEventTouchUpInside];
    
    //绑定界面
    UIButton *bindUsedAccountBtn = [[UIButton alloc] init];
    [bindUsedAccountBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [bindUsedAccountBtn setTitleColor:[UIColor colorWithHexString:@"#756F6F"] forState:UIControlStateNormal];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[publicMath getLocalString:@"bindUsedAccount"]];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [bindUsedAccountBtn setAttributedTitle:str forState:UIControlStateNormal];
    [bindUsedAccountBtn sizeToFit];
    bindUsedAccountBtn.frame = CGRectMake((self.bgView.frame.size.width - bindUsedAccountBtn.frame.size.width)/2, self.publicBtn.frame.size.height+self.publicBtn.frame.origin.y+60, bindUsedAccountBtn.frame.size.width, bindUsedAccountBtn.frame.size.height);
    [bindUsedAccountBtn addTarget:self action:@selector(bindUserAccountPress) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.type != 3){
        bindUsedAccountBtn.hidden = YES;
    }
    
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.mcoBackBtn];
    [self.bgView addSubview:self.emailTF];
    [self.bgView addSubview:self.publicBtn];
    [self.bgView addSubview:agreemTV];
    [self.bgView addSubview:bindUsedAccountBtn];
    
    
    
    [self.view addSubview:self.bgView];
}

-(void)backPress{
    MCOLog(@"backPress");
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)agreenPress{
    MCOLog(@"用户协议");
    RuleVC *ruleVC = [[RuleVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ruleVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:NO completion:nil];
}

-(void)bindUserAccountPress{
    MCOLog(@"绑定已有账号");
    MCOEmailBindVC *bindVC = [[MCOEmailBindVC alloc] init];
    [self.navigationController pushViewController:bindVC animated:NO];
}




-(void)getCodePress{
    MCOLog(@"获取验证码");
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    if (![publicMath isValidateEmail:[self.emailTF text]]) {
        [hud hideAnimated:NO];
        [publicMath MCOHub:[publicMath getLocalString:@"inputCorrectEmail"] messageView:self.view];
        return;
    }
    
    /**
     先检查用户
     */
    NSDictionary *userDic = @{
        @"device_id":[self.emailTF text]
    };
    [HttpRequest POSTRequestWithUrlString:MCO_Reg_User_Check isPay:NO headerDic:nil parameters:userDic successBlock:^(id result) {
        MCOLog(@"检查用户成功 result = %@",result);
        int status = [result[@"data"][@"status"] intValue];
        if(status == 1){
            //邮箱已注册过
            if(self.type == 4||self.type == 5|| self.type == 6){
                //4.登录忘记密码 5.切换忘记密码 6.绑定忘记密码
                
            }else{
                //1.登录 2.切换登录 3.绑定账号
                [hud hideAnimated:NO];
                [publicMath MCOHub:[publicMath getLocalString:@"usedAccount"] messageView:self.view];
                return;
            }
            
        }else if (status == 0){
            //邮箱未注册过
            if (self.type == 1||self.type == 2||self.type==3) {
                //
            }else{
                [hud hideAnimated:NO];
                [publicMath MCOHub:[publicMath getLocalString:@"invalidAccount"] messageView:self.view];
                return;
            }
        }
        
        //检查滑块
        if([MCOOSSDKCenter MCOShareSDK].pic_code_open == 1){
            ShowPicCode *showPicCodeVC = [[ShowPicCode alloc] init];
            NSString *url = [NSString stringWithFormat:@"%@/show?platform_id=%d&game_id=0&callback=getData&title=testtest&agent=2",[MCOOSSDKCenter MCOShareSDK].picVerifyUrl,[MCOOSSDKCenter MCOShareSDK].pic_platform_id];
            showPicCodeVC.type = 1;
            showPicCodeVC.pathUrl = url;
            [self.navigationController pushViewController:showPicCodeVC animated:NO];
        }else{
            [self getCode:nil];
        }
        
    } serverErrorBlock:^(id result) {
        MCOLog(@"检查用户失败 result = %@",result);
        [hud hideAnimated:NO];
        if ([result[@"error"] intValue] == 4) {
            //账号不存在
            [publicMath MCOHub:[publicMath getLocalString:@"invalidAccount"] messageView:self.view];
        }else{
            [publicMath MCOHub:@"Check User Error" messageView:self.view];
        }
    } failBlock:^{
        MCOLog(@"检查用户 网络错误");
        [hud hideAnimated:NO];
        [publicMath MCOHub:[publicMath getLocalString:@"netError"] messageView:self.view];
    }];
}


-(void)getCode:(NSDictionary *)verifyDic{
    
    NSMutableDictionary *codeDic = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@(6),@"open_id":[self.emailTF text]}];
    
    if (verifyDic != nil) {
        [codeDic setValue:verifyDic[@"ticket"] forKey:@"ticket"];
        [codeDic setValue:verifyDic[@"randstr"] forKey:@"randstr"];
    }
   
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    
    [HttpRequest POSTRequestWithUrlString:MCO_Verify_Code isPay:NO headerDic:nil parameters:codeDic successBlock:^(id result) {

        MCOLog(@"邮箱登录获取code成功 result = %@",result);
        [hud hideAnimated:NO];
        MCOEmailInputCodeVC *inputCodeVC = [[MCOEmailInputCodeVC alloc] init];
        inputCodeVC.emailStr = [self.emailTF text];
        inputCodeVC.titleStr = self.titleStr;
        inputCodeVC.type = self.type;
        inputCodeVC.btnStr = self.btnStr;
        inputCodeVC.time = 0;
        [self.navigationController pushViewController:inputCodeVC animated:NO];

    } serverErrorBlock:^(id result) {
        [hud hideAnimated:NO];
        MCOLog(@"邮箱切换获取code失败 result = %@",result);
        if ([result[@"error"] intValue] == 14) {
            MCOLog(@"获取验证码接口请求频繁");
            MCOEmailInputCodeVC *inputCodeVC = [[MCOEmailInputCodeVC alloc] init];
            inputCodeVC.emailStr = [self.emailTF text];
            inputCodeVC.titleStr = self.titleStr;
            inputCodeVC.type = self.type;
            inputCodeVC.btnStr = self.btnStr;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSInteger time = [[user objectForKey:@"countDownTime"] integerValue];
            if(time==0){
                inputCodeVC.time = 0;
            }else{
                inputCodeVC.time = 0;
                inputCodeVC.time = 60 - [[GetDeviceData getNowTime] integerValue] + time;
                [self.navigationController pushViewController:inputCodeVC animated:NO];
            }
            [self.navigationController pushViewController:inputCodeVC animated:NO];
        }else if([result[@"error"] intValue] == 11){
            //超过次数
            [publicMath MCOHub:[publicMath getLocalString:@"codeLimit"] messageView:self.view];
        }else{
            [publicMath MCOHub:@"Get Code Error" messageView:self.view];
        }
        
    } failBlock:^{
        [hud hideAnimated:NO];
        MCOLog(@"邮箱切换获取code失败 网络失败");
        [publicMath MCOHub:[publicMath getLocalString:@"netError"] messageView:self.view];
    }];
}


//判断是否输入email
-(void)inputEmailDidChange:(id)sender{
    UITextField *field = (UITextField *)sender;
    if ([publicMath isValidateEmail:[field text]]) {
        //不为空
        self.publicBtn.enabled = YES;
        self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Main_Theme_Color];
    }else{
        self.publicBtn.enabled = NO;
        self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Btn_Gray];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.emailTF resignFirstResponder];
}
@end
