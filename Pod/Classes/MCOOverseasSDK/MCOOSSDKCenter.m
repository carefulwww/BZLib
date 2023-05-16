//
//  MCOOSSDKCenter.m
//  MCOOverseasProject
//

#import "MCOOSSDKCenter.h"
#import <UserNotifications/UserNotifications.h>


@implementation MCOOSSDKCenter

+(instancetype)MCOShareSDK{
    static MCOOSSDKCenter *sdk = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sdk = [[MCOOSSDKCenter alloc]init];
    });
    return sdk;
}

//uuid
-(NSString *)saveUUID{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"uuid"]?[user objectForKey:@"uuid"]:@"";
}

//token
-(NSString *)saveToken{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"token"]?[user objectForKey:@"token"]:@"";
}

-(NSString *)saveAppKey{
    return [publicMath isBlankString:self.appKey]?self.appKey:@"";
}

//获取userName
-(NSString *)saveUserName{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:@"showName"]?[user objectForKey:@"showName"]:@"";
}

//init
-(void)initSDKSetting:(NSString *)urlString
               sdkKey:(NSString *)SDKKey
               gameId:(NSString *)gameId
               payKey:(NSString *)payKey
            APPScheme:(NSString *)AppScheme
              channel:(NSString *)channel
                appId:(NSString *)appId
         googleClient:(NSString *)googleClient
           appleAppID:(NSString *)appleAppID
         plugClientId:(NSString *)plugClientId
           plugSecret:(NSString *)plugSecret
             loungeId:(NSString *)loungeId{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    //判断url是否为空,若为空则不执行下列代码，并在控制台输出提示
    if([publicMath isBlankString:urlString]){
        self.mcoBaseUrl = urlString;
    }else{
        MCOLog(@"域名不可为空");
        return;
    }
    
    
    if ([publicMath isBlankString:SDKKey]&&[publicMath isBlankString:gameId]&&[publicMath isBlankString:payKey]&&[publicMath isBlankString:AppScheme]) {
        
        self.sdkKey = SDKKey;
        self.gameId = gameId;
        self.payKey = payKey;
        self.appScheme = AppScheme;
        self.channel = channel;
        self.appId = appId;
        
        //开始支付监听
        self.applePay = [[MCOApplePay MCOSharedApplePay] init];
        
        //判断是否首次激活
        if(![user boolForKey:@"isFirst"]){
            MCOLog(@"第一次激活");
            [self firstActive:user];
        }
    
        if([publicMath isBlankString:[NSString stringWithFormat:@"%@",googleClient]]){
            [GIDSignIn sharedInstance].clientID = googleClient;
            self.googleClient = [NSString stringWithFormat:@"%@",googleClient];
        }
        
        if ([publicMath isBlankString:[NSString stringWithFormat:@"%@",appleAppID]]) {
            self.appleAppID = [NSString stringWithFormat:@"%@",appleAppID];
        }
        
        if ([publicMath isBlankString:[NSString stringWithFormat:@"%@",loungeId]]) {
            self.loungeId = [NSString stringWithFormat:@"%@",loungeId];
        }
        
        /**
         naver社区
         */
        if([publicMath isBlankString:[NSString stringWithFormat:@"%@",plugClientId]]){
            self.plugClientId = plugClientId;
        }
        
        if([publicMath isBlankString:[NSString stringWithFormat:@"%@",plugSecret]]){
            self.plugSecret = plugSecret;
        }
        
        if ([publicMath isBlankString:[NSString stringWithFormat:@"%@",loungeId]]) {
            self.loungeId = loungeId;
        }
        
    }else{
        MCOLog(@"配置参数不能为空");
        return;
    }
    
    NSString *localeLanguageCode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] firstObject] ;
    //判断语言
    if ([localeLanguageCode containsString:@"zh-Hans"]) {
        //中文简体
        self.language = @"CN";
    }else if([localeLanguageCode containsString:@"zh-Hant"]||[localeLanguageCode containsString:@"zh-HK"]){
        //中文繁体
        self.language = @"FT";
    }else if([localeLanguageCode containsString:@"ja"]||[localeLanguageCode containsString:@"ko"]){
        NSArray *languageArr = [localeLanguageCode componentsSeparatedByString:@"-"];
        if (languageArr.count > 0) {
            self.language = languageArr[0];
        }
    }else{
        self.language = @"EN";
    }
    
    [self getCurrentTime];
    
    [HttpRequest POSTRequestWithUrlString:MCO_SDKSetting isPay:NO headerDic:nil parameters:nil successBlock:^(id result) {
        MCOLog(@"初始化成功----result:%@",result);
        
        self.isInitSuc = YES;
        
        //第三方登录
        NSMutableArray *thirdLoginArr = [NSMutableArray array];
        for (NSDictionary *dic in result[@"data"][@"game_other_cfg"][@"third_login"]) {
            int open = [dic[@"open"] intValue];
            if (open == 1) {
                [thirdLoginArr addObject:dic];
            }
        }
        [user setObject:thirdLoginArr forKey:@"third_login"];
        int user_policy_open = [result[@"data"][@"game_other_cfg"][@"user_policy_open"] intValue];
        [user setInteger:user_policy_open forKey:@"user_policy_open"];
        [user setValue:result[@"data"][@"game_other_cfg"][@"delete_user_policy"] forKey:@"delete_user_policy"];
        
        //判断公司主体
        NSInteger company_entity = [result[@"data"][@"game_cfg"][@"company_entity"] integerValue];
        [user setInteger:company_entity forKey:@"company_entity"];
        self.company_entity = company_entity;
        
        //社区
        NSMutableArray *communityArr = [NSMutableArray array];
        for (NSDictionary *dic in result[@"data"][@"game_community"]) {
            int open = [dic[@"open"] intValue];
            if (open == 1) {
                [communityArr addObject:dic];
            }
        }
        [user setObject:communityArr forKey:@"game_community"];
        
        
        //商品
        for (NSDictionary *dic in result[@"data"][@"game_product"]) {
            GameProductModel *model = [[GameProductModel alloc] initWithShowInfor:dic];
            [self.productIdArr addObject:model.product_id];
            [self.gameProductArr addObject:model];
        }
        
        [user setObject:self.productIdArr forKey:@"productIds"];
        
        //是否开启滑块检测
        [user setValue:result[@"data"][@"game_other_cfg"][@"pic_code_open"] forKey:@"pic_code_open"];//1:开启,2:关闭
        if (result[@"data"][@"game_other_cfg"][@"pic_code_open"]) {
            self.pic_code_open = [result[@"data"][@"game_other_cfg"][@"pic_code_open"] intValue];
            self.picVerifyUrl = result[@"data"][@"game_other_cfg"][@"pic_verify_url"];
            self.pic_platform_id = [result[@"data"][@"game_other_cfg"][@"pic_platform_id"] intValue];
        }else{
            self.pic_code_open = 2;
        }
        
        NSString *originalPolicyUrl = result[@"data"][@"game_other_cfg"][@"user_policy"];
        if ([publicMath isBlankString:originalPolicyUrl]) {
            //
            NSArray *policyUrlArr = [originalPolicyUrl componentsSeparatedByString:@".html"];
            NSString *policy;
            if (policyUrlArr.count > 1) {
                if ([publicMath isBlankString:self.language]) {
                    
                    policy = [NSString stringWithFormat:@"%@/%@%@",policyUrlArr[0],[self.language uppercaseString] ,@".html"];
                }else{
                    
                    policy = [NSString stringWithFormat:@"%@%@",policyUrlArr[0],@".html"];
                }
                
            }
            [user setValue:policy forKey:@"user_policy"];
        }
        
        NSString *originalDeleteUrl = result[@"data"][@"game_other_cfg"][@"delete_user_policy"];
        if ([publicMath isBlankString:originalPolicyUrl]) {
            //
            NSArray *deleteUrlArr = [originalDeleteUrl componentsSeparatedByString:@".html"];
            NSString *policy;
            if (deleteUrlArr.count > 1) {
                if ([publicMath isBlankString:self.language]) {
                    policy = [NSString stringWithFormat:@"%@/%@%@",deleteUrlArr[0],[self.language uppercaseString] ,@".html"];
                }else{
                    policy = [NSString stringWithFormat:@"%@%@",deleteUrlArr[0],@".html"];
                }
            }
            [user setValue:policy forKey:@"delete_user_policy"];
        }
        
        /**
          预约功能
         */
        if (result[@"data"][@"yuyue_game_product"][@"product_id"]) {
            self.bookingProductID = result[@"data"][@"yuyue_game_product"][@"product_id"];
        }
        
        [user setValue:result[@"data"][@"game_other_cfg"][@"user_policy_open"] forKey:@"user_policy_open"];
                                 
        //判断是否ironsource是否返回
        if(result[@"data"][@"game_other_cfg"][@"ironsource_server_callback_open"]!=nil && [result[@"data"][@"game_other_cfg"][@"ironsource_server_callback_open"] intValue] == 1){
            //开启
            self.ironsource_server_callback_open = YES;
        }else{
            self.ironsource_server_callback_open = NO;
        }
    
        if (user_policy_open == 1) {
            int isOpenPolicy = [[user objectForKey:@"isOpenPolicy"] intValue];
            [user synchronize];
            if (isOpenPolicy == 1) {
                //已经打开过
//                [self login];
                [self initSuccess:result[@"data"]];
            }else{
                //打开协议
                MCOClause *clause = [[MCOClause alloc] init];
                clause.dic = result[@"data"];
                clause.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                clause.modalPresentationStyle = UIModalPresentationOverFullScreen;
                UIViewController *newTopVC = [MCOOSSDKCenter currentViewController];
                [newTopVC presentViewController:clause animated:NO completion:nil];
                [self clauseBack];
            }
        }else{
            [self initSuccess:result[@"data"]];
            [user synchronize];
        }
        
    } serverErrorBlock:^(id result) {
        
        MCOLog(@"--------请求配置信息错误+++++++++++++-------:%@--------------",result);
        
        if (self.initTryNum < 15 && self.isInitSuc==NO) {
            //init重试次数小于3
            self.initTryNum += 1;
            [self initSDKSetting:urlString
                          sdkKey:SDKKey
                          gameId:gameId
                          payKey:payKey
                       APPScheme:AppScheme
                         channel:channel
                           appId:appId
                    googleClient:googleClient
                      appleAppID:appleAppID
                    plugClientId:plugClientId
                      plugSecret:plugSecret
                      loungeId:loungeId];
        }
        
    } failBlock:^{
        
        MCOLog(@"--------=====z=======-------");
        
        if (self.initTryNum < 15 && self.isInitSuc==NO) {
            //init重试次数小于3
            self.initTryNum += 1;
            [self initSDKSetting:urlString
                          sdkKey:SDKKey
                          gameId:gameId
                          payKey:payKey
                       APPScheme:AppScheme
                         channel:channel
                           appId:appId
                    googleClient:googleClient
                      appleAppID:appleAppID
                    plugClientId:plugClientId
                      plugSecret:plugSecret
                      loungeId:loungeId];
        }
        
    }];
}

