//
//  TopAlertView.m
//  MCOStandAlone
//
//  Copyright © 2019 test. All rights reserved.
//

#import "TopAlertView.h"


@interface TopAlertView()
{
    CGFloat stayTime;
    CGFloat kAlertViewHeight;
}
@end

@implementation TopAlertView

+ (void)SetUpbackgroundColor:(UIColor *)color andStayTime:(CGFloat)setStayTime  andTitleStr:(NSString *)titleStr andTitleColor:(UIColor *)titleColor{
    TopAlertView *alert = [[TopAlertView alloc]init];
    NSString* title = [NSString stringWithFormat:@"%@%@",[publicMath getLocalString:@"welcomeTip"],titleStr];
    [alert setupView:color andStayTime:setStayTime andTitleStr:title  andTitleColor:titleColor];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
}

-(id)init{
    kAlertViewHeight = 55;
    if(self = [super init]){
//        if ([self isNotchScreen]) {
//            kAlertViewHeight = kAlertViewHeight+22;
//        }
        self.frame = CGRectMake((ScreenWidth-260)/2, 36, 260, kAlertViewHeight-15);
        [self.layer setCornerRadius:8];
//        [self setupViews];
        [self startPosition];
        [self setDeclineAnimation];
//        [self addSubview:self.switchBtn];
//        [self addSubview:self.imageChange];
    }
    return self;
}

-(UILabel *)titleLab{
    if(!_titleLab){
        self.titleLab = [[UILabel alloc] init];
        [self.titleLab setTextAlignment:NSTextAlignmentCenter];
        self.titleLab.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.titleLab.font = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
        self.titleLab.numberOfLines = 0;
        [self addSubview:self.titleLab];
    }
    return _titleLab;
}

- (void)setupView:(UIColor *)color andStayTime:(CGFloat)setStayTime andTitleStr:(NSString *)titleStr andTitleColor:(UIColor *)titleColor{
    stayTime = setStayTime;
    self.backgroundColor = color;
    self.titleLab.textColor = titleColor;
    self.titleLab.text = titleStr;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [self addGestureRecognizer:singleTap];
}

-(void)touch{
    [self setGoUpAnimation];
}

//初始位置
-(void)startPosition{
    self.center = CGPointMake(ScreenWidth/2, -self.frame.size.height/2);
}

//最终位置
-(void)endPosition{
    self.center = CGPointMake(ScreenWidth/2, kAlertViewHeight);
}


-(void)removeSelf{
    [self removeFromSuperview];
}

//下降
-(void)setDeclineAnimation{
    [UIView animateWithDuration:0.5 animations:^{
        [self endPosition];
    } completion:^(BOOL finished) {
        if (self->stayTime >= 0) {
            [self backTime];
        }
    }];
}

//上升
-(void)setGoUpAnimation{
    [self.backTimer invalidate];
    [UIView animateWithDuration:0.5 animations:^{
        [self startPosition];
    } completion:^(BOOL finished) {
        [self removeSelf];
    }];
}

-(void)backTime{
    //设置倒计时总时长
    [self.backTimer invalidate];
    self.backCountDown = stayTime;
    self.backTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(viewBackNSTimer) userInfo:nil repeats:YES];
}

//使用NSTimer实现倒计时
-(void)viewBackNSTimer{
    self.backCountDown--;
    if (self.backCountDown == 0|| self.backCountDown < 0) {
        [self.backTimer invalidate];
        [self setGoUpAnimation];
    }
}

// iPhoneX、iPhoneXR、iPhoneXs、iPhoneXs Max等
// 判断刘海屏，返回YES表示是刘海屏
- (BOOL)isNotchScreen {

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return NO;
    }

    CGSize size = [UIScreen mainScreen].bounds.size;
    NSInteger notchValue = size.width / size.height * 100;

    if (216 == notchValue || 46 == notchValue) {
        return YES;
    }

    return NO;
}
@end
