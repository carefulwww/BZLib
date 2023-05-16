//
//  OnekeyLoginVC.m
//  MCOOverseasProject
//
//

#import "OnekeyLoginVC.h"

@implementation OnekeyLoginVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].presentingViewController = self;
    [self initView];
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationPortrait:
//            MCOLog(@"正常竖直状态");
//            self.bgView.frame = CGRectMake((ScreenWidth-303)/2, (ScreenHeight-226)/2, 303, 226);
//            self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-202)/2, 36, 202, 44);
//            self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-271)/2, 104, 271, 36);
//            self.msgLabel.frame = CGRectMake((self.bgView.frame.size.width-131)/2, 150, 131, 20);
//            self.thirdLoginView.frame = CGRectMake((self.bgView.frame.size.width-self.thirdLoginView.frame.size.width)/2, 179, self.thirdLoginView.frame.size.width, self.thirdLoginView.frame.size.height);
//            break;
        case UIInterfaceOrientationPortraitUpsideDown:
//            MCOLog(@"倒放竖直状态");
            self.bgView.frame = CGRectMake((ScreenWidth-303)/2, (ScreenHeight-226)/2, 303, 226);
            self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-202)/2, 36, 202, 44);
            self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-271)/2, 104, 271, 36);
            self.msgLabel.frame = CGRectMake((self.bgView.frame.size.width-131)/2, 150, 131, 20);
            self.thirdLoginView.frame = CGRectMake((self.bgView.frame.size.width-self.thirdLoginView.frame.size.width)/2, 179, self.thirdLoginView.frame.size.width, self.thirdLoginView.frame.size.height);
            break;
        case UIInterfaceOrientationLandscapeLeft:
//            self.bgView.frame = CGRectMake((ScreenWidth-346)/2, (ScreenHeight-208)/2, 346, 208);
//            self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-202)/2, 36, 202, 44);
//            self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-298)/2, 90, 298, 36);
//            self.msgLabel.frame = CGRectMake((self.bgView.frame.size.width-131)/2, 134, 131, 20);
//            self.thirdLoginView.frame = CGRectMake((self.bgView.frame.size.width-self.thirdLoginView.frame.size.width)/2, 163 , self.thirdLoginView.frame.size.width, self.thirdLoginView.frame.size.height);
//            break;
        case UIInterfaceOrientationLandscapeRight:
            self.bgView.frame = CGRectMake((ScreenWidth-346)/2, (ScreenHeight-208)/2, 346, 208);
            self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-202)/2, 36, 202, 44);
            self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-298)/2, 90, 298, 36);
            self.msgLabel.frame = CGRectMake((self.bgView.frame.size.width-131)/2, 134, 131, 20);
            self.thirdLoginView.frame = CGRectMake((self.bgView.frame.size.width-self.thirdLoginView.frame.size.width)/2, 163 , self.thirdLoginView.frame.size.width, self.thirdLoginView.frame.size.height);
            break;
        default:
            break;
    }
}

