//
//  BindAccountVC.h
//  MCOOverseasProject
//
//

#import <UIKit/UIKit.h>
#import "MCOBindBtn.h"

@import GoogleSignIn;

@interface BindAccountVC : BaseViewVC<GIDSignInDelegate>

@property(nonatomic,strong)UIView *thirdLoginView;
@property(nonatomic,strong)MCOAppleLogin *appleLogin;
@property(nonatomic,strong)NSMutableArray *btnArr;

@end
