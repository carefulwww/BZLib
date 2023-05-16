//
//  MCOEmailLoginVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/15.
//

#import "MCOEmailLoginVC.h"

static NSString *switchIden = @"Cell";

@implementation MCOEmailLoginVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    [self getEmailArr];
    [self initView];
}

-(void)getEmailArr{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([publicMath isBlankString:[NSString stringWithFormat:@"%@",[user objectForKey:@"emailAcount"]]]) {
        self.emailStr = [user objectForKey:@"emailAccount"];
    }
    NSMutableArray *saveArr = [NSMutableArray arrayWithArray:[user objectForKey:@"saveEmailArr"]];
    MCOLog(@"邮箱数组内容 %@",saveArr);
    
    if (saveArr.count > 0) {
        for (NSDictionary *dic in saveArr) {
            SwitchUserModel *model = [[SwitchUserModel alloc] initWithShowInfor:dic];
            [self.dataArr addObject:model];
        }
        [self.switchTableView reloadData];
    }

}

-(void)initView{
    self.bgView.frame = CGRectMake((ScreenWidth - 304)/2, (ScreenHeight - 270)/2, 304, 270);
    
    self.titleLabel.text = [publicMath getLocalString:@"emailLogin"];
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-self.titleLabel.frame.size.width)/2, 17, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    
    self.emailTF = [[MCOTextField alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-255)/2, 52, 255, 35)];
    self.emailTF.imageName = MCO_Email_Small_Image;
    
    self.emailTF.attributedPlaceholder = [[NSMutableAttributedString alloc]
                                     initWithString:[publicMath getLocalString:@"enterCorrectAccount"]
                                     attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:11]}];
    
    if ([publicMath isBlankString:self.emailStr]) {
        self.emailTF.text = self.emailStr;
    }
    
    self.emailTF.keyboardType = UIKeyboardTypeDefault;
    [self.emailTF addTarget:self action:@selector(inputEmailDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIView *emailRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 35)];
    emailRightView.center = self.switchBtn.center;
    [emailRightView addSubview:self.switchBtn];
    self.emailTF.rightView = emailRightView;
    self.emailTF.rightViewMode = UITextFieldViewModeAlways;
    
    
    self.passwordTF = [[MCOTextField alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-255)/2, (self.emailTF.frame.size.height+self.emailTF.frame.origin.y+12), 255, 35)];
    self.passwordTF.imageName = MCO_Password_Small_Image;
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.attributedPlaceholder = [[NSMutableAttributedString alloc]
                                        initWithString:[publicMath getLocalString:@"enterCorrectPassword"]
                                        attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:11]}];
    self.passwordTF.keyboardType = UIKeyboardTypeDefault;
    [self.passwordTF addTarget:self action:@selector(inputPasswordDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 35)];
    UIButton *eyeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 18, 15)];
    [eyeBtn setImage:[UIImage imageNamed:MCO_Open_Eyes_Small_Image] forState:UIControlStateNormal];
    [rightView addSubview:eyeBtn];
    [eyeBtn addTarget:self action:@selector(eyePress:) forControlEvents:UIControlEventTouchUpInside];
    self.passwordTF.rightView = rightView;
    self.passwordTF.rightViewMode = UITextFieldViewModeAlways;
    
    self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-255)/2, (self.passwordTF.frame.size.height+self.passwordTF.frame.origin.y+13), 255,31);
    [self.publicBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Btn_Gray]];
    [self.publicBtn setTitle:[publicMath getLocalString:@""] forState:UIControlStateNormal];
    [self.publicBtn setTitle:[publicMath getLocalString:@"intoGame"] forState:UIControlStateNormal];
    self.publicBtn.enabled = NO;
    [self.publicBtn addTarget:self action:@selector(sureBindPress) forControlEvents:UIControlEventTouchUpInside];
    
    //邮箱注册按钮
    UIButton *emailRegBtn = [[UIButton alloc] init];
    [emailRegBtn setTitle:[publicMath getLocalString:@"emailReg"] forState:UIControlStateNormal];
    [emailRegBtn setTitleColor:[UIColor colorWithHexString:MCO_Btn_Gray] forState:UIControlStateNormal];
    [emailRegBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [emailRegBtn addTarget:self action:@selector(emaiRegPress) forControlEvents:UIControlEventTouchUpInside];
    [emailRegBtn sizeToFit];
    emailRegBtn.frame = CGRectMake(26.5, (self.publicBtn.frame.size.height+self.publicBtn.frame.origin.y+1), emailRegBtn.frame.size.width, emailRegBtn.frame.size.height);
    
    //找回密码按钮
    UIButton *findPasswordBtn = [[UIButton alloc] init];
    [findPasswordBtn setTitle:[publicMath getLocalString:@"findPassword"] forState:UIControlStateNormal];
    [findPasswordBtn setTitleColor:[UIColor colorWithHexString:MCO_Btn_Gray] forState:UIControlStateNormal];
    [findPasswordBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [findPasswordBtn addTarget:self action:@selector(findPasswordPress) forControlEvents:UIControlEventTouchUpInside];
    [findPasswordBtn sizeToFit];
    findPasswordBtn.frame = CGRectMake((self.bgView.frame.size.width-findPasswordBtn.frame.size.width-28), (self.publicBtn.frame.size.height+self.publicBtn.frame.origin.y+1), findPasswordBtn.frame.size.width, findPasswordBtn.frame.size.height);
    
    //Or sign
    //其他账号登录
    self.msgLabel = [[UILabel alloc] init];
    self.msgLabel.font = [UIFont systemFontOfSize:14];
    self.msgLabel.textAlignment = NSTextAlignmentCenter;
    self.msgLabel.text = @"Or sign in with:";
    [self.msgLabel setTextColor:[UIColor colorWithHexString:MCO_Btn_Gray]];
    [self.msgLabel sizeToFit];
    self.msgLabel.frame = CGRectMake((self.bgView.frame.size.width-self.msgLabel.frame.size.width)/2, (self.publicBtn.frame.origin.y+self.publicBtn.frame.size.height+27), self.msgLabel.frame.size.width, self.msgLabel.frame.size.height);
    
    [self thirdLogin];
    self.thirdLoginView.frame = CGRectMake((self.bgView.frame.size.width-self.thirdLoginView.frame.size.width)/2, (self.msgLabel.frame.size.height+self.msgLabel.frame.origin.y+9), self.thirdLoginView.frame.size.width, self.thirdLoginView.frame.size.height);
    
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.emailTF];
    [self.bgView addSubview:self.passwordTF];
    [self.bgView addSubview:self.publicBtn];
    [self.bgView addSubview:emailRegBtn];
    [self.bgView addSubview:findPasswordBtn];
    [self.bgView addSubview:self.msgLabel];
    [self.bgView addSubview:self.thirdLoginView];
    
    [self.view addSubview:self.bgView];
    
    //下拉框
    [self.bgView addSubview:self.switchTableView];
    self.switchTableView.hidden = YES;
    
    self.view.userInteractionEnabled = YES;
    
}

