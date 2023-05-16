//
//  MCOEmailBindVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/14.
//

#import "MCOEmailBindVC.h"

@implementation MCOEmailBindVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifySuc:) name:@"modifySuc" object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"modifySuc" object:nil];
}

-(void)modifySuc:(NSNotification *)notification{
    NSDictionary *backInfo = [notification userInfo];
    self.emailStr = [backInfo objectForKey:@"emailStr"];
    if ([publicMath isBlankString:self.emailStr]) {
        self.emailTF.text = self.emailStr;
    }
}

-(void)initView{
    self.bgView.frame = CGRectMake((ScreenWidth - 304)/2, (ScreenHeight - 241)/2, 304, 241);
    
    self.titleLabel.text = [publicMath getLocalString:@"emailBind"];
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-self.titleLabel.frame.size.width)/2, 17, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    
    [self.mcoBackBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.emailTF = [[MCOTextField alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-255)/2, 61, 255, 35)];
    self.emailTF.imageName = MCO_Email_Small_Image;
    self.emailTF.attributedPlaceholder = [[NSMutableAttributedString alloc]
                                     initWithString:[publicMath getLocalString:@"enterCorrectAccount"]
                                     attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:11]}];
    [self.emailTF addTarget:self action:@selector(inputEmailDidChange:) forControlEvents:UIControlEventEditingChanged];
//    if ([publicMath isBlankString:self.emailStr]) {
//        self.emailTF.text = self.emailStr;
//    }
    
    self.passwordTF = [[MCOTextField alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-255)/2, (self.emailTF.frame.size.height+self.emailTF.frame.origin.y+12), 255, 35)];
    self.passwordTF.imageName = MCO_Password_Small_Image;
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.attributedPlaceholder = [[NSMutableAttributedString alloc]
                                        initWithString:[publicMath getLocalString:@"enterCorrectPassword"]
                                        attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:11]}];
    [self.passwordTF addTarget:self action:@selector(inputPasswordDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 35)];
    UIButton *eyeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 18, 15)];
    [eyeBtn setImage:[UIImage imageNamed:MCO_Open_Eyes_Small_Image] forState:UIControlStateNormal];
    [rightView addSubview:eyeBtn];
    [eyeBtn addTarget:self action:@selector(eyePress:) forControlEvents:UIControlEventTouchUpInside];
    self.passwordTF.rightView = rightView;
    self.passwordTF.rightViewMode = UITextFieldViewModeAlways;
    
    self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-255)/2, (self.passwordTF.frame.size.height+self.passwordTF.frame.origin.y+13), 255,31);
    [self.publicBtn setTitle:[publicMath getLocalString:@"sureBind"] forState:UIControlStateNormal];
    [self.publicBtn addTarget:self action:@selector(sureBindPress) forControlEvents:UIControlEventTouchUpInside];
    
    //邮箱注册按钮
    UIButton *emailRegBtn = [[UIButton alloc] init];
    [emailRegBtn setTitle:[publicMath getLocalString:@"bindNewEmail"] forState:UIControlStateNormal];
    [emailRegBtn setTitleColor:[UIColor colorWithHexString:MCO_Btn_Gray] forState:UIControlStateNormal];
    [emailRegBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [emailRegBtn addTarget:self action:@selector(emaiRegPress) forControlEvents:UIControlEventTouchUpInside];
    [emailRegBtn sizeToFit];
    emailRegBtn.frame = CGRectMake(26.5, (self.publicBtn.frame.size.height+self.publicBtn.frame.origin.y+7), emailRegBtn.frame.size.width, emailRegBtn.frame.size.height);
    
    //邮箱注册按钮
    UIButton *findPasswordBtn = [[UIButton alloc] init];
    [findPasswordBtn setTitle:[publicMath getLocalString:@"findPassword"] forState:UIControlStateNormal];
    [findPasswordBtn setTitleColor:[UIColor colorWithHexString:MCO_Btn_Gray] forState:UIControlStateNormal];
    [findPasswordBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [findPasswordBtn addTarget:self action:@selector(findPasswordPress) forControlEvents:UIControlEventTouchUpInside];
    [findPasswordBtn sizeToFit];
    findPasswordBtn.frame = CGRectMake((self.bgView.frame.size.width-findPasswordBtn.frame.size.width-28), (self.publicBtn.frame.size.height+self.publicBtn.frame.origin.y+7), findPasswordBtn.frame.size.width, findPasswordBtn.frame.size.height);
    
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.mcoBackBtn];
    [self.bgView addSubview:self.emailTF];
    [self.bgView addSubview:self.passwordTF];
    [self.bgView addSubview:self.publicBtn];
    [self.bgView addSubview:emailRegBtn];
    [self.bgView addSubview:findPasswordBtn];
    
    [self.view addSubview:self.bgView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.emailTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

//判断是否输入email
-(void)inputEmailDidChange:(id)sender{
    UITextField *field = (UITextField *)sender;
    if ([publicMath isValidateEmail:[field text]] && self.passwordTF.text.length > 5) {
        //不为空
        self.publicBtn.enabled = YES;
        self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Main_Theme_Color];
    }else{
        self.publicBtn.enabled = NO;
        self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Btn_Gray];
    }
}

