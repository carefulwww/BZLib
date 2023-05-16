//
//  ChangeAccountVC.m
//  MCOOverseasProject
//

#import "ChangeAccountVC.h"

@implementation ChangeAccountVC

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].presentingViewController = self;
    
    [self initView];
    
}

-(void)initView{
    //添加第三方登录按钮
    [self thirdLogin];
    
    //竖直布局
    self.bgView.frame = CGRectMake((ScreenWidth-304)/2, (ScreenHeight-241)/2, 304, 241);
    self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-263)/2, 53, 263, 40);
    self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-200)/2, 24, 200, 25);
    self.thirdLoginView.frame = CGRectMake((self.bgView.frame.size.width-self.thirdLoginView.frame.size.width)/2, self.tipLabel.frame.origin.y+self.tipLabel.frame.size.height+11, self.thirdLoginView.frame.size.width, self.thirdLoginView.frame.size.height);
    
    [self.titleLabel setText:[publicMath getLocalString:@"changeAccountTitle"]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *tipString = [publicMath getLocalString:@"changeAccountTip"];
    [self.tipLabel setFont:[UIFont systemFontOfSize:12]];
    self.tipLabel.numberOfLines = 0;
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:tipString];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];
    [paragraphStyle1 setLineSpacing:3];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [tipString length])];
    [self.tipLabel setAttributedText:attributedString1];
    
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.tipLabel];
    [self.closeBtn addTarget:self action:@selector(closePress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:self.closeBtn];
    
    [self.bgView addSubview:self.thirdLoginView];
    
    [self.view addSubview:self.bgView];
}

-(NSString *)firstWord:(NSString *)name{
    NSString *resultString = @"";
    if (name.length > 0) {
        resultString = [name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[name substringToIndex:1] capitalizedString]];
    }
    return resultString;
}


-(void)thirdLogin{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSArray *appArr = [user objectForKey:@"third_login"];
    if (appArr.count > 0) {
        
    }else{
        return;
    }
    
    CGFloat height = 45*appArr.count/2;
    
    self.thirdLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 137*2, height)];
    
    for (int i = 0; i < appArr.count; i++) {
        ThirdLoginModel *app = [[ThirdLoginModel alloc] initWithShowInfor:appArr[i]];
        NSString *appName = app.provider.lowercaseString;
        NSString *imageName = [NSString stringWithFormat:@"%@%@%@",@"MCOResource.bundle/",appName,@"_login"];
        UIImage *btnImg = [UIImage imageNamed:imageName];
        
        //开启该第三方登录
        ThirdLoginBtn *appButton = [ThirdLoginBtn buttonWithType:UIButtonTypeCustom];
        CGFloat x = (136.5+2)*(i%2);
        CGFloat y = (i/2)*44;
        appButton.frame = CGRectMake(x, y, 136.5, 43);
        
        [appButton setImage:btnImg forState:UIControlStateNormal];

        appButton.appId = app.appid;
        appButton.appName = appName;
        
        [appButton addTarget:self action:@selector(thirdLoginPress:) forControlEvents:UIControlEventTouchUpInside];
        [self.thirdLoginView addSubview:appButton];
    }
}

-(void)closePress{
    MCOLog(@"关闭界面");
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)thirdLoginPress:(ThirdLoginBtn *)btn{
    
    NSString *appName = btn.appName;
    NSString *appId = btn.appId;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[MCOOSSDKCenter currentViewController].view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    if ([appName isEqualToString:@"apple"]) {

        MCOLog(@"切换苹果,appId = %@",appId);
        
        [self.appleLogin signInWithApple];
        
    }else if ([appName isEqualToString:@"google"]){
        
        MCOLog(@"切换谷歌,appId = %@",appId);
        
        @try {
            [[GIDSignIn sharedInstance] signIn];
        } @catch (NSException *exception) {
            MCOLog(@"google login fail  %@",exception);
            [hud hideAnimated:YES];
        } @finally {
            
        }
        
    }else if([appName isEqualToString:@"facebook"]){
        MCOLog(@"切换脸书,appId = %@",appId);
        [MCOFBLoginManager fbLogin:self isChange:YES hud:hud];
        
    }else if([appName isEqualToString:@"email"]){
        //邮箱切换
        [hud hideAnimated:YES];
        MCOEmailChangeVC *changeVC = [[MCOEmailChangeVC alloc] init];
        [self.navigationController pushViewController:changeVC animated:NO];
    }else{
        [hud hideAnimated:YES];
    }
    
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
                        
                        [MCOLoginManager reportThirdLogin:dic isChange:YES hud:[MBProgressHUD HUDForView:self.view]];
                        
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
    
    [MCOLoginManager reportThirdLogin:dic isChange:YES hud:[MBProgressHUD HUDForView:self.view]];
    
}

-(void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error{
    MCOLog(@"失败 error %@",error);
    [MBProgressHUD HUDForView:self.view];
}

@end
