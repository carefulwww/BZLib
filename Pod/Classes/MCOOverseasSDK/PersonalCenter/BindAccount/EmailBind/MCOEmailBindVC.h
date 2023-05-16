//
//  MCOEmailBindVC.h
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/14.
//

#import "BaseViewVC.h"

@interface MCOEmailBindVC : BaseViewVC<UITextFieldDelegate>

@property(nonatomic,strong)MCOTextField *emailTF;
@property(nonatomic,strong)MCOTextField *passwordTF;

@property(nonatomic,strong)NSString *emailStr;

@end
