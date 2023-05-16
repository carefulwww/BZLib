//
//  MCOLoginManager.m
//  MCOOverseasProject
//

#import "MCOLoginManager.h"

@implementation MCOLoginManager

+(void)reportThirdLogin:(NSDictionary *)dic isChange:(BOOL)isChange hud:(MBProgressHUD *)hud{
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[MCOOSSDKCenter currentViewController].view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    [HttpRequest POSTRequestWithUrlString:MCO_Third_Login isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
        MCOLog(@"第三方登录成功，result = %@",result);
        
        NSString *oldUUID = [user objectForKey:@"uuid"];
        
        NSMutableArray *bind_third_login_type = result[@"data"][@"bind_third_login_type"];
        NSString *displayName = result[@"data"][@"displayName"];
        NSString *token = result[@"data"][@"token"];
        NSString *uuid = result[@"data"][@"uuid"];
        NSString *showName = result[@"data"][@"showName"];
        NSString *third_login_type = result[@"data"][@"third_login_type"];
        NSString *third_identifier = result[@"data"][@"third_identifier"];
        
        [user setObject:bind_third_login_type forKey:@"bind_third_login_type"];
        [user setObject:displayName forKey:@"displayName"];
        [user setObject:token forKey:@"token"];
        [user setObject:uuid forKey:@"uuid"];
        [user setObject:showName forKey:@"showName"];
        [user setObject:third_login_type forKey:@"third_login_type"];
        [user setObject:third_identifier forKey:@"third_identifier"];
        
        NSString *emailAccount;
        NSDictionary *bind_third_login_type_detail = result[@"data"][@"bind_third_login_type_detail"];
        if([bind_third_login_type_detail count]>0 && [[bind_third_login_type_detail allKeys] containsObject:@"6"]){
            //包含邮箱登录信息
            emailAccount = bind_third_login_type_detail[@"6"];
            [user setObject:emailAccount forKey:@"emailAccount"];
        }
        
        BOOL isHave = NO;
        if ([publicMath isBlankString:emailAccount]&&[result[@"data"][@"third_login_type"] intValue] == 6) {
            //邮箱登录
            NSArray *saveArr = [user objectForKey:@"saveEmailArr"];
            NSMutableArray *saveEmailArr = [NSMutableArray arrayWithArray:saveArr];
            if(saveEmailArr.count > 0){
                for (NSDictionary *saveDic in saveArr) {
                    SwitchUserModel *sUserMoedl = [[SwitchUserModel alloc] initWithShowInfor:saveDic];
                    if ([sUserMoedl.emailStr isEqualToString:emailAccount]) {
                        isHave = YES;
                        [saveEmailArr removeObject:saveDic];
                        NSDictionary *dic = @{
                            @"emailStr":sUserMoedl.emailStr
                        };
                        [saveEmailArr addObject:dic];
                    }
                }
            }
            
            if (isHave==NO) {
                NSDictionary *dic = @{
                    @"emailStr":emailAccount
                };
                [saveEmailArr addObject:dic];
            }

            saveArr = [[saveEmailArr reverseObjectEnumerator] allObjects];
            [user setObject:saveArr forKey:@"saveEmailArr"];
        }
        
        [user synchronize];
        
        int isNew = [result[@"data"][@"isNew"] intValue];
        UIViewController *topVC = [MCOOSSDKCenter currentViewController];
        if (isNew == 1 ) {
            //新用户  开启新进度页面
            [topVC dismissViewControllerAnimated:NO completion:^{
                BindAccountTipVC *tipVC = [[BindAccountTipVC alloc] init];
                tipVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                tipVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                UIViewController *newTopVC = [MCOOSSDKCenter currentViewController];
                [newTopVC presentViewController:tipVC animated:NO completion:nil];
            }];
        }else{
            [topVC dismissViewControllerAnimated:NO completion:nil];
        }
        
        BOOL isOldAccount = NO;
        if (isChange) {
            //切换账号
            //判断是否还是原来的账号
            if ([oldUUID isEqualToString:uuid]) {
                //之前的账号
                isOldAccount = YES;
            }
        }
        
        NSDictionary *backInfo = @{
            @"isOldAccount":@(isOldAccount)
        };
        
        [hud hideAnimated:YES];
        
        MCOUserModel *userModel = [[MCOUserModel alloc] initWithShowInfor:result[@"data"]];
        //登录成功通知
        if(isChange){
            //切换
            if (isOldAccount) {
                //老账号
            }else{
                //新账号
                userModel.sdk_op_type = @"2";
                [[MCOOSSDKCenter MCOShareSDK] loginSuccess:userModel loginState:MCOSDKLoginSuccess];
            }
        }else{
            //1.登陆
            userModel.sdk_op_type = @"1";
            [[MCOOSSDKCenter MCOShareSDK] loginSuccess:userModel loginState:MCOSDKLoginSuccess];
        }
        
        
        NSNotification *notification =[NSNotification notificationWithName:@"bindThirdLoginSuc" object:nil userInfo:backInfo];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        
    } serverErrorBlock:^(id result) {
        MCOLog(@"第三方登录失败，result = %@",result);
        [hud hideAnimated:YES];
        UIViewController *topVC = [MCOOSSDKCenter currentViewController];
        
        if ([result[@"error"] intValue] == 5) {
            [publicMath MCOHub:[publicMath getLocalString:@"enterCorrectPassword"] messageView:topVC.view];
            return;
        }
        
        if ([result[@"error"] intValue] == 11) {
            //密码输入错误次数过多
            [publicMath MCOHub:[publicMath getLocalString:@"passwordLimit"] messageView:topVC.view];
            return;
        }
        
        if ([result[@"error"] intValue] == 12) {
            //验证码过期
            [publicMath MCOHub:[publicMath getLocalString:@"codeInvalid"] messageView:topVC.view];
            return;
        }
        
        if(isChange == NO){
            //第三方token登录
            int third_login_type = [[user objectForKey:@"third_login_type"] intValue];
            if(third_login_type == 1){
                //google
                [publicMath MCOHub:[publicMath getLocalString:@"googleLoginTip"] messageView:topVC.view];
            }else if (third_login_type == 2){
                //facebook facebookLoginTip
                [publicMath MCOHub:[publicMath getLocalString:@"facebookLoginTip"] messageView:topVC.view];
            }else if(third_login_type == 3){
                //苹果
                [publicMath MCOHub:[publicMath getLocalString:@"appleLoginTip"] messageView:topVC.view];
            }else if(third_login_type == 6){
                //邮箱登录
                [publicMath MCOHub:[publicMath getLocalString:@"emailLoginTip"] messageView:topVC.view];
            }else{
                [publicMath MCOHub:@"login error" messageView:topVC.view];
            }
        }else{
            //切换用户
            int third_login_type = [dic[@"type"] intValue];
            if(third_login_type == 1){
                //google
                [publicMath MCOHub:[publicMath getLocalString:@"googleChangeAccountFail"] messageView:topVC.view];
            }else if (third_login_type == 2){
                //facebook facebookLoginTip
                [publicMath MCOHub:[publicMath getLocalString:@"facebookChangeAccountFail"] messageView:topVC.view];
            }else if(third_login_type == 3){
                //苹果
                [publicMath MCOHub:[publicMath getLocalString:@"appleChangeAccountFail"] messageView:topVC.view];
            }else if(third_login_type == 6){
                //邮箱登录
                [publicMath MCOHub:[publicMath getLocalString:@"emailChangeAccountFail"] messageView:topVC.view];
            }else{
                [publicMath MCOHub:@"Change account error" messageView:topVC.view];
            }
        }
        
        
    } failBlock:^{
        MCOLog(@"第三方登录失败");
        [hud hideAnimated:YES];
        UIViewController *topVC = [MCOOSSDKCenter currentViewController];
        [publicMath MCOHub:[publicMath getLocalString:@"netError"] messageView:topVC.view];
    }];
}

