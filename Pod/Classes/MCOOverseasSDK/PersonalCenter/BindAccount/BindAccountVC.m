//
//  BindAccountVC.m
//  MCOOverseasProject
//
//

#import "BindAccountVC.h"

@implementation BindAccountVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].presentingViewController = self;
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindSuc) name:@"bindSuc" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindSuc) name:@"backPersonCenter" object:nil];
}

-(void)bindSuc{
    MCOLog(@"btnArr = %@ ",self.btnArr);
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSArray *bind_third_login_type = [user objectForKey:@"bind_third_login_type"];
    
    if([bind_third_login_type count]>0){
        for (MCOBindBtn *btn in self.btnArr) {
            //已经绑定
            NSString *appName = btn.appName.lowercaseString;
            for (NSString *typeInt in bind_third_login_type) {
                if (typeInt == btn.type) {
                 
                    if ([appName isEqualToString:@"email"]) {
                        btn.goLabel.text = [publicMath getLocalString:@"checkAccount"];
                    }else{
                        btn.enabled = NO;
                        btn.goImage.hidden = YES;
                        btn.goLabel.text = [publicMath getLocalString:@"bound"];
                    }
                    [btn reloadInputViews];
                    break;
                }
            }
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bindSuc" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backPersonCenter" object:nil];
}

-(void)initView{
    
    [self.titleLabel setText:[publicMath getLocalString:@"bindAccountBtn"]];
    
    //添加第三方登录按钮
    [self thirdLogin];
    
    NSString *tipString = [publicMath getLocalString:@"bindAccountTip"];
    
    CGSize sizeName = [tipString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(250, 50) lineBreakMode:NSLineBreakByWordWrapping];
    
    self.tipLabel.frame = CGRectMake(8, 50, 250, sizeName.height);
    
    self.tipLabel.text = tipString;
    self.tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
//    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:tipString];
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setAlignment:NSTextAlignmentCenter];
//    [paragraphStyle1 setLineSpacing:3];
//    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [tipString length])];
//    [self.tipLabel setAttributedText:attributedString1];
//    [self.tipLabel sizeToFit];
    
    //竖直布局
    self.bgView.frame = CGRectMake((self.view.frame.size.width-303)/2, (self.view.frame.size.height-300)/2, 303, 300);
    
    self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-200)/2, 15, 200, 25);
    self.thirdLoginView.frame = CGRectMake((self.bgView.frame.size.width-self.thirdLoginView.frame.size.width)/2, self.tipLabel.frame.origin.y+self.tipLabel.frame.size.height+7, self.thirdLoginView.frame.size.width, self.thirdLoginView.frame.size.height);

    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.closeBtn addTarget:self action:@selector(closePress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.tipLabel];
    [self.bgView addSubview:self.thirdLoginView];
    [self.bgView addSubview:self.closeBtn];
    
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
    
    NSArray *bind_third_login_type = [user objectForKey:@"bind_third_login_type"];
    
    if (appArr.count > 0) {
        
    }else{
        return;
    }
    

    CGFloat height = appArr.count*53;
    
    self.thirdLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 294, height)];
    
    self.btnArr = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MCOResource" ofType:@"bundle"];
    NSArray *nib = [[NSBundle bundleWithPath:path] loadNibNamed:@"MCOBindBtnVC" owner:self options:nil];
    
    for (int i = 0; i < appArr.count; i++) {
//        MCOBindBtn *appButton = [[[NSBundle mainBundle] loadNibNamed:@"MCOBindBtnVC" owner:self options:nil] objectAtIndex:i];
        MCOBindBtn *appButton = [nib objectAtIndex:i];
        CGFloat y = 56*i;
        appButton.frame = CGRectMake(0, y, 294, 54);
        //开启该第三方登录
        ThirdLoginModel *app = [[ThirdLoginModel alloc] initWithShowInfor:appArr[i]];
        
        NSString *appName = app.provider.lowercaseString;
        NSString *imageName = [NSString stringWithFormat:@"%@%@%@",@"MCOResource.bundle/",appName,@"_bind"];
        UIImage *btnImg = [UIImage imageNamed:imageName];
        
        NSString *goString = [publicMath getLocalString:@"goToBind"];
        appButton.open = @"0";
        if([bind_third_login_type count]>0){
            //已经绑定
            for (NSString *typeInt in bind_third_login_type) {
                if (typeInt == app.type) {
                    appButton.open = @"1";
                    if ([appName isEqualToString:@"email"]) {
                        goString = [publicMath getLocalString:@"checkAccount"];
                    }else{
                        appButton.enabled = NO;
                        appButton.goImage.hidden = YES;
                        goString = [publicMath getLocalString:@"bound"];
                    }
                    break;
                }
            }
        }
        
        appButton.appId = app.appid;
        appButton.appName = appName;
        appButton.type = app.type;
        [self.btnArr addObject:appButton];
        
        if([appName isEqualToString:@"apple"]){
            appName = @"Sign in with Apple";
        }else{
            appName = [self firstWord:appName];
        }
        
        appButton.appNameLabel.text = appName;
        appButton.appLogoImage.image = btnImg;
        appButton.goLabel.text = goString;
        [appButton.goLabel sizeToFit];
        appButton.goLabel.textAlignment = NSTextAlignmentRight;
        appButton.goLabel.frame = CGRectMake((appButton.frame.size.width-appButton.goLabel.frame.size.width-30), (appButton.frame.size.height-appButton.goLabel.frame.size.height)/2, appButton.goLabel.frame.size.width, appButton.goLabel.frame.size.height);
        [self.thirdLoginView addSubview:appButton];
        
        [appButton addTarget:self action:@selector(thirdLoginPress:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)closePress{
    MCOLog(@"关闭界面");
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

-(void)thirdLoginPress:(MCOBindBtn *)btn{
    
    NSString *appName = btn.appName;
    NSString *appId = btn.appId;
    int type = [btn.open intValue];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[MCOOSSDKCenter currentViewController].view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    if ([appName isEqualToString:@"apple"]) {

        MCOLog(@"苹果绑定,appId = %@",appId);
        
        [self.appleLogin signInWithApple];
        
    }else if ([appName isEqualToString:@"google"]){
        
        MCOLog(@"谷歌绑定,appId = %@",appId);
        
        @try {
            [[GIDSignIn sharedInstance] signIn];
        } @catch (NSException *exception) {
            MCOLog(@"google login fail  %@",exception);
            [hud hideAnimated:YES];
        } @finally {
            
        }
        
    }else if([appName isEqualToString:@"facebook"]){
        
        MCOLog(@"脸书绑定,appId = %@",appId);
        [MCOFBLoginManager fbBind:self hud:hud];
        
    }else if([appName isEqualToString:@"email"]){
        MCOLog(@"邮箱绑定");
        [hud hideAnimated:YES];
        if (type == 1) {
            //查看账号
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *account = [user objectForKey:@"emailAccount"];
            if ([publicMath isBlankString:[NSString stringWithFormat:@"%@",account]]) {
                MCOCheckAccountVC *checkVC = [[MCOCheckAccountVC alloc] init];
                checkVC.account = account;
                [self.navigationController pushViewController:checkVC animated:NO];
            }else{
                [publicMath MCOHub:@"error" messageView:self.view];
            }
        }else{
            //邮箱绑定
//            MCOEmailBindVC *emailBindVC = [[MCOEmailBindVC alloc] init];
//            [self.navigationController pushViewController:emailBindVC animated:NO];
            MCOEmailGetCodeVC *getCodeVC = [[MCOEmailGetCodeVC alloc] init];
            getCodeVC.type = 3;
            getCodeVC.titleStr = [publicMath getLocalString:@"emailBind"];
            getCodeVC.btnStr = [publicMath getLocalString:@"sureBind"];
            [self.navigationController pushViewController:getCodeVC animated:NO];
        }
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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![publicMath isBlankString:[userDefaults objectForKey:@"uuid"]]||![publicMath isBlankString:[userDefaults objectForKey:@"token"]]) {
        MCOLog(@"第三方账号绑定uuid、token不可为空");
        return;
    }
    
    NSDictionary *dic = @{
        @"bind_type":@"1",//谷歌绑定
        @"third_token":user.authentication.idToken,
        @"open_id":user.userID,
        @"uuid":[userDefaults objectForKey:@"uuid"],
        @"token":[userDefaults objectForKey:@"token"],
    };
    
    [MCOLoginManager reportBindThirdLogin:dic hud:[MBProgressHUD HUDForView:self.view]];
    
}

-(void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error{
    MCOLog(@"谷歌授权失败 error %@",error);
    [[MBProgressHUD HUDForView:self.view] hideAnimated:YES];
}

//返回个人中心界面
-(void)backPersonCenter{
    [self dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backPressSuc" object:nil];
}
//

-(MCOAppleLogin *)appleLogin{
    
    if (!_appleLogin) {
        NSString *user;
        
        self.appleLogin = [MCOAppleLogin appLogoinFromUser:user view:self.view rect:CGRectMake(100, 100, 60, 60) block:^(NSInteger state, NSString *msg, id data) {
                    if (state==AppleLoginTypeSuccessful) {
                        MCOLog(@"授权成功 %@",data);
                        
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        
                        if (![publicMath isBlankString:[userDefaults objectForKey:@"uuid"]]||![publicMath isBlankString:[userDefaults objectForKey:@"token"]]) {
                            MCOLog(@"第三方账号绑定uuid、token不可为空");
                            return;
                        }
                        NSString *uuid = [userDefaults objectForKey:@"uuid"];
                        NSString *token = [userDefaults objectForKey:@"token"];
                        
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        [dic setObject:@(3) forKey:@"bind_type"];
                        [dic setObject:data[@"identityToken"] forKey:@"third_token"];
                        [dic setObject:data[@"authorizationCode"] forKey:@"code"];
                        [dic setObject:data[@"user"] forKey:@"open_id"];
                        [dic setObject:uuid forKey:@"uuid"];
                        [dic setObject:token forKey:@"token"];
                        
                        if([publicMath isBlankString:data[@"familyName"]]||[publicMath isBlankString:data[@"givenName"]]){
                            NSString *nickName = [NSString stringWithFormat:@"%@%@",data[@"familyName"],data[@"givenName"]];
                            [dic setObject:nickName forKey:@"nick_name"];
                        }
                        
                        [MCOLoginManager reportBindThirdLogin:dic hud:[MBProgressHUD HUDForView:self.view]];
                        
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
