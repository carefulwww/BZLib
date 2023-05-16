//
//  MCOEmailGetCodeVC.h
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/14.
//

#import "BaseViewVC.h"
#import "MCOTextField.h"
#import "MCOAttributeTextView.h"

#import "MCOCheckAccountVC.h"

#import "ShowPicCode.h"

@interface MCOEmailGetCodeVC : BaseViewVC<UITextFieldDelegate>

@property(nonatomic,strong)MCOAttributeTextView* userAgreement;
@property(nonatomic,strong)MCOTextField *emailTF;
@property(nonatomic,strong)NSString *btnStr;
@property(nonatomic,strong)NSString *titleStr;

@property(nonatomic,assign)int type;//1.登录 2.切换登录 3.绑定账号 4.登录忘记密码 5.切换忘记密码 6.绑定忘记密码

@end