+(void)reportTokenLogin:(NSString *)userName{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = @{
        @"uuid":[user objectForKey:@"uuid"],
        @"token":[user objectForKey:@"token"],
    };
    
    [HttpRequest POSTRequestWithUrlString:MCO_Login_Token isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
        MCOLog(@"token登陆成功,result = %@",result[@"data"]);
        NSMutableArray *bind_third_login_type = result[@"data"][@"bind_third_login_type"];
        NSString *displayName = result[@"data"][@"displayName"];
        NSString *token = result[@"data"][@"token"];
        NSString *uuid = result[@"data"][@"uuid"];
        NSString *third_login_type = result[@"data"][@"third_login_type"];
        NSString *third_identifier = result[@"data"][@"third_identifier"];
        
        [user setObject:bind_third_login_type forKey:@"bind_third_login_type"];
        [user setObject:displayName forKey:@"displayName"];
        [user setObject:token forKey:@"token"];
        [user setObject:uuid forKey:@"uuid"];
        [user setObject:third_login_type forKey:@"third_login_type"];
        [user setObject:third_identifier forKey:@"third_identifier"];
        
        NSString *emailAccount;
        NSDictionary *bind_third_login_type_detail = result[@"data"][@"bind_third_login_type_detail"];
        if([bind_third_login_type_detail count]>0 && [[bind_third_login_type_detail allKeys] containsObject:@"6"]){
            //包含邮箱登录信息
            emailAccount = bind_third_login_type_detail[@"6"];
            [user setObject:emailAccount forKey:@"emailAccount"];
        }
        
        BOOL isHave = NO;
        if ([publicMath isBlankString:emailAccount]&&[result[@"data"][@"third_login_type"] intValue] == 6) {
            //邮箱登录
            NSArray *saveArr = [user objectForKey:@"saveEmailArr"];
            NSMutableArray *saveEmailArr = [NSMutableArray arrayWithArray:saveArr];
            if(saveEmailArr.count > 0){
                for (NSDictionary *saveDic in saveArr) {
                    SwitchUserModel *sUserMoedl = [[SwitchUserModel alloc] initWithShowInfor:saveDic];
                    if ([sUserMoedl.emailStr isEqualToString:emailAccount]) {
                        isHave = YES;
                        [saveEmailArr removeObject:saveDic];
                        NSDictionary *dic = @{
                            @"emailStr":sUserMoedl.emailStr
                        };
                        [saveEmailArr addObject:dic];
                    }
                }
            }
            
            if (isHave==NO) {
                NSDictionary *dic = @{
                    @"emailStr":emailAccount
                };
                [saveEmailArr addObject:dic];
            }

            saveArr = [[saveEmailArr reverseObjectEnumerator] allObjects];
            [user setObject:saveArr forKey:@"saveEmailArr"];
        }
        
        [user synchronize];
        
        MCOUserModel *userModel = [[MCOUserModel alloc] initWithShowInfor:result[@"data"]];
        //登录成功通知
        userModel.sdk_op_type = @"1";
        [[MCOOSSDKCenter MCOShareSDK] loginSuccess:userModel loginState:MCOSDKLoginSuccess];
        
//        [MBProgressHUD hideHUDForView:[MCOOSSDKCenter currentViewController].view animated:NO];
        
    } serverErrorBlock:^(id result) {
        MCOLog(@"token登陆失败  result = %@",result);
        
//        if ([result[@"error"] intValue] == 2) {
//            //请求过期
//            int third_login_type = [[user objectForKey:@"third_login_type"] intValue];
//            if(third_login_type == 0 ){
//                //游客登录
//                [[MCOOSSDKCenter MCOShareSDK] touristLogin:userName];
//            }else{
//                [[MCOOSSDKCenter MCOShareSDK] oneKeyLogin:third_login_type];
//            }
//        }else{
////            UIViewController *topVC = [MCOOSSDKCenter currentViewController];
////            [publicMath MCOHub:result[@"msg"] messageView:topVC.view];
//            [[MCOOSSDKCenter MCOShareSDK] touristLogin:userName];
//        }
        
        [[MCOOSSDKCenter MCOShareSDK] touristLogin:userName];
        
    } failBlock:^{
        MCOLog(@"token登陆失败");
        
        UIViewController *topVC = [MCOOSSDKCenter currentViewController];
        
        int third_login_type = [[user objectForKey:@"third_login_type"] intValue];
        if(third_login_type == 1){
            //google
            [publicMath MCOHub:[publicMath getLocalString:@"googleLoginTip"] messageView:topVC.view];
        }else if (third_login_type == 2){
            //facebook facebookLoginTip
            [publicMath MCOHub:[publicMath getLocalString:@"facebookLoginTip"] messageView:topVC.view];
        }else if(third_login_type == 3){
            //苹果
            [publicMath MCOHub:[publicMath getLocalString:@"appleLoginTip"] messageView:topVC.view];
        }else if(third_login_type == 6){
            //邮箱登录
            [publicMath MCOHub:[publicMath getLocalString:@"emailLoginTip"] messageView:topVC.view];
        }else{
            [publicMath MCOHub:@"Login error" messageView:topVC.view];
        }
        
        [[MCOOSSDKCenter MCOShareSDK] touristLogin:userName];
    }];
}

