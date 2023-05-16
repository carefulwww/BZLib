//
//  MCOFBLogin.m
//  MCOOverseasProject
//

#import "MCOFBLoginManager.h"

@implementation MCOFBLoginManager

+(void)fbLogin:(nullable UIViewController *)fromViewController isChange:(BOOL)isChange hud:(MBProgressHUD *)hud{
  
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login logInWithPermissions:@[@"public_profile"] fromViewController:nil handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            MCOLog(@"process error,%@, result = %@",error,result);
            [hud hideAnimated:YES];
            [publicMath MCOHub:[publicMath getLocalString:@"facebookChangeAccountFail"] messageView:fromViewController.view];
        }else if(result.isCancelled){
            MCOLog(@"cancelled");
            [hud hideAnimated:YES];
            [publicMath MCOHub:[publicMath getLocalString:@"cancelChange"] messageView:fromViewController.view];
        }else{
            MCOLog(@"Logged in");
            NSDictionary *dic = @{
                @"type":@"2",//脸书登录
                @"token":result.token.tokenString,
                @"open_id":result.token.userID,
            };
            [MCOLoginManager reportThirdLogin:dic isChange:isChange hud:hud];
        }
    }];
    
}


+(void)fbBind:(nullable UIViewController *)fromViewController hud:(MBProgressHUD *)hud{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login logInWithPermissions:@[@"public_profile"] fromViewController:nil handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            MCOLog(@"process error,%@, result = %@",error,result);
            [hud hideAnimated:YES];
            [publicMath MCOHub:[publicMath getLocalString:@"facebookBindTip"] messageView:fromViewController.view];
        }else if(result.isCancelled){
            MCOLog(@"cancelled");
            [hud hideAnimated:YES];
            [publicMath MCOHub:@"Cancel Bind" messageView:fromViewController.view];
        }else{
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            if (![publicMath isBlankString:[user objectForKey:@"uuid"]]||![publicMath isBlankString:[user objectForKey:@"token"]]) {
                MCOLog(@"第三方账号绑定uuid、token不可为空");
                return;
            }
            MCOLog(@"Logged in");
            NSDictionary *dic = @{
                @"bind_type":@"2",//脸书绑定
                @"third_token":result.token.tokenString,
                @"open_id":result.token.userID,
                @"uuid":[user objectForKey:@"uuid"],
                @"token":[user objectForKey:@"token"],
            };
            
            [MCOLoginManager reportBindThirdLogin:dic hud:hud];
            
        }
    }];
}

@end