-(void)firstActive:(NSUserDefaults *)user{
    
    [HttpRequest POSTRequestWithUrlString:MCO_FirstActive  isPay:NO headerDic:nil parameters:nil successBlock:^(id result) {
        MCOLog(@"--------游戏第一次激活+++++++++++++-------:%@--------------",result);
        [self firstActiveBack];
        [user setBool:YES forKey:@"isFirst"];
        [user synchronize];
    } serverErrorBlock:^(id result) {
        MCOLog(@"--------请求错误游戏第一次激活+++++++++++++-------:%@--------------",result);
        [user setBool:NO forKey:@"isFirst"];
        [user synchronize];
    } failBlock:^{
        MCOLog(@"--------=====z=======-------");
        [user setBool:NO forKey:@"isFirst"];
        [user synchronize];
    }];
    
}


/**
 一键登录
 */
-(void)oneKeyLogin:(int)appState{
    
    OnekeyLoginVC *loginVC = [[OnekeyLoginVC alloc] init];
    loginVC.appState = appState;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    nav.navigationBar.hidden = YES;
    nav.interactivePopGestureRecognizer.enabled = NO;
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nav.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIViewController *topVC = [MCOOSSDKCenter currentViewController];
    [topVC presentViewController:nav animated:NO completion:nil];
}