//绑定第三方账号上报
+(void)reportBindThirdLogin:(NSDictionary *)dic hud:(MBProgressHUD *)hud{
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[MCOOSSDKCenter currentViewController].view animated:YES];
//    hud.mode = MBProgressHUDModeIndeterminate;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [user objectForKey:@"uuid"];
    NSString *token = [user objectForKey:@"token"];
    NSMutableDictionary *dicBind = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dicBind setObject:uuid forKey:@"uuid"];
    [dicBind setObject:token forKey:@"token"];
    [HttpRequest POSTRequestWithUrlString:MCO_Login_BindThirdAccount isPay:NO headerDic:nil parameters:dicBind successBlock:^(id result) {
        MCOLog(@"绑定第三方账号成功,result = %@",result);
        [user setObject:result[@"data"][@"uuid"] forKey:@"uuid"];
        [user setObject:result[@"data"][@"token"] forKey:@"token"];
        [user setObject:result[@"data"][@"showName"] forKey:@"showName"];
        [user setObject:result[@"data"][@"displayName"] forKey:@"displayName"];
        [user setObject:result[@"data"][@"third_login_type"] forKey:@"third_login_type"];
        [user setObject:result[@"data"][@"bind_third_login_type"] forKey:@"bind_third_login_type"];
        [user setObject:result[@"data"][@"third_identifier"] forKey:@"third_identifier"];
        NSDictionary *bind_third_login_type_detail = result[@"data"][@"bind_third_login_type_detail"];
        
        NSString *emailAccount;
        
        if([bind_third_login_type_detail count]>0 && [[bind_third_login_type_detail allKeys] containsObject:@"6"]){
            //包含邮箱登录信息
            emailAccount = bind_third_login_type_detail[@"6"];
            [user setObject:emailAccount forKey:@"emailAccount"];
        }
        
        BOOL isHave = NO;
        if ([publicMath isBlankString:emailAccount]&&[result[@"data"][@"third_login_type"] intValue] == 6) {
            //邮箱登录
            NSArray *saveArr = [user objectForKey:@"saveEmailArr"];
            NSMutableArray *saveEmailArr = [NSMutableArray arrayWithArray:saveArr];
            if(saveEmailArr.count > 0){
                for (NSDictionary *saveDic in saveArr) {
                    SwitchUserModel *sUserMoedl = [[SwitchUserModel alloc] initWithShowInfor:saveDic];
                    if ([sUserMoedl.emailStr isEqualToString:emailAccount]) {
                        isHave = YES;
                        [saveEmailArr removeObject:saveDic];
                        NSDictionary *dic = @{
                            @"emailStr":sUserMoedl.emailStr
                        };
                        [saveEmailArr addObject:dic];
                    }
                }
            }
            
            if (isHave==NO) {
                NSDictionary *dic = @{
                    @"emailStr":emailAccount
                };
                [saveEmailArr addObject:dic];
            }

            saveArr = [[saveEmailArr reverseObjectEnumerator] allObjects];
            [user setObject:saveArr forKey:@"saveEmailArr"];
        }
        
        [user synchronize];
        
        MCOUserModel *userModel = [[MCOUserModel alloc] initWithShowInfor:result[@"data"]];
        //登录成功通知
        userModel.sdk_op_type = @"3";
        [[MCOOSSDKCenter MCOShareSDK] loginSuccess:userModel loginState:MCOSDKLoginSuccess];
        
        [hud hideAnimated:YES];
        
        NSNotification *notification =[NSNotification notificationWithName:@"bindSuc" object:nil userInfo:nil];
        NSNotification *notification2 =[NSNotification notificationWithName:@"bindThirdLoginSuc" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [[NSNotificationCenter defaultCenter] postNotification:notification2];
        
    } serverErrorBlock:^(id result) {
        MCOLog(@"绑定第三方账号失败, reuslt = %@",result);
        
        [[MCOOSSDKCenter MCOShareSDK] loginSuccess:nil loginState:MCOSDKLoginFailure];
        
        [hud hideAnimated:YES];
        
        UIViewController *topVC = [MCOOSSDKCenter currentViewController];
        
        if ([result[@"error"] intValue] == 5) {
            [publicMath MCOHub:[publicMath getLocalString:@"enterCorrectPassword"] messageView:topVC.view];
            return;
        }
        
        if ([result[@"error"] intValue] == 11) {
            //密码输入错误次数过多
            [publicMath MCOHub:[publicMath getLocalString:@"passwordLimit"] messageView:topVC.view];
            return;
        }
        
        if ([result[@"error"] intValue] == 12) {
            //验证码过期
            [publicMath MCOHub:[publicMath getLocalString:@"codeInvalid"] messageView:topVC.view];
            return;
        }
        
        int third_login_type = [dic[@"bind_type"] intValue];
        if([result[@"error"] intValue] == 10){
            //已经绑定过了
            if(third_login_type == 1){
                //google
                [publicMath MCOHub:[publicMath getLocalString:@"bindGoogleAccountFail"] messageView:topVC.view];
            }else if (third_login_type == 2){
                //facebook facebookLoginTip
                [publicMath MCOHub:[publicMath getLocalString:@"bindFacebookAccountFail"] messageView:topVC.view];
            }else if(third_login_type == 3){
                //苹果
                [publicMath MCOHub:[publicMath getLocalString:@"bindAppleAccountFail"] messageView:topVC.view];
            }else if(third_login_type == 6){
                //邮箱
                [publicMath MCOHub:[publicMath getLocalString:@"bindEmailAccountFail"] messageView:topVC.view];
            }else{
                //
                [publicMath MCOHub:result[@"msg"] messageView:topVC.view];
            }
        }else{
            if(third_login_type == 1){
                //google
                [publicMath MCOHub:[publicMath getLocalString:@"googleBindTip"] messageView:topVC.view];
            }else if (third_login_type == 2){
                //facebook facebookLoginTip
                [publicMath MCOHub:[publicMath getLocalString:@"facebookBindTip"] messageView:topVC.view];
            }else if(third_login_type == 3){
                //苹果
                [publicMath MCOHub:[publicMath getLocalString:@"appleBindTip"] messageView:topVC.view];
            }else if(third_login_type == 6){
                //邮箱
                [publicMath MCOHub:[publicMath getLocalString:@"emailBindTip"] messageView:topVC.view];
            }else{
                //
                [publicMath MCOHub:result[@"msg"] messageView:topVC.view];
            }
        }
        
    } failBlock:^{
        MCOLog(@"绑定第三方账号失败");
        
        [[MCOOSSDKCenter MCOShareSDK] loginSuccess:nil loginState:MCOSDKLoginFailure];
        
        [hud hideAnimated:YES];
        
        UIViewController *topVC = [MCOOSSDKCenter currentViewController];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        int third_login_type = [[user objectForKey:@"third_login_type"] intValue];
        if(third_login_type == 1){
            //google
            [publicMath MCOHub:[publicMath getLocalString:@"googleBindTip"] messageView:topVC.view];
        }else if (third_login_type == 2){
            //facebook facebookLoginTip
            [publicMath MCOHub:[publicMath getLocalString:@"facebookBindTip"] messageView:topVC.view];
        }else if(third_login_type == 3){
            //苹果
            [publicMath MCOHub:[publicMath getLocalString:@"appleBindTip"] messageView:topVC.view];
        }else if(third_login_type == 6){
            //邮箱
            [publicMath MCOHub:[publicMath getLocalString:@"emailBindTip"] messageView:topVC.view];
        }else{
            //
            [publicMath MCOHub:@"bind error" messageView:topVC.view];
        }
        
    }];
}
@end