-(void)initView{
//    NSString *tipString = @"Facebook登录状态已失效，请重新登录。";
    
    NSString *tipString;
    
    if (self.appState == 1) {
        tipString = [publicMath getLocalString:@"googleLoginTip"];
    }else if(self.appState == 2){
        tipString = [publicMath getLocalString:@"facebookLoginTip"];
    }else if(self.appState == 3){
        tipString = [publicMath getLocalString:@"appleLoginTip"];
    }else if(self.appState == 6){
        //邮箱
        tipString = [publicMath getLocalString:@"emailLoginTip"];
    }else{
        tipString = @"游客状态";
    }
    self.tipLabel.font = [UIFont systemFontOfSize:16];
    self.tipLabel.numberOfLines = 0;
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:tipString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];
    [paragraphStyle1 setLineSpacing:3];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [tipString length])];
    [self.tipLabel setAttributedText:attributedString1];
    
    self.msgLabel = [[UILabel alloc] init];
    
    //添加第三方登录按钮
    [self thirdLogin];
    
    if (ScreenWidth > ScreenHeight) {
        //横布局
        self.bgView.frame = CGRectMake((ScreenWidth-346)/2, (ScreenHeight-208)/2, 346, 208);
        self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-298)/2, 90, 298, 36);
        self.msgLabel.frame = CGRectMake((self.bgView.frame.size.width-300)/2, 134, 300, 20);
        self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-202)/2, 32, 202, 44);
        self.thirdLoginView.frame = CGRectMake((self.bgView.frame.size.width-self.thirdLoginView.frame.size.width)/2, 163 , self.thirdLoginView.frame.size.width, self.bgView.frame.size.height);
    }else{
        //竖布局
        self.bgView.frame = CGRectMake((ScreenWidth-303)/2, (ScreenHeight-226)/2, 303, 226);
        self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-271)/2, 104, 271, 36);
        self.msgLabel.frame = CGRectMake((self.bgView.frame.size.width-300)/2, 150, 300, 30);
        self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-202)/2, 36, 202, 44);
        self.thirdLoginView.frame = CGRectMake((self.bgView.frame.size.width-self.thirdLoginView.frame.size.width)/2, 179, self.thirdLoginView.frame.size.width, self.thirdLoginView.frame.size.height);
    }
    
    //提示label
    [self.bgView addSubview:self.tipLabel];
    
    //去登录按钮
    [self.publicBtn setTitle:[publicMath getLocalString:@"login"] forState:UIControlStateNormal];
    [self.bgView addSubview:self.publicBtn];
    [self.publicBtn addTarget:self action:@selector(goLoginPress) forControlEvents:UIControlEventTouchUpInside];
    
    //其他账号登录
    self.msgLabel.font = [UIFont systemFontOfSize:14];
    self.msgLabel.textAlignment = NSTextAlignmentCenter;
//    [self.msgLabel setText:[NSString stringWithFormat:@"— %@ —",[publicMath getLocalString:@"otherLogin"]]];
    [self.msgLabel setText:@"Or sign in with:"];
    [self.msgLabel setTextColor:[UIColor colorWithHexString:@"#929191"]];
    [self.bgView addSubview:self.msgLabel];
    
    [self.bgView addSubview:self.thirdLoginView];
    
    [self.view addSubview:self.bgView];
    
    
}

-(void)goLoginPress{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[MCOOSSDKCenter currentViewController].view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    if (self.appState == 1) {
        //google
        @try {
            [[GIDSignIn sharedInstance] signIn];
        } @catch (NSException *exception) {
            MCOLog(@"google login fail  %@",exception);
            [hud hideAnimated:YES];
        } @finally {
            
        }
        
    }else if(self.appState == 2){
        //facebook
        [MCOFBLoginManager fbLogin:self isChange:NO hud:hud];
    }else if(self.appState == 3){
        //apple
        [self.appleLogin signInWithApple];
    }else if(self.appState == 6){
        //邮箱
        MCOLog(@"邮箱登录");
        [hud hideAnimated:YES];
        MCOEmailLoginVC *emailChangeVC = [[MCOEmailLoginVC alloc] init];
        [self.navigationController pushViewController:emailChangeVC animated:NO];
    }else{
        [hud hideAnimated:YES];
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
    
    self.thirdLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 32)];
    
    for (int i = 0; i < appArr.count; i++) {
        ThirdLoginModel *app = [[ThirdLoginModel alloc] initWithShowInfor:appArr[i]];
        //开启该第三方登录
        ThirdLoginBtn *appButton = [ThirdLoginBtn buttonWithType:UIButtonTypeCustom];
//        appButton.backgroundColor = [UIColor redColor];
        CGFloat x = (34+32)*i;
        appButton.frame = CGRectMake(x, 0, 32, 32);
        NSString *appName = app.provider.lowercaseString;
        NSString *imageName = [NSString stringWithFormat:@"%@%@%@",@"MCOResource.bundle/",appName,@"_icon"];
        appButton.appId = app.appid;
        appButton.appName = appName;
        UIImage *btnImg = [UIImage imageNamed:imageName];
        [appButton setImage:btnImg forState:UIControlStateNormal];
        [appButton addTarget:self action:@selector(thirdLoginPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.thirdLoginView addSubview:appButton];
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
        
    }else if([appName isEqualToString:@"email"]){
        MCOLog(@"邮箱登录");
        [hud hideAnimated:YES];
        MCOEmailLoginVC *emailChangeVC = [[MCOEmailLoginVC alloc] init];
        [self.navigationController pushViewController:emailChangeVC animated:NO];
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


@end