/**
 游客登陆
 */
-(void)touristLogin:(NSString *)userName{
    NSDictionary *dic = @{
        @"device_id":userName,
    };
    [HttpRequest POSTRequestWithUrlString:MCO_Login_StandAlone isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
        MCOLog(@"游客登陆成功,result = %@",result);
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        NSMutableArray *bind_third_login_type = result[@"data"][@"bind_third_login_type"];
        NSString *displayName = result[@"data"][@"displayName"];
        NSString *token = result[@"data"][@"token"];
        NSString *uuid = result[@"data"][@"uuid"];
        NSString *third_login_type = result[@"data"][@"third_login_type"];
        NSString *third_identifier = result[@"third_identifier"][@"third_identifier"];
        
        [user setObject:bind_third_login_type forKey:@"bind_third_login_type"];
        [user setObject:displayName forKey:@"displayName"];
        [user setObject:token forKey:@"token"];
        [user setObject:uuid forKey:@"uuid"];
        [user setObject:third_login_type forKey:@"third_login_type"];
        [user setObject:third_identifier forKey:@"third_identifier"];
        
        NSDictionary *bind_third_login_type_detail = result[@"data"][@"bind_third_login_type_detail"];
        if([bind_third_login_type_detail count]>0 && [[bind_third_login_type_detail allKeys] containsObject:@"6"]){
            //包含邮箱登录信息
            [user setObject:bind_third_login_type_detail[@"6"] forKey:@"emailAccount"];
        }
        
        [user synchronize];
        
        int isNew = [result[@"data"][@"isNew"] intValue];
        if (isNew == 1) {
            //新用户  开启新进度页面
            UIViewController *topVC = [MCOOSSDKCenter currentViewController];
            [topVC dismissViewControllerAnimated:NO completion:^{
//                MCOClause *clause = [[MCOClause alloc] init];
//                clause.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//                clause.modalPresentationStyle = UIModalPresentationOverFullScreen;
//                UIViewController *newTopVC = [MCOOSSDKCenter currentViewController];
//                [newTopVC presentViewController:clause animated:NO completion:nil];
            }];
        }
        
        MCOUserModel *userModel = [[MCOUserModel alloc] initWithShowInfor:result[@"data"]];
        //登录成功通知
        userModel.sdk_op_type = @"1";
        [[MCOOSSDKCenter MCOShareSDK] loginSuccess:userModel loginState:MCOSDKLoginSuccess];
        
    } serverErrorBlock:^(id result) {
        MCOLog(@"游客登陆失败 result = %@",result);
        UIViewController *topVC = [MCOOSSDKCenter currentViewController];
        [publicMath MCOHub:[publicMath getLocalString:@"netError"] messageView:topVC.view];
        [[MCOOSSDKCenter MCOShareSDK] loginSuccess:nil loginState:MCOSDKLoginFailure];
    } failBlock:^{
        MCOLog(@"游客登陆失败");
        UIViewController *topVC = [MCOOSSDKCenter currentViewController];
        [publicMath MCOHub:[publicMath getLocalString:@"netError"] messageView:topVC.view];
        [[MCOOSSDKCenter MCOShareSDK] loginSuccess:nil loginState:MCOSDKLoginFailure];
    }];
}

//-(void)tokenLogin{
//    [MCOLoginManager reportTokenLogin];
//}

//登录
-(void)login{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if ([publicMath isBlankString:[user objectForKey:@"token"]]) {
        //有token
        [MCOLoginManager reportTokenLogin:[GetDeviceData getIDFV]];
    }else{
        //无token
        [self touristLogin:[GetDeviceData getIDFV]];
    }
}

/**
 兼容单机版登录(兼容老游戏登录)
 */
-(void)loginStandAlone:(NSString *)userName{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([publicMath isBlankString:[user objectForKey:@"token"]]) {
        //有token
        [MCOLoginManager reportTokenLogin:userName];
    }else{
        if([publicMath isBlankString:userName]){
            [self touristLogin:userName];
        }else{
            [self touristLogin:[GetDeviceData getIDFV]];
        }
    }
}

/**
 退出
 */
-(void)logout{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"token"];
    [user removeObjectForKey:@"bind_third_login_type"];
    [user removeObjectForKey:@"displayName"];
    [user removeObjectForKey:@"uuid"];
    [user removeObjectForKey:@"third_login_type"];
    [user removeObjectForKey:@"third_identifier"];
    [user synchronize];
}

/**
 个人中心
 */
