//
//  MCOEmailInputPasswordVC.h
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/15.
//

#import "BaseViewVC.h"
#import "MCOTextField.h"
#import "MCOAttributeTextView.h"

@interface MCOEmailInputPasswordVC : BaseViewVC<UITextFieldDelegate>

@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *emailStr;
@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,strong)NSString *btnStr;
@property(nonatomic,strong)NSString *tipStr;//提示内容

@property(nonatomic,assign)int type;//1.登录 2.切换登录 3.绑定账号

@property(nonatomic,strong)MCOTextField *inputPasswordTF;


@end
