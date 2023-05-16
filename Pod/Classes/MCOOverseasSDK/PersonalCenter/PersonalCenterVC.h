//
//  PersonalCenterVC.h
//  MCOOverseasProject
//

#import <UIKit/UIKit.h>

#import "CancelCountDown.h"
#import "CancelTreatyVC.h"


static NSString *identifier = @"cxCellID";
@interface PersonalCenterVC : BaseViewVC<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIImageView *bgImage;

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,assign)CGFloat itemWidth;

@property(nonatomic,strong)UIButton *backBtn;

@property(nonatomic,strong)UILabel *userNameLabel;

@property(nonatomic,strong)UIImageView *userFace;

@property(nonatomic,strong)UIImageView *logoImage;

@property(nonatomic,strong)NSString *roleId;

@property(nonatomic,assign)NSInteger company_entity;

@property(nonatomic,assign)BOOL isShowSurvey;

/**
 账号注销
 */
@property(nonatomic,assign)BOOL isDeleteUser;
@property(nonatomic,assign)int deleteUserTime;
@property (nonatomic, strong) dispatch_source_t countdownTimer;

@end