-(void)personalCenter{
    
    if (self.roleId!=nil && [publicMath isBlankString:[NSString stringWithFormat:@"%@",self.roleId]]) {
        
        NSDictionary *dic = @{
            @"role_id":self.roleId,
            @"uuid":[[MCOOSSDKCenter MCOShareSDK] saveUUID]
        };
       
        [HttpRequest POSTRequestWithUrlString:MCO_Survey_Open isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
            MCOLog(@"用户开启问卷 result = %@",result);
            PersonalCenterVC *personalCenterVC = [[PersonalCenterVC alloc] init];
//            personalCenterVC.roleId = self.roleId;
            personalCenterVC.isShowSurvey = YES;
            personalCenterVC.company_entity = self.company_entity;
            personalCenterVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            UIViewController *topVC = [MCOOSSDKCenter currentViewController];
            [topVC presentViewController:personalCenterVC animated:NO completion:nil];
        } serverErrorBlock:^(id result) {
            MCOLog(@"用户不开启问卷 result = %@",result);
            PersonalCenterVC *personalCenterVC = [[PersonalCenterVC alloc] init];
            personalCenterVC.company_entity = self.company_entity;
            personalCenterVC.isShowSurvey = NO;
            personalCenterVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            UIViewController *topVC = [MCOOSSDKCenter currentViewController];
            [topVC presentViewController:personalCenterVC animated:NO completion:nil];
        } failBlock:^{
            MCOLog(@"--------服务器错误----------");
            PersonalCenterVC *personalCenterVC = [[PersonalCenterVC alloc] init];
            personalCenterVC.company_entity = self.company_entity;
            personalCenterVC.isShowSurvey = NO;
            personalCenterVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            UIViewController *topVC = [MCOOSSDKCenter currentViewController];
            [topVC presentViewController:personalCenterVC animated:NO completion:nil];
        }];
        
    }else{
        MCOLog(@"roleId不可以为空");
        PersonalCenterVC *personalCenterVC = [[PersonalCenterVC alloc] init];
        personalCenterVC.company_entity = self.company_entity;
        personalCenterVC.isShowSurvey = NO;
        personalCenterVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        UIViewController *topVC = [MCOOSSDKCenter currentViewController];
        [topVC presentViewController:personalCenterVC animated:NO completion:nil];
    }
    
}

//登录成功
-(void)loginSuccess:(MCOUserModel *)userInfo loginState:(MCOSDKLoginState)state{
    MCOLog(@"------用户信息-----：uuid = %@,token=%@,showName=%@",userInfo.uuid,userInfo.token,userInfo.showName);
    if (state == MCOSDKLoginSuccess) {
        
        if([userInfo.isSuspend intValue] == 1){
            //封号
            MCOSuspendVC *suspendVC = [[MCOSuspendVC alloc] init];
            suspendVC.reason = userInfo.suspendReason;
            suspendVC.suspendTime = userInfo.suspendTime;
            suspendVC.note = userInfo.note;
            suspendVC.userId = userInfo.displayName;
            suspendVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            suspendVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            UIViewController *topVC = [MCOOSSDKCenter currentViewController];
            [topVC presentViewController:suspendVC animated:NO completion:nil];
        }
        
        NSString *displayName = userInfo.displayName;
        NSString *topName;
        int third_login_type = [userInfo.third_login_type intValue];
        if (third_login_type == 0) {
            //游客账号：MVFN
            topName = [NSString stringWithFormat:@"%@：%@",@"MVFN",displayName];
        }else if(third_login_type == 1){
            //谷歌：GOGL;
            topName = [NSString stringWithFormat:@"%@：%@",@"GOGL",displayName];
        }else if(third_login_type == 2){
            //Facebook:FCBK
            topName = [NSString stringWithFormat:@"%@：%@",@"FCBK",displayName];
        }else if (third_login_type == 3){
            //苹果账号：APGC
            topName = [NSString stringWithFormat:@"%@：%@",@"APFC",displayName];
        }else if(third_login_type == 6){
            //邮箱登录
            topName = [NSString stringWithFormat:@"Email：%@",displayName];
        }else{
            topName = @"null";
        }
        
        if([userInfo.sdk_op_type intValue] ==2 ){
            //切换
            MCOLog(@"切换用户 role 置为空");
            self.roleId = @"";
        }
        
        if ([userInfo.sdk_op_type intValue] == 3) {
            //绑定不弹出弹窗
            
        }else{
            [self topAlert:topName];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccess:loginState:)]) {
            MCOLog(@"loginSuccess");
            [self.delegate loginSuccess:userInfo loginState:state];
        }
    }
}

-(void)topAlert:(NSString *)content{
    
    [TopAlertView SetUpbackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8] andStayTime:3 andTitleStr:content andTitleColor:[UIColor whiteColor]];
}


/**
 购买
 */
-(void)payInfo:(PayOrderModel *)order{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *userName = [user objectForKey:@"showName"];
    NSString *userName = [GetDeviceData getIDFV];
    MCOLog(@"payInfo order = %@ userName = %@",order,userName);
    //
    order.user_name = userName;
    order.token = [user valueForKey:@"token"];
    
    NSString *payTip = [publicMath getLocalString:@"payTip"];
    
    [KVNProgress showWithParameters:@{
        KVNProgressViewParameterStatus: payTip,
    KVNProgressViewParameterBackgroundType:@(KVNProgressBackgroundTypeSolid),
        KVNProgressViewParameterFullScreen: @(YES),
        KVNProgressViewParameterSuperview:[MCOOSSDKCenter currentViewController].view
    }];
    
    //成年人
    [self payOrder:order userName:userName];

}

-(void)payOrder:(PayOrderModel *)order userName:(NSString *)userName{
    [HttpRequest POSTRequestWithUrlString:MCO_CreatedOrder isPay:YES headerDic:nil parameters:[order payOrderParameters] successBlock:^(id result) {
        MCOLog(@"--------生成订单成功---------：%@ ------",result[@"data"]);
        self.applePay.order_id= result[@"data"][@"order_id"];
        self.applePay.token = result[@"data"][@"order_token"];
        self.applePay.payOrder.user_name = userName;
        order.sdkOrderID = result[@"data"][@"order_id"];
        [self.applePay applePay:order];
        [self createOrderBack:order];
    } serverErrorBlock:^(id result) {
        MCOLog(@"--------生成订单失败----%@-----：%@ ------",result[@"error"],result[@"msg"]);
        [self paySuccess:@"生成订单失败" payState:MCOSDKPayInfoLess gameOrderId:order.extra];
    } failBlock:^{
        MCOLog(@"--------服务器错误----------");
        [self paySuccess:@"无网络" payState:MCOSDKPayFailure gameOrderId:order.extra];
    }];
}

