//
//  MCOEmailChangeVC.h
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/13.
//

#import "BaseViewVC.h"
#import "MCOTextField.h"

#import "MCOEmailGetCodeVC.h"

#import "SwitchUserCell.h"
#import "SwitchUserModel.h"

@interface MCOEmailChangeVC : BaseViewVC<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)MCOTextField *emailTF;
@property(nonatomic,strong)MCOTextField *passwordTF;

@property(nonatomic,strong)UIView *thirdLoginView;
@property(nonatomic,strong)MCOAppleLogin *appleLogin;

@property(nonatomic,strong)UITableView *switchTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UIButton *switchBtn;

@property(nonatomic,strong)NSString *emailStr;

@end
