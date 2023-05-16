//
//  MCOEmailInputPasswordVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/15.
//

#import "MCOEmailInputPasswordVC.h"

@implementation MCOEmailInputPasswordVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    self.bgView.frame = CGRectMake((ScreenWidth-304)/2, (ScreenHeight-241)/2, 304, 241);
    [self.mcoBackBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];

    self.titleLabel.text = self.titleStr;
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-self.titleLabel.frame.size.width)/2, 17, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    
    if([publicMath isBlankString:self.tipStr]){
        //请输入新密码
        UITextView *newPassword = [[UITextView alloc] init];
        newPassword.text = self.tipStr;
        [newPassword setFont:[UIFont systemFontOfSize:11]];
        [newPassword setTextColor:[UIColor colorWithHexString:@"#606060"]];
        [newPassword sizeToFit];
        newPassword.frame = CGRectMake(24, 50, newPassword.frame.size.width, newPassword.frame.size.height);
        [self.bgView addSubview:newPassword];
    }
    
    self.inputPasswordTF = [[MCOTextField alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-255)/2, 77, 255, 35)];
    self.inputPasswordTF.imageName = MCO_Password_Small_Image;
    self.inputPasswordTF.placeholder = [publicMath getLocalString:@"inputPasswordTip"];
    self.inputPasswordTF.secureTextEntry = YES;
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 35)];
    UIButton *eyeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 18, 15)];
    
    [eyeBtn setImage:[UIImage imageNamed:MCO_Open_Eyes_Small_Image] forState:UIControlStateNormal];
    [rightView addSubview:eyeBtn];
    [eyeBtn addTarget:self action:@selector(eyePress:) forControlEvents:UIControlEventTouchUpInside];
    self.inputPasswordTF.rightView = rightView;
    self.inputPasswordTF.rightViewMode = UITextFieldViewModeAlways;
    [self.inputPasswordTF addTarget:self action:@selector(inputPasswordDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-254)/2, (self.inputPasswordTF.frame.size.height+self.inputPasswordTF.frame.origin.y+16), 254, 31);
    [self.publicBtn setTitle:self.btnStr forState:UIControlStateNormal];
    self.publicBtn.enabled = NO;
    self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Btn_Gray];
    [self.publicBtn addTarget:self action:@selector(surePress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.mcoBackBtn];
    [self.bgView addSubview:self.inputPasswordTF];
    [self.bgView addSubview:self.publicBtn];

    [self.view addSubview:self.bgView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.inputPasswordTF resignFirstResponder];
}

//判断是否输入password
-(void)inputPasswordDidChange:(id)sender{
    UITextField *field = (UITextField *)sender;
    if ([field text].length > 5 && [field text].length < 17) {
        //不为空
        self.publicBtn.enabled = YES;
        self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Main_Theme_Color];
    }else{
        self.publicBtn.enabled = NO;
        self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Btn_Gray];
    }
}

-(void)backPress{
    MCOLog(@"backPress");
//    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)surePress{
    //判断是否为数字加字母
//    if (![publicMath isLettersAndNumbersAndUnderScore:[self.inputPasswordTF text]]) {
//        [publicMath MCOHub:@"请输入同时只包含数字和字母的密码" messageView:self.view];
//        return;
//    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (self.type == 1) {
        //1.登录
        MCOLog(@"登录");
        NSDictionary *dic = @{
            @"type":@"6",
            @"open_id":self.emailStr,
            @"token":self.token,
            @"password":[GetDeviceData md5String:[self.inputPasswordTF text]]
        };
        [MCOLoginManager reportThirdLogin:dic isChange:NO hud:[MBProgressHUD HUDForView:self.view]];
    }else if (self.type == 2 ){
        //2.绑定
        MCOLog(@"切换登录");
        NSDictionary *dic = @{
            @"type":@"6",
            @"open_id":self.emailStr,
            @"token":self.token,
            @"password":[GetDeviceData md5String:[self.inputPasswordTF text]]
        };
        [MCOLoginManager reportThirdLogin:dic isChange:YES hud:[MBProgressHUD HUDForView:self.view]];
        
    }else if(self.type == 3){
        MCOLog(@"绑定");
        NSDictionary *bindDic = @{
            @"bind_type":@"6",
            @"open_id":self.emailStr,
            @"third_token":self.token,
            @"password":[GetDeviceData md5String:[self.inputPasswordTF text]]
        };
        [MCOLoginManager reportBindThirdLogin:bindDic hud:[MBProgressHUD HUDForView:[MBProgressHUD HUDForView:self.view]]];
    }else if(self.type==4 || self.type == 5 || self.type == 6){
        //4.登录忘记密码 5.切换忘记密码 6.绑定忘记密码
        MCOLog(@"忘记密码登录");
        NSDictionary *dic = @{
            @"type":@"6",
            @"open_id":self.emailStr,
            @"token":self.token,
            @"password":[GetDeviceData md5String:[self.inputPasswordTF text]]
        };
        [HttpRequest POSTRequestWithUrlString:MCO_Password_Modify isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
            MCOLog(@"修改密码成功 result = %@",result);
            if (self.type == 4) {
                NSDictionary *dicLogin = @{
                    @"type":@"6",
                    @"open_id":self.emailStr,
                    @"password":[GetDeviceData md5String:[self.inputPasswordTF text]]
                };
                [MCOLoginManager reportThirdLogin:dicLogin isChange:NO hud:[MBProgressHUD HUDForView:self.view]];
            }else if(self.type == 5){
                NSDictionary *dicLogin = @{
                    @"type":@"6",
                    @"open_id":self.emailStr,
                    @"password":[GetDeviceData md5String:[self.inputPasswordTF text]]
                };
                [MCOLoginManager reportThirdLogin:dicLogin isChange:YES hud:[MBProgressHUD HUDForView:self.view]];
            }else{
                [hud hideAnimated:NO];
                [publicMath MCOHub:[publicMath getLocalString:@"sureModify"] messageView:self.view];
                //关闭修改密码界面，回到绑定界面
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[MCOEmailBindVC class]]) {
                        NSDictionary *backInfo = @{
                            @"emailStr":self.emailStr
                        };
                        NSNotification *notification =[NSNotification notificationWithName:@"modifySuc" object:nil userInfo:backInfo];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:notification];
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            }
        } serverErrorBlock:^(id result) {
            MCOLog(@"修改密码错误 result = %@",result);
            [hud hideAnimated:NO];
            if([result[@"error"] intValue]==12){
                //验证码失效
                [publicMath MCOHub:[publicMath getLocalString:@"codeInvalid"] messageView:self.view];
            }else{
                [publicMath MCOHub:result[@"msg"] messageView:self.view];
            }
        } failBlock:^{
            MCOLog(@"修改密码错误 网络错误");
            [hud hideAnimated:NO];
            [publicMath MCOHub:[publicMath getLocalString:@"netError"] messageView:self.view];
        }];
    }
}

-(void)eyePress:(UIButton *)eyeBtn{
    if(self.inputPasswordTF.isSecureTextEntry){
        MCOLog(@"密码变为可见");
        self.inputPasswordTF.secureTextEntry = NO;
        [eyeBtn setImage:[UIImage imageNamed:MCO_Close_Eyes_Small_Image] forState:UIControlStateNormal];
    }else{
        MCOLog(@"密码变为不可见");
        self.inputPasswordTF.secureTextEntry = YES;
        [eyeBtn setImage:[UIImage imageNamed:MCO_Open_Eyes_Small_Image] forState:UIControlStateNormal];
    }
}

@end
