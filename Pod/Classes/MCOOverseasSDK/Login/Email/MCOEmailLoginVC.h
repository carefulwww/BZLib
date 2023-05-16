//
//  MCOEmailLoginVC.h
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/15.
//

#import "BaseViewVC.h"
#import "SwitchUserCell.h"
#import "SwitchUserModel.h"

@interface MCOEmailLoginVC : BaseViewVC<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)MCOTextField *emailTF;
@property(nonatomic,strong)MCOTextField *passwordTF;
@property(nonatomic,strong)UILabel *msgLabel;

@property(nonatomic,strong)UIView *thirdLoginView;
@property(nonatomic,strong)MCOAppleLogin *appleLogin;

@property(nonatomic,assign)int appState;

@property(nonatomic,strong)UITableView *switchTableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)UIButton *switchBtn;

@property(nonatomic,strong)NSString *emailStr;
@end