-(void)inputPasswordDidChange:(id)sender{
    UITextField *field = (UITextField *)sender;
    if ([field text].length > 5 && [publicMath isValidateEmail:self.emailTF.text]) {
        //不为空
        self.publicBtn.enabled = YES;
        self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Main_Theme_Color];
    }else{
        self.publicBtn.enabled = NO;
        self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Btn_Gray];
    }
}

-(void)sureBindPress{
    MCOLog(@"确认绑定");
    
    if (![publicMath isValidateEmail:[self.emailTF text]]) {
        [publicMath MCOHub:[publicMath getLocalString:@"inputCorrectEmail"] messageView:self.view];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSDictionary *dic = @{
        @"bind_type":@"6",
        @"open_id":[self.emailTF text],
        @"third_token":@"",
        @"password":[GetDeviceData md5String:[self.passwordTF text]]
    };
    
    [MCOLoginManager reportBindThirdLogin:dic hud:[MBProgressHUD HUDForView:self.view]];

}

-(void)emaiRegPress{
    MCOLog(@"新邮箱注册");
//    MCOEmailGetCodeVC *getCodeVC = [[MCOEmailGetCodeVC alloc] init];
//    getCodeVC.type = 3;
//    getCodeVC.titleStr = [publicMath getLocalString:@"emailBind"];
//    getCodeVC.btnStr = [publicMath getLocalString:@"sureBind"];
//    [self.navigationController pushViewController:getCodeVC animated:NO];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)findPasswordPress{
    MCOLog(@"找回密码");
    MCOEmailGetCodeVC *getCodeVC = [[MCOEmailGetCodeVC alloc] init];
    getCodeVC.titleStr = [publicMath getLocalString:@"findPassword"];
    getCodeVC.type = 6;//绑定忘记密码
    getCodeVC.btnStr = [publicMath getLocalString:@"sureModify"];
    [self.navigationController pushViewController:getCodeVC animated:nil];
}

-(void)backPress{
    MCOLog(@"关闭邮箱切换窗口");
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)eyePress:(UIButton *)eyeBtn{
    if(self.passwordTF.isSecureTextEntry){
        MCOLog(@"密码变为可见");
        self.passwordTF.secureTextEntry = NO;
        [eyeBtn setImage:[UIImage imageNamed:MCO_Close_Eyes_Small_Image] forState:UIControlStateNormal];
    }else{
        MCOLog(@"密码变为不可见");
        self.passwordTF.secureTextEntry = YES;
        [eyeBtn setImage:[UIImage imageNamed:MCO_Open_Eyes_Small_Image] forState:UIControlStateNormal];
    }
}


@end
