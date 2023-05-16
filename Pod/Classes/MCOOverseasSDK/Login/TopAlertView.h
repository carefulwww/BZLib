//
//  TopAlertView.h
//  MCOStandAlone
//
//  Copyright © 2019 test. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface TopAlertView : UIView

@property(nonatomic,assign)NSInteger backCountDown;
@property(nonatomic,strong)NSTimer *backTimer;
@property(nonatomic,strong)UIImageView *imageChange;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIButton *switchBtn;

+ (void)SetUpbackgroundColor:(UIColor *)color andStayTime:(CGFloat)setStayTime andTitleStr:(NSString *)titleStr andTitleColor:(UIColor *)titleColor;

@end
