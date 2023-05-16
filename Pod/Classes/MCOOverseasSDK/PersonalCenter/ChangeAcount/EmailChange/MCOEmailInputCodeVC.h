//
//  MCOEmailInputCodeVC.h
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/14.
//

#import "BaseViewVC.h"
#import "MCOTextField.h"
#import "MCOAttributeTextView.h"
#import "MCOEmailInputPasswordVC.h"
#import "MCONoCodeTipVC.h"

@interface MCOEmailInputCodeVC : BaseViewVC<UITextFieldDelegate>

@property(nonatomic,strong)NSString *emailStr;
@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,strong)NSString *btnStr;

@property(nonatomic,assign)int type;//1.登录 2.切换登录 3.绑定账号

@property(nonatomic,strong)MCOTextField *inputCodeTF;
@property(nonatomic,strong)UIButton *getCodeBtn;

@property(nonatomic,assign)NSInteger time;
@property(nonatomic,assign)NSInteger nowTime;

@end
