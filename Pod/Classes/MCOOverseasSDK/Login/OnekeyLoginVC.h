//
//  OnekeyLoginVC.h
//  MCOOverseasProject
//
//

#import "BaseViewVC.h"
#import <Foundation/Foundation.h>
@import GoogleSignIn;

@interface OnekeyLoginVC : BaseViewVC<GIDSignInDelegate>

@property(nonatomic,strong)UILabel *msgLabel;
@property(nonatomic,strong)UIView *thirdLoginView;
@property(nonatomic,strong)MCOAppleLogin *appleLogin;

@property(nonatomic,assign)int appState;
@end