//商城评价
-(void)storeReview:(NSString *)reason{
    if (@available(iOS 10.3, *)) {
        
        [SKStoreReviewController requestReview];
        
    } else {

        if (![publicMath isBlankString:self.appleAppID]) {
            MCOLog(@"苹果ID为空，不可进行社区评论");
            return;
        }
        
        NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", self.appleAppID];

        NSURL *url = [NSURL URLWithString:urlString];

        if ([[UIApplication sharedApplication] canOpenURL:url]) {

            if (@available(iOS 10.0, *)) {

                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];

            } else {

                [[UIApplication sharedApplication] openURL:url];

            }
            
        }
        
    }
    
    [self storeReviewBack:[NSString stringWithFormat:@"%@",reason]];
}


//存放商品信息
-(NSMutableArray *)gameProductArr{
    if (!_gameProductArr) {
        self.gameProductArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _gameProductArr;
}


//存放商品ID信息
-(NSMutableArray *)productIdArr{
    if (!_productIdArr) {
        self.productIdArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _productIdArr;
}

//恢复购买
-(void)restoreTransactions:(NSDictionary *)restoreDic{
    NSString *restoreTip = [publicMath getLocalString:@"restoreTip"];
    [KVNProgress showWithParameters:@{KVNProgressViewParameterStatus:restoreTip,
                                         KVNProgressViewParameterBackgroundType:
                                             @(KVNProgressBackgroundTypeSolid),
                                      KVNProgressViewParameterFullScreen: @(YES)}];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:restoreDic forKey:@"restoreDic"];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}




-(void)getSurveys:(NSString *)roleId{
    NSDictionary *dic = @{
        @"role_id":roleId,
        @"uuid":self.saveUUID
    };
    [HttpRequest POSTRequestWithUrlString:MCO_Get_Surveys isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
        MCOLog(@"问卷成功 result = %@",result);
    } serverErrorBlock:^(id result) {
        MCOLog(@"问卷失败 result = %@",result);
    } failBlock:^{
        MCOLog(@"--------服务器错误----------");
    }];
}

-(void)initUserSurver:(NSString *)roleID serverID:(NSString *)serverID{
    [self initUserSurver:roleID serverID:serverID callbackUrl:nil];
}

//是否有问卷
-(void)initUserSurver:(NSString *)roleID serverID:(NSString *)serverID callbackUrl:(NSString *)callbackUrl{
    if (roleID!=nil && [publicMath isBlankString:[NSString stringWithFormat:@"%@",roleID]]) {
//        NSDictionary *dic = @{
//            @"role_id":roleID,
//            @"uuid":[[MCOOSSDKCenter MCOShareSDK] saveUUID],
//            @"server_id":serverID
//        };
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:roleID forKey:@"role_id"];
        [dic setObject:[[MCOOSSDKCenter MCOShareSDK] saveUUID] forKey:@"uuid"];
        [dic setObject:serverID forKey:@"server_id"];
        
        if(callbackUrl){
//            [dic setObject:callbackUrl forKey:@"callback_url"];
            self.surveyCallBackUrl = callbackUrl;
        }
        
        self.serverId = serverID;
        [HttpRequest POSTRequestWithUrlString:MCO_Survey_Open isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
            MCOLog(@"用户是否开启问卷 result = %@",result);
            self.roleId = roleID;
            self.serverId = serverID;
            if ([result[@"data"][@"is_open"] intValue] == 1) {
                //显示问卷
                [self initUserSurveySuccess];
            }else{
                [self initUserSurveyFail];
            }
        } serverErrorBlock:^(id result) {
            MCOLog(@"问卷模块开启错误：result = %@",result);
            [self initUserSurveyFail];
        } failBlock:^{
            MCOLog(@"问卷模块开启错误：服务器错误");
            [self initUserSurveyFail];
        }];
    }else{
        MCOLog(@"roleID不可以为空");
    }
}

/**
 开启问卷
 */
-(void)openUserSurvey{
    if (self.roleId!=nil && [publicMath isBlankString:[NSString stringWithFormat:@"%@",self.roleId]]) {
        
//        NSDictionary *dic = @{
//            @"role_id":self.roleId,
//            @"uuid":[[MCOOSSDKCenter MCOShareSDK] saveUUID]
//        };
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:self.roleId forKey:@"role_id"];
        [dic setValue:[[MCOOSSDKCenter MCOShareSDK] saveUUID] forKey:@"uuid"];
        
        if(self.surveyCallBackUrl){
            [dic setValue:self.surveyCallBackUrl forKey:@"callback_url"];
        }
       
        [HttpRequest POSTRequestWithUrlString:MCO_Get_Surveys isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
            MCOLog(@"问卷成功 result = %@",result);
            SurveyCenter * surveyCenter = [[SurveyCenter alloc] init];
            surveyCenter.roleId = self.roleId;
            surveyCenter.surveyArr = result[@"data"][@"survey"];
            surveyCenter.modalPresentationStyle = UIModalPresentationOverFullScreen;
            UIViewController *topVC = [MCOOSSDKCenter currentViewController];
            [topVC presentViewController:surveyCenter animated:NO completion:nil];
            
        } serverErrorBlock:^(id result) {
            MCOLog(@"问卷失败 result = %@",result);
        } failBlock:^{
            MCOLog(@"问卷模块开启错误：服务器错误");
        }];
        
    }else{
        MCOLog(@"问卷模块开启错误：roleId不可以为空");
    }
}

//切换账号
-(void)changeAccount{
    MCOLog(@"账号切换");
    ChangeAccountVC *changeAccountVC = [[ChangeAccountVC alloc] init];
    changeAccountVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    changeAccountVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UIViewController *newTopVC = [MCOOSSDKCenter currentViewController];
    [newTopVC presentViewController:changeAccountVC animated:NO completion:nil];
}

