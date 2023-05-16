//
//  CancelCountDown.h
//  MCOOverseasProject
//

/**
 账号注销-账号注销倒计时
 */

#import "BaseViewVC.h"

@interface CancelCountDown : BaseViewVC

@property(nonatomic,strong)UITextView *timeDisplay;

@property (nonatomic, strong) dispatch_source_t countdownTimer;

@property(nonatomic,assign)int countDownTime;

@end
