//
//  HistorySurveyCell.h
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/11/17.
//

@interface HistorySurveyCell : UICollectionViewCell

//展示倒计时
@property(nonatomic,strong)UITextView *timeDisplay;

//图片展示
@property(nonatomic,strong)UIView *imageView;

-(void)displayCellView:(NSDictionary *)dic;

@end