-(void)bindAccount{
    MCOLog(@"账号绑定");
    BindAccountVC *bindAccountVC = [[BindAccountVC alloc] init];
    bindAccountVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    bindAccountVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UIViewController *newTopVC = [MCOOSSDKCenter currentViewController];
    [newTopVC presentViewController:bindAccountVC animated:NO completion:nil];
}

//注销功能
-(void)cancelAccount{
    NSDictionary *dic = @{
        @"uuid":[MCOOSSDKCenter MCOShareSDK].saveUUID
    };
    [HttpRequest POSTRequestWithUrlString:MCO_Get_Cancel_Time isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
        MCOLog(@"获取账号注销时间成功，result = %@",result);
        int status = [result[@"data"][@"status"] intValue];
        if (status == 0) {
            //未注销
            CancelTreatyVC *cancelTreatyVC = [[CancelTreatyVC alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cancelTreatyVC];
            nav.navigationBar.hidden = YES;
            nav.interactivePopGestureRecognizer.enabled = NO;
            nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
            nav.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            UIViewController *topVC = [MCOOSSDKCenter currentViewController];
            [topVC presentViewController:nav animated:NO completion:nil];
            
        }else if (status == 1){
            //已注销
            int deleteUserTime = [result[@"data"][@"time"] intValue];
            if(deleteUserTime == 0){
                [publicMath closeGame];
            }
            
            CancelCountDown *countDownVC = [[CancelCountDown alloc] init];
            countDownVC.countDownTime = deleteUserTime;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:countDownVC];
            nav.navigationBar.hidden = YES;
            nav.interactivePopGestureRecognizer.enabled = NO;
            nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
            nav.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            UIViewController *topVC = [MCOOSSDKCenter currentViewController];
            [topVC presentViewController:nav animated:NO completion:nil];
        }
        
    } serverErrorBlock:^(id result) {
        MCOLog(@"获取账号注销时间失败,result = %@",result);
    } failBlock:^{
        MCOLog(@"获取账号注销剩余时间 --- 网络错误");
    }];
}


/**
 naver社区
 */
//主页横幅功能
-(void)displayBanner:(UIViewController *)mainView{
//    MCOLog(@"该版本未开启Naver社区");
    [[MCONaverCenter MCONaverShare] displayBanner:mainView];
}

//维护用横幅
-(void)displaySorry:(UIViewController *)mainView{
//    MCOLog(@"该版本未开启Naver社区");
    [[MCONaverCenter MCONaverShare] displaySorry:mainView];
}

//跳转公告栏
-(void)displayBoard:(UIViewController *)mainView boardId:(NSNumber *)boardId{
//    MCOLog(@"该版本未开启Naver社区");
    [[MCONaverCenter MCONaverShare] displayBoard:mainView boardId:boardId];
}

//恢复商品信息回调成功信息
-(void)restoreSuccess:(MCOSDKRestoreState)state restoreArray:(NSMutableArray *)restoreArray{
    
    NSMutableArray *restoreProduct = [[NSMutableArray alloc]init];
    if (self.gameProductArr!=nil && self.gameProductArr.count>0) {
        for (GameProductModel *model in self.gameProductArr) {
            if ([model.product_type isEqualToString:@"1"]||[model.product_type isEqualToString:@"4"]) {
                //如果是消耗商品或非自动续订
            }else{
                if ([restoreArray containsObject:model.product_id]) {
                    [restoreProduct addObject:model];
                }
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
    //显示弹窗信息
    dispatch_async(dispatch_get_main_queue(), ^{
        AlertVC *alter = [[AlertVC alloc] init];
        alter.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        alter.modalPresentationStyle = UIModalPresentationOverFullScreen;
        UIViewController *newTopVC = [MCOOSSDKCenter currentViewController];
        [newTopVC presentViewController:alter animated:NO completion:nil];
    });
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(restoreInfo:restoreArray:)]) {
        MCOLog(@"MCOSDKCenter delegate restoreSuccess");
        [self.delegate restoreInfo:state restoreArray:restoreProduct];
    }
    
}

//支付
-(void)paySuccess:(NSString *)pay payState:(MCOSDKPayState)state gameOrderId:(NSString *)gameOrderId{
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
    if (self.delegate && [self.delegate respondsToSelector:@selector(payInfo:payState:gameOrderId:)]) {
        [self.delegate payInfo:pay payState:state gameOrderId:gameOrderId];
    }
}

//商品信息回调
-(void)productSuccess:(NSMutableArray *)productArray{
    if (self.delegate && [self.delegate respondsToSelector:@selector(productInfo:)]) {
        [self.delegate productInfo:productArray];
    }
}

//init成功回调
-(void)initSuccess:(NSDictionary *)dic{
    
    //初始化
    if([publicMath isBlankString:[NSString stringWithFormat:@"%@",self.plugSecret]] && [publicMath isBlankString:[NSString stringWithFormat:@"%@",self.plugClientId]]&&[publicMath isBlankString:[NSString stringWithFormat:@"%@",self.loungeId]]){
        [[MCONaverCenter MCONaverShare] MCONaverInit:self.plugClientId secret:self.plugSecret loungeId:self.loungeId];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(initSuccess:)]) {
        [self.delegate initSuccess:dic];
    }
}

//首次激活回调
-(void)firstActiveBack{
    if (self.delegate && [self.delegate respondsToSelector:@selector(firstActiveBack)]) {
        [self.delegate firstActiveBack];
    }
}

//打开协议回调
-(void)clauseBack{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clauseBack)]) {
        [self.delegate clauseBack];
    }
}

//协议界面按钮点击回调
-(void)clauseClickBtnBack{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clauseClickBtnBack)]) {
        [self.delegate clauseClickBtnBack];
    }
}

