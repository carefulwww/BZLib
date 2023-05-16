//
//  CancelUserDetailVC.h
//  MCOOverseasProject
//
/**
 账号注销-详细信息
 */

#import "BaseViewVC.h"
#import "CancelTipVC.h"
#import "CancelTreatyVC.h"

static NSString *cancelUserDetailIdentifier = @"cancelUserDetailIdentifier";

@interface CancelUserDetailVC : BaseViewVC<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate>

@property(nonatomic,strong)UITableView *detailTableView;
@property(nonatomic,strong)NSArray *userDetailArr;

@end
