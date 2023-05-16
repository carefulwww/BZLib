//
//  ChangeAccountVC.h
//  MCOOverseasProject
//

#import "BaseViewVC.h"
@import GoogleSignIn;

@interface ChangeAccountVC : BaseViewVC<GIDSignInDelegate>

@property(nonatomic,strong)UIView *thirdLoginView;
@property(nonatomic,strong)MCOAppleLogin *appleLogin;

@end