//社区点击
-(void)clickCommunityBack:(NSString *)communityName{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickCommunityBack:)]) {
        [self.delegate clickCommunityBack:communityName];
    }
}

-(void)storeReviewBack:(NSString *)reason{
    if (self.delegate && [self.delegate respondsToSelector:@selector(storeReviewBack:)]) {
        [self.delegate storeReviewBack:reason];
    }
}

-(void)createOrderBack:(PayOrderModel *)orderModel{
    if (self.delegate && [self.delegate respondsToSelector:@selector(createOrderBack:)]) {
        [self.delegate createOrderBack:orderModel];
    }
}

-(void)initUserSurveySuccess{
    if (self.delegate && [self.delegate respondsToSelector:@selector(initUserSurveySuccess)]) {
        [self.delegate initUserSurveySuccess];
    }
}

-(void)initUserSurveyFail{
    if (self.delegate && [self.delegate respondsToSelector:@selector(initUserSurveyFail)]) {
        [self.delegate initUserSurveyFail];
    }
}

-(void)pushTokenBack{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pushTokenBack)]) {
        [self.delegate pushTokenBack];
    }
}

/**
 邮箱切换 navigationcontroller
 */
-(void)changeEmailAccountVC{
    MCOEmailChangeVC *emailChangeVC = [[MCOEmailChangeVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:emailChangeVC];
    nav.navigationBar.hidden = YES;
    nav.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[MCOOSSDKCenter currentViewController] presentViewController:nav animated:NO completion:nil];
}

/**
 邮箱登录 navigationcontroller
 */
-(void)loginEmailAccountVC{
    MCOEmailLoginVC *emailLoginVC = [[MCOEmailLoginVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:emailLoginVC];
    nav.navigationBar.hidden = YES;
    nav.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[MCOOSSDKCenter currentViewController] presentViewController:nav animated:NO completion:nil];
}

/**
 邮箱绑定 navigationcontroller
 */
-(void)bindEmailAccountVC{
    MCOEmailBindVC *emailBindVC = [[MCOEmailBindVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:emailBindVC];
    nav.navigationBar.hidden = YES;
    nav.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[MCOOSSDKCenter currentViewController] presentViewController:nav animated:NO completion:nil];
}

/**
 工具
 */

//获取根控制器
- (UIViewController *)appRootViewController {
 
    UIViewController *RootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = RootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
 
}
 
 

//获取当前控制器
+ (UIViewController*)currentViewController {
 
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
 
    while (1) {
    
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    
    }
 
    return vc;
 
}

-(void)getProductInfo{
    [self.applePay returnProductInfo];
}

-(void)toAlertVC{
    AlertVC *alertVC = [[AlertVC alloc] init];
    alertVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    alertVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UIViewController *newTopVC = [MCOOSSDKCenter currentViewController];
    [newTopVC presentViewController:alertVC animated:NO completion:nil];
}

//keyChain存储
-(void)saveKeychain:(NSDictionary *)data service:(NSString *)service account:(NSString *)account{
    NSData *dataTemp = [NSKeyedArchiver archivedDataWithRootObject:data];
    [MCOSAMKeychain setPasswordData:dataTemp forService:service account:account];
}

//keyChain取出
-(NSDictionary*)getKeyChainDic:(NSString *)service account:(NSString *)account{
    NSData *data = [MCOSAMKeychain passwordDataForService:service account:account];
    NSDictionary *dataDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dataDic;
}

-(void)pushToken:(NSString *)token{
    MCOLog(@"push token uuid = %@",self.saveUUID);
    if(![publicMath isBlankString:self.saveUUID]){
        return;
    }
    
    NSDictionary *dic = @{
        @"deviceToken":token,
        @"uuid":self.saveUUID,
        @"token":self.saveToken
    };
   
    [HttpRequest POSTRequestWithUrlString:MCO_Push_Token
                                    isPay:NO
                                headerDic:nil
                               parameters:dic
                             successBlock:^(id result) {
        MCOLog(@"firebase token上传成功 %@",result);
        [self pushTokenBack];
    } serverErrorBlock:^(id result) {
        MCOLog(@"firebase token上传失败 %@",result);
    } failBlock:^{
        MCOLog(@"firebase token上传网络错错误");
    }];
}

/**
 获取服务端当前时间优化
 */
//获取当前时间
-(void)getCurrentTime{
    [HttpRequest POSTRequestWithUrlString:MCO_GetCurrent_Time isPay:NO headerDic:nil parameters:nil successBlock:^(id result) {
        MCOLog(@"获取当前时间成功：%@",result);
        long currentTime = [result[@"data"][@"current_timestamp"] longLongValue];
        [self currentTimeBack:currentTime];
    } serverErrorBlock:^(id result) {
        MCOLog(@"获取当前时间失败：%@",result);
        [self currentTimeBack:0];
    } failBlock:^{
        MCOLog(@"获取当前时间失败——网络错误");
        [self currentTimeBack:0];
    }];
}

-(void)currentTimeBack:(long)currentTime{
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentTimeBack:)]) {
        [self.delegate currentTimeBack:currentTime];
    }
}

