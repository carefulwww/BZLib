//
//  SurveyCellVC.h
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/9/26.
//

#import <UIKit/UIKit.h>
#import "SurveyBtn.h"
#import "SurveyDetailVC.h"
@interface SurveyCellVC : UICollectionViewCell

@property (nonatomic, strong) dispatch_source_t countdownTimer;

//展示倒计时
@property(nonatomic,strong)UITextView *timeDisplay;

//进入问卷按钮
@property(nonatomic,strong)SurveyBtn *goSurveyBtn;

//图片展示
@property(nonatomic,strong)UIView *imageView;

-(void)displayCellView:(NSDictionary *)dic;

@end