- (UIButton *)switchBtn{
    if (!_switchBtn) {
        self.switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 18, 15)];
//        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 15)];
        self.switchBtn.imageView.frame = CGRectMake(0, 0, 18, 15);
        [self.switchBtn setImage:[UIImage imageNamed:MCO_Down] forState:UIControlStateNormal];
        self.switchBtn.tag = 1100;
        [self.switchBtn addTarget:self action:@selector(switchPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

-(void)switchPress:(UIButton *)btn{
    MCOLog(@"点击输入框按钮");
    if(btn.tag == 1100){
        [btn setImage:[UIImage imageNamed:MCO_Up] forState:UIControlStateNormal];
        btn.tag = 1200;
        if (self.dataArr.count >= 1) {
            if(self.dataArr.count < 3){
                self.switchTableView.frame = CGRectMake(self.emailTF.frame.origin.x, self.emailTF.frame.origin.y+self.emailTF.frame.size.height, self.emailTF.frame.size.width, 35*self.dataArr.count);
            }else{
                self.switchTableView.frame = CGRectMake(self.emailTF.frame.origin.x, self.emailTF.frame.origin.y+self.emailTF.frame.size.height, self.emailTF.frame.size.width, 35*3);
            }
            self.switchTableView.hidden = NO;
        }else{
            self.switchTableView.hidden = YES;
        }
    }else{
        btn.tag = 1100;
        [btn setImage:[UIImage imageNamed:MCO_Down] forState:UIControlStateNormal];
        self.switchTableView.hidden = YES;
    }
}

-(void)thirdLogin{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSArray *appArr = [user objectForKey:@"third_login"];
    if (appArr.count > 0) {
        
    }else{
        return;
    }
    
    CGFloat width = 32*appArr.count+34*(appArr.count-1);
    
    self.thirdLoginView = [[UIView alloc] init];
    
    int j = 0;
    for (int i = 0; i < appArr.count; i++) {
        ThirdLoginModel *app = [[ThirdLoginModel alloc] initWithShowInfor:appArr[i]];
        if (![app.provider.lowercaseString isEqualToString:@"email"]) {
            //开启该第三方登录
            ThirdLoginBtn *appButton = [ThirdLoginBtn buttonWithType:UIButtonTypeCustom];
            CGFloat x = (34+32)*j;
            j+=1;
            appButton.frame = CGRectMake(x, 0, 32, 32);
            NSString *appName = app.provider.lowercaseString;
            NSString *imageName = [NSString stringWithFormat:@"%@%@%@",@"MCOResource.bundle/",appName,@"_icon"];
            appButton.appId = app.appid;
            appButton.appName = appName;
            UIImage *btnImg = [UIImage imageNamed:imageName];
            [appButton setImage:btnImg forState:UIControlStateNormal];
            [appButton addTarget:self action:@selector(thirdLoginPress:) forControlEvents:UIControlEventTouchUpInside];
            [self.thirdLoginView addSubview:appButton];
        }else{
            width -= 66;
        }
    }
    self.thirdLoginView.frame = CGRectMake(0, 0, width, 32);
}

- (UITableView *)switchTableView{
    if (!_switchTableView) {
        self.switchTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.emailTF.frame.origin.x, (self.emailTF.frame.origin.y+self.emailTF.frame.size.height), 255, 35*3) style:UITableViewStylePlain];
        self.switchTableView.rowHeight = 35;
        self.switchTableView.delegate = self;
        self.switchTableView.dataSource = self;
        self.switchTableView.showsVerticalScrollIndicator = NO;
        self.switchTableView.showsHorizontalScrollIndicator = NO;
    }
    return _switchTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SwitchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:switchIden];
    if(!cell){
        cell = [[SwitchUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:switchIden];
    }
    if (self.dataArr.count > 0) {
        SwitchUserModel *userModel = self.dataArr[indexPath.row];
        cell.userNameLabel.text = userModel.emailStr;
        [cell.userNameLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.userNameLabel setTextColor:[UIColor colorWithHexString:@"#3E3E3E"]];
        cell.emailStr = userModel.emailStr;
        if ([publicMath isBlankString:self.emailStr]&&[userModel.emailStr isEqualToString:self.emailStr]) {
            //当前账号 打勾按钮
            [cell.deleteBtn setImage:[UIImage imageNamed:MCO_Hook] forState:UIControlStateNormal];
            [cell.deleteBtn addTarget:self action:@selector(choosePress:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            //删除按钮
            [cell.deleteBtn setImage:[UIImage imageNamed:MCO_Cell_Close] forState:UIControlStateNormal];
            [cell.deleteBtn addTarget:self action:@selector(deletePress:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}

-(void)choosePress:(UIButton *)btn{
    MCOLog(@"选中");
    self.switchBtn.tag = 1100;
    [self.switchBtn setImage:[UIImage imageNamed:MCO_Down] forState:UIControlStateNormal];
    self.switchTableView.hidden = YES;
    SwitchUserCell *cell = (SwitchUserCell *)[btn superview];
    NSIndexPath *indexPath = [self.switchTableView indexPathForCell:cell];
    SwitchUserModel *userModel = self.dataArr[indexPath.row];
    self.emailTF.text = userModel.emailStr;
}

/**
 删除信息
 */
-(void)deletePress:(UIButton *)btn{
    MCOLog(@"删除信息");
    if (self.dataArr.count > 1) {
        SwitchUserCell *cell = (SwitchUserCell *)[btn superview];
        NSIndexPath *indexPath = [self.switchTableView indexPathForCell:cell];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSMutableArray *saveArr = [NSMutableArray arrayWithArray:[user objectForKey:@"saveEmailArr"]];
        [saveArr removeObjectAtIndex:indexPath.row];
        [self.dataArr removeObjectAtIndex:indexPath.row];
        NSArray *arr = saveArr;
        [user setObject:arr forKey:@"saveEmailArr"];
        [user synchronize];
        [self.switchTableView reloadData];
        
        if (self.dataArr.count >= 1) {
            if (self.dataArr.count < 3) {
                self.switchTableView.frame = CGRectMake(self.emailTF.frame.origin.x, self.emailTF.frame.origin.y, 255, 35*self.dataArr.count);
            }else{
                self.switchTableView.frame = CGRectMake(self.emailTF.frame.origin.x, self.emailTF.frame.origin.y, 255, 35*3);
            }
            self.switchTableView.hidden = NO;
        }else{
            self.switchTableView.hidden = YES;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.switchBtn.tag = 1100;
    [self.switchBtn setImage:[UIImage imageNamed:MCO_Down] forState:UIControlStateNormal];
    self.switchTableView.hidden = YES;
    SwitchUserModel *userModel = self.dataArr[indexPath.row];
    self.emailTF.text = userModel.emailStr;
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

-(void)thirdLoginPress:(ThirdLoginBtn *)btn{
    
    NSString *appName = btn.appName;
    NSString *appId = btn.appId;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[MCOOSSDKCenter currentViewController].view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    if ([appName isEqualToString:@"apple"]) {

        MCOLog(@"苹果登录,appId = %@",appId);
        [self.appleLogin signInWithApple];
        
    }else if ([appName isEqualToString:@"google"]){
        
        MCOLog(@"谷歌登录,appId = %@",appId);
        
        @try {
            [[GIDSignIn sharedInstance] signIn];
            
        } @catch (NSException *exception) {
            MCOLog(@"google login fail  %@",exception);
            [hud hideAnimated:YES];
        } @finally {
            
        }
        
    }else if([appName isEqualToString:@"facebook"]){
        
        MCOLog(@"脸书登录,appId = %@",appId);
        [MCOFBLoginManager fbLogin:self isChange:NO hud:hud];
        
    }else if([appName isEqual:@"email"]){
        MCOLog(@"邮箱登录");
        
    }else{
        [hud hideAnimated:YES];
    }
    
}

//谷歌登录返回
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error != nil) {
        if (error.code == kGIDSignInErrorCodeHasNoAuthInKeychain) {
        
            MCOLog(@"The user has not signed in before or they have since signed out.");
        
        } else {
        
            MCOLog(@"%@", error.localizedDescription);
        
        }
        
        [[MBProgressHUD HUDForView:self.view] hideAnimated:YES];
        
        return;
  }
    
    MCOLog(@"user %@",user);
    
    NSDictionary *dic = @{
        @"type":@"1",//谷歌登录
        @"token":user.authentication.idToken,
        @"open_id":user.userID,
    };
    
    [MCOLoginManager reportThirdLogin:dic isChange:NO hud:[MBProgressHUD HUDForView:self.view]];
    
}

-(void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error{
    MCOLog(@"失败 error %@",error);
    [[MBProgressHUD HUDForView:self.view] hideAnimated:YES];
}


//苹果登陆
-(MCOAppleLogin *)appleLogin{
    
    if (!_appleLogin) {
        NSString *user;
    
        self.appleLogin = [MCOAppleLogin appLogoinFromUser:user view:self.view rect:CGRectMake(100, 100, 60, 60) block:^(NSInteger state, NSString *msg, id data) {
                    if (state==AppleLoginTypeSuccessful) {
                        
                        MCOLog(@"授权成功 %@",data);
                        
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        [dic setObject:@(3) forKey:@"type"];
                        [dic setObject:data[@"identityToken"] forKey:@"token"];
                        [dic setObject:data[@"authorizationCode"] forKey:@"code"];
                        [dic setObject:data[@"user"] forKey:@"open_id"];
                        
                        if([publicMath isBlankString:data[@"familyName"]]||[publicMath isBlankString:data[@"givenName"]]){
                            NSString *nickName = [NSString stringWithFormat:@"%@%@",data[@"familyName"],data[@"givenName"]];
                            [dic setObject:nickName forKey:@"nick_name"];
                        }
                        
                        [MCOLoginManager reportThirdLogin:dic isChange:NO hud:[MBProgressHUD HUDForView:self.view]];
                        
                    }else if(state == AppleLoginTypeUserSuccessful){
                        MCOLog(@"账号验证成功");
                    }else{
                        MCOLog(@"验证失败:%@",msg);
                        [[MBProgressHUD HUDForView:self.view] hideAnimated:YES];
                    }
                }];
    }
    return _appleLogin;
}



-(void)sureBindPress{
    MCOLog(@"确认邮箱登录");
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (![publicMath isValidateEmail:[self.emailTF text]]) {
        [hud hideAnimated:YES];
        [publicMath MCOHub:@"请输入正确的邮箱" messageView:self.view];
        return;
    }
    
    
    NSDictionary *dic = @{
        @"type":@"6",//邮箱登录
        @"open_id":self.emailTF.text,
        @"password":[GetDeviceData md5String:self.passwordTF.text],
    };
    
    [MCOLoginManager reportThirdLogin:dic isChange:NO hud:[MBProgressHUD HUDForView:self.view]];

}

-(void)emaiRegPress{
    MCOLog(@"邮箱注册");
    MCOEmailGetCodeVC *getCodeVC = [[MCOEmailGetCodeVC alloc] init];
    getCodeVC.titleStr = [publicMath getLocalString:@"emailReg"];
    getCodeVC.type = 1;//登录
    getCodeVC.btnStr = [publicMath getLocalString:@"intoGame"];
    [self.navigationController pushViewController:getCodeVC animated:nil];
}

-(void)findPasswordPress{
    MCOLog(@"找回密码");
    MCOEmailGetCodeVC *getCodeVC = [[MCOEmailGetCodeVC alloc] init];
    getCodeVC.titleStr = [publicMath getLocalString:@"findPassword"];
    getCodeVC.type = 4;//登录忘记密码
    getCodeVC.btnStr = [publicMath getLocalString:@"intoGame"];
    [self.navigationController pushViewController:getCodeVC animated:nil];
}

-(void)closePress{
    MCOLog(@"关闭邮箱切换窗口");
    [self dismissViewControllerAnimated:NO completion:nil];
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
