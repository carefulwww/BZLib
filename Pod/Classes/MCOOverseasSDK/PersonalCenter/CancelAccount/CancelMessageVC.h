//
//  CancelMessageVC.h
//  MCOOverseasProject
//

/**
 账号注销-锁定期时间提示
 */

#import "BaseViewVC.h"
#import "CancelTreatyVC.h"

@interface CancelMessageVC : BaseViewVC

@property(nonatomic,assign)int timeStamp;
@property(nonatomic,strong)NSString *timeStr;
@property(nonatomic,assign)int dayStr;

@end
