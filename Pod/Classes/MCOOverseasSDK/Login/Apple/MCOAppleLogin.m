//
//  MCOAppleLogin.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2020/12/30.
//

#import "MCOAppleLogin.h"

@implementation MCOAppleLogin

+(instancetype)appLogoinFromView:(UIView *)superView rect:(CGRect)rect block:(void(^)(NSInteger state,NSString *msg,id data))block
{
    MCOAppleLogin * appleLogin = [self appLogoinFromView:superView rect:rect];
    appleLogin.appleLoginBlock = block;
    return appleLogin;
}


+(instancetype)appLogoinFromUser:(NSString *)user view:(UIView *)view rect:(CGRect)rect block:(void(^)(NSInteger state,NSString *msg,id data))block
{
    MCOAppleLogin * appleLogin = [self appLogoinFromView:view rect:rect];
    appleLogin.userId       = user;
    appleLogin.appleLoginBlock = block;
    return appleLogin;
}


+(instancetype)appLogoinFromView:(UIView *)superView rect:(CGRect)rect
{
    MCOAppleLogin * appleLogin = [[MCOAppleLogin alloc]initWithFrame:rect];
    appleLogin.view         = superView;
    appleLogin.rect         = rect;
    return appleLogin;
}

- (void)initUI
{
    if (@available(iOS 13.0, *))
    {
        ASAuthorizationAppleIDButton *button = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleBlack];
        button.frame = CGRectMake(0, 0, self.rect.size.width, self.rect.size.height);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = self.frame.size.width/2;
        [button addTarget:self action:@selector(signInWithApple) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.view addSubview:self];
    }
}


#pragma mark ————————————— 登录按钮点击事件 —————————————
- (void)signInWithApple API_AVAILABLE(ios(13.0))
{
    if (@available(iOS 13.0, *))
    {
         MCOLog(@"Apple Login Click");
        //基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        if (_userId.length == 0)
        {
            MCOLog(@"授权请求AppleID");
            ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
            [request setRequestedScopes:@[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail]];
            //由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
            ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
            //设置授权控制器通知授权请求的成功与失败的代理
            controller.delegate = self;
            //设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
            controller.presentationContextProvider = self;
            //在控制器初始化期间启动授权流
            [controller performRequests];
        }
        else
        {
//            MCOLog(@"快速登录使用授权登录返回的 user ");
            //快速登录
            [appleIDProvider getCredentialStateForUserID:_userId completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
 
                if (credentialState == ASAuthorizationAppleIDProviderCredentialAuthorized)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    if (self.appleLoginBlock)
                    {
                      self.appleLoginBlock(AppleLoginTypeUserSuccessful,@"ok",dic);
                    }
                }
                else
                {   NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setValue:error.description forKey:@"errorMsg"];
                    [dic setValue:[NSNumber numberWithInteger:error.code] forKey:@"code"];
                    if (self.appleLoginBlock)
                    {
                      self.appleLoginBlock(AppleLoginTypeFailure,error.description,dic);
                    }
                }
            }];
        }
    }
    else
    {
 
    }
}
 
#pragma mark ————————————— 成功回调 —————————————
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0))
{
//        MCOLog(@"授权完成:::%@", authorization.credential);
//        MCOLog(@"%s", __FUNCTION__);
//        MCOLog(@"%@", controller);
//        MCOLog(@"%@", authorization);
        
        if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]])
        {
            // 用户登录使用ASAuthorizationAppleIDCredential
            ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
            NSString *user = appleIDCredential.user;
            // 使用过授权的，可能获取不到以下三个参数
            NSString *familyName = appleIDCredential.fullName.familyName;
            NSString *givenName = appleIDCredential.fullName.givenName;
            NSString *nickname = appleIDCredential.fullName.nickname;
            
            NSString *email = appleIDCredential.email;
            NSString *state = appleIDCredential.state;
            NSData *identityToken = appleIDCredential.identityToken;
            NSData *authorizationCode = appleIDCredential.authorizationCode;
            ASUserDetectionStatus realUserStatus = appleIDCredential.realUserStatus;
            
            // 服务器验证需要使用的参数
            NSString *identityTokenStr = [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding];
            NSString *authorizationCodeStr = [[NSString alloc] initWithData:authorizationCode encoding:NSUTF8StringEncoding];
            //  MCOLog(@"%@\n\n%@", identityTokenStr, authorizationCodeStr);
 
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:state forKey:@"state"];
            [dic setValue:user forKey:@"user"];
            [dic setValue:email forKey:@"email"];
            [dic setValue:familyName forKey:@"familyName"];
            [dic setValue:givenName forKey:@"givenName"];
            [dic setValue:nickname forKey:@"nickname"];
//            [dic setValue:appleIDCredential forKey:@"appleIDCredential"];
            [dic setValue:authorizationCodeStr forKey:@"authorizationCode"];
            [dic setValue:identityTokenStr forKey:@"identityToken"];
//            [dic setValue:@(realUserStatus) forKey:@"realUserStatus"];
            
            if (self.appleLoginBlock)
            {
                self.appleLoginBlock(AppleLoginTypeSuccessful, @"ok",dic);
            }
            //  需要使用钥匙串的方式保存用户的唯一信息 Keychain
        }
        else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]])
        {
            // 这个获取的是iCloud记录的账号密码，需要输入框支持iOS 12 记录账号密码的新特性，如果不支持，可以忽略
            // Sign in using an existing iCloud Keychain credential.
            // 用户登录使用现有的密码凭证
            ASPasswordCredential *passwordCredential = authorization.credential;
            // 密码凭证对象的用户标识 用户的唯一标识
            NSString *user = passwordCredential.user;
            // 密码凭证对象的密码
            NSString *password = passwordCredential.password;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:user forKey:@"user"];
            [dic setValue:password forKey:@"password"];
            if (self.appleLoginBlock)
            {
                self.appleLoginBlock(AppleLoginTypeSuccessful, @"ok",dic);
            }
        }
        else
        {
//            MCOLog(@"授权信息均不符");
            NSString *errorMsg = @"授权信息不符";
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:errorMsg forKey:@"errorMsg"];
            if (self.appleLoginBlock)
            {
              self.appleLoginBlock(AppleLoginTypeFailure,errorMsg,dic);
            }
        }
}
 
#pragma mark ————————————— 失败回调 —————————————
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0))
{
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:errorMsg forKey:@"errorMsg"];
    [dic setValue:[NSNumber numberWithInteger:error.code] forKey:@"code"];
    if (self.appleLoginBlock)
    {
      self.appleLoginBlock(AppleLoginTypeFailure,errorMsg,dic);
    }
}
 
#pragma mark ————————————— 告诉代理应该在哪个window 展示内容给用户 —————————————
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0))
{
    return [UIApplication sharedApplication].windows.lastObject;
}

@end
