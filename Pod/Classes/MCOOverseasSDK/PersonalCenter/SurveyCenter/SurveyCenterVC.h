//
//  SurveyCenterVC.h
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/5/13.
//

#import "BaseViewVC.h"
#import "SurveyBtn.h"
#import "SurveyDetailVC.h"
#import "SurveyCellVC.h"
#import "CenterFooterVC.h"

static NSString *scIdentifier = @"scCellID";

@interface SurveyCenter :  BaseViewVC<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,assign)CGFloat itemWidth;
@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSArray *surveyArr;

@property(nonatomic,strong)UIButton *backBtn;

@property(nonatomic,strong)NSString *url;

@property(nonatomic,strong)NSString *roleId;

@end
