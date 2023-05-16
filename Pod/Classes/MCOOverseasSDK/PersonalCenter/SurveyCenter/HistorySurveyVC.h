//
//  HistorySurveyVC.h
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/11/17.
//

#import "BaseViewVC.h"
#import "HistorySurveyCell.h"

static NSString *historyIdentifier = @"historyCellID";

@interface HistorySurveyVC :  BaseViewVC<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,assign)CGFloat itemWidth;
@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSArray *surveyArr;

@property(nonatomic,strong)UIBarButtonItem *navBackBtn;

@end