#pragma mark - ------------- 监测网络状态 -------------
-(void)listenNetWorkingStatus{
   //1:创建网络监听者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //2:获取网络状态
    /*
     AFNetworkReachabilityStatusUnknown          = 未知网络，
     AFNetworkReachabilityStatusNotReachable     = 没有联网
     AFNetworkReachabilityStatusReachableViaWWAN = 蜂窝数据
     AFNetworkReachabilityStatusReachableViaWiFi = 无线网
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.listenNetworkNum ++;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                MCOLog(@"AF:未知网络");
                NSDictionary *dic = @{
                    @"state":@(1)
                };
                [self listenNetWorkingStatusBack:dic];
                break;
            }
            
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSDictionary *dic = @{
                    @"state":@(0)
                };
                [self listenNetWorkingStatusBack:dic];
                MCOLog(@"AF:没有联网");
                
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSDictionary *dic = @{
                    @"state":@(1)
                };
                [self listenNetWorkingStatusBack:dic];
                MCOLog(@"AF:蜂窝数据");
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSDictionary *dic = @{
                    @"state":@(1)
                };
                [self listenNetWorkingStatusBack:dic];
                MCOLog(@"AF:无线网");
                break;
            }
                
            default:
                break;
        }
    }];
    
    //开启网络监听
    [manager startMonitoring];
}

-(void)listenNetWorkingStatusBack:(NSDictionary *)data{
    int state = [[data objectForKey:@"state"] intValue];
    if (state == 0) {
        //无网络
        if (self.delegate && [self.delegate respondsToSelector:@selector(netWorkingStatusBack:)]) {
            MCOLog(@"NetWorkingStatus no");
            [self.delegate netWorkingStatusBack:NO];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(netWorkingStatusBack:)]) {
            MCOLog(@"NetWorkingStatuss yes");
            [self.delegate netWorkingStatusBack:YES];
        }
        
        //判断初始化是否成功，若未成功则进行初始化
        if (self.isInitSuc) {
            MCOLog(@"初始化已成功过，不需重试");
        }else{
            if (self.listenNetworkNum > 1) {
                [self initSDKSetting:self.mcoBaseUrl sdkKey:self.sdkKey gameId:self.gameId payKey:self.payKey APPScheme:self.appScheme channel:self.channel appId:self.appId googleClient:self.googleClient appleAppID:self.appleAppID plugClientId:self.plugClientId plugSecret:self.plugSecret loungeId:self.loungeId];
            }
        }
    }
    
}

-(void)reportCreateRole{
    [self verifyPurchaseWithProductionEnvironment];
}

-(void)verifyPurchaseWithProductionEnvironment{
    MCOLog(@"预订票据验证");
    
//    NSString *isReportSuc = [MCODOMKeychain passwordForService:@"isReportSuc" account:@"list"];
    NSString *isReportSuc = [MCOSAMKeychain passwordForService:@"isReportSuc" account:@"list"];
    if ([isReportSuc isEqualToString:@"OK"]) {
        MCOLog(@"预订receiptDataString已上报成功过 return");
        return;
    }

    if ([isReportSuc isEqualToString:@"NO"]) {
        MCOLog(@"预订receiptDataStringy已验证过 不是预订用户 return");
        return;
    }

    if(![publicMath isBlankString:self.bookingProductID]){
        MCOLog(@"预订productID为空 return");
        return;
    }

    //获取票据信息
    NSURL *receiptURL = [NSBundle mainBundle].appStoreReceiptURL;
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString *receiptDataString = [publicMath jptbase64StringFromData:receiptData length:[receiptData length]];

    if (![publicMath isBlankString:receiptDataString]) {
        MCOLog(@"预订receiptDataString为空 return");
        return;
    }
    
    [MCOVerifyReceipt verifyPurchaseWithProductionEnvironment:receiptDataString appleUrl:MCOIAPVerifyReceiptProxAPI];
}


//弹窗显示引导用户允许设置通知权限
-(void)openNotificationAlert{
    
    //判断用户是否已经同意消息通知
    if (@available(iOS 10 , *))
    {

        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    if(settings.authorizationStatus == UNAuthorizationStatusDenied || settings.authorizationStatus == UNAuthorizationStatusNotDetermined){
                        //没有权限
                        MCOLog(@"玩家不同意弹窗 ");
                        //判断时间 每个设备一周（7天）最多弹出2次；超过2次后，一周内不再弹出
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self popTanchuan];
                        });
                    }else{
                        //已经开启通知权限
                        MCOLog(@"玩家已同意弹窗 ");
                        return;
                    }
        }];

    }

}

-(void)popTanchuan{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSInteger popPushNum = [user integerForKey:@"popPushNum"];
    if([self isWeek]){
        //7天内
        if(popPushNum == 1){
            //判断是否为当天
            if([self isToday]){
                MCOLog(@"今天已经弹出过弹窗");
                return;
            }
        }else if(popPushNum > 1){
            //不再push消息
            MCOLog(@"7天内已弹出弹窗两次");
            return;
        }
    }else{
        popPushNum = 0;
    }

    [user setObject:[NSDate date] forKey:@"nowDate"];

    popPushNum++;
    [user setInteger:popPushNum forKey:@"popPushNum"];

    [user synchronize];
    
    MCOPushVC *mcoPushVC = [[MCOPushVC alloc] init];
    mcoPushVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    mcoPushVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UIViewController *newTopVC = [MCOOSSDKCenter currentViewController];
    [newTopVC presentViewController:mcoPushVC animated:NO completion:nil];
}

//是否七天内
-(BOOL)isWeek{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDate *selfDate = [userDefault objectForKey:@"nowDate"];
    
    if(!selfDate){
        return YES;
    }
    
    NSDate *nowDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selfDate toDate:nowDate options:0];
    return cmps.year == 0 && cmps.month == 0 && cmps.day < 7;
    
}

/**
 判断是否为当天
 当天返回YES
 不是当天返回NO
 */
-(BOOL)isToday{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDate *now = [NSDate date];
    NSDate *agoDate = [userDefault objectForKey:@"nowDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *ageDateString = [dateFormatter stringFromDate:agoDate];
    NSString *nowDateString = [dateFormatter stringFromDate:now];
    if ([ageDateString isEqualToString:nowDateString]) {
        //每天只能一次,现在是当天
        return YES;
    }else{
        //现在是另外一天了
        return NO;
    }
}

-(void)setLogDebug:(BOOL)enable{
    [publicMath setLogEnable:enable];
}

-(BOOL)getLogDebug{
    return [publicMath getLogEnable];
}
@end
