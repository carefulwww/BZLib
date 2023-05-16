//
//  SurveyCellVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/9/26.
//

#import "SurveyCellVC.h"

@implementation SurveyCellVC

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createSubView];
    }
    return self;
}

-(void)_createSubView{
    [self setBackgroundColor:[UIColor whiteColor]];
    self.layer.cornerRadius = 20;
}

-(void)displayCellView:(NSDictionary *)dic{
    NSString *url = [dic objectForKey:@"survey_url"];
    NSArray *gift_arr = [dic objectForKey:@"gift_content"];
    
    UITextView *tipTextView = [[UITextView alloc] init];
    [tipTextView setFont:[UIFont systemFontOfSize:12]];
    [tipTextView setTextColor:[UIColor colorWithHexString:MCO_Grey_Text]];
    [tipTextView setText:[publicMath getLocalString:@"countDownTip"]];
    [tipTextView sizeToFit];
    
    _timeDisplay = [[UITextView alloc] init];
    [_timeDisplay setFont:[UIFont systemFontOfSize:12]];
    [_timeDisplay setTextColor:[UIColor colorWithHexString:MCO_Grey_Text]];

    NSInteger endTime = [[dic objectForKey:@"end_time"] intValue];
    
    [self resetCountdown:endTime timeTip:self.timeDisplay];
    
    _timeDisplay.frame = CGRectMake(0, 0, self.frame.size.width/2, 25);
    
    _imageView = [self displayGiftIcon:gift_arr cell:self];
    
    _goSurveyBtn = [[SurveyBtn alloc] init];
    
    if (ScreenWidth > ScreenHeight) {
        //横
        tipTextView.frame = CGRectMake(36, 16, tipTextView.frame.size.width, tipTextView.frame.size.height);
        _timeDisplay.frame = CGRectMake(tipTextView.frame.origin.x + tipTextView.frame.size.width + 2, 16, _timeDisplay.frame.size.width, _timeDisplay.frame.size.height);
        _timeDisplay.backgroundColor = [UIColor clearColor];
        _goSurveyBtn.frame = CGRectMake(self.frame.size.width-122-36,(self.frame.size.height - 36)/2, 122, 36);
    }else{
        //竖
        tipTextView.frame = CGRectMake((self.frame.size.width - tipTextView.frame.size.width)/2-25, 16, tipTextView.frame.size.width, tipTextView.frame.size.height);
        _timeDisplay.frame = CGRectMake(tipTextView.frame.origin.x + tipTextView.frame.size.width + 2, 16, _timeDisplay.frame.size.width, _timeDisplay.frame.size.height);
        _timeDisplay.backgroundColor = [UIColor clearColor];
//        _timeDisplay.frame = CGRectMake((self.frame.size.width-_timeDisplay.frame.size.width)/2, 16, _timeDisplay.frame.size.width, _timeDisplay.frame.size.height);
        _goSurveyBtn.frame = CGRectMake((self.frame.size.width-122)/2,_imageView.frame.size.height+_imageView.frame.origin.y+23, 122, 36);
    }

    [self addSubview:tipTextView];
    [self addSubview:_timeDisplay];

    //礼物View
    [self addSubview:_imageView];
    
    [_goSurveyBtn setTitle:[publicMath getLocalString:@"goToSurvey"] forState:UIControlStateNormal];
    [_goSurveyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_goSurveyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_goSurveyBtn.layer setCornerRadius:4];
    [_goSurveyBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Main_Theme_Color]];
    _goSurveyBtn.url = url;
    [_goSurveyBtn addTarget:self action:@selector(goToSurvey:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_goSurveyBtn];
}

-(void)goToSurvey:(SurveyBtn *)surveyBtn{
    if ([publicMath isBlankString:surveyBtn.url]) {
        //不为空
        MCOLog(@"survey url : %@",surveyBtn.url);
        
        SurveyDetailVC *detailVC = [[SurveyDetailVC alloc] init];
        detailVC.pathUrl = surveyBtn.url;
        detailVC.modalPresentationStyle = UIModalPresentationFullScreen;
        UIViewController *topVC = [MCOOSSDKCenter currentViewController];
        [topVC presentViewController:detailVC animated:NO completion:nil];
    }else{
        //url为空
        MCOLog(@"survey url empty");
    }
}


//奖励图片展示
-(UIView *)displayGiftIcon:(NSArray *)giftArr cell:(UICollectionViewCell *)cell{
    
    UIView *giftView = [[UIView alloc] init];
    
    if (ScreenWidth > ScreenHeight) {
        //横
        if ([giftArr count] < 5) {
            giftView.frame = CGRectMake(36, 43, 295, 64);
        }else{
            giftView.frame = CGRectMake(36, 43, 295, 64*2+12);
        }
    }else{
        //竖
        if ([giftArr count] < 5) {
            giftView.frame = CGRectMake((cell.frame.size.width - 295)/2, 57, 295, 64);
        }else{
            giftView.frame = CGRectMake((cell.frame.size.width - 295)/2, 57, 295, 64*2+12);
        }
    }
    
    for (int i = 0; i < [giftArr count]; i++) {
        NSDictionary *giftIcon = giftArr[i];
        UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake((i%4)*(64+13), (64+12)*(i/4), 64, 64)];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 56, 56)];
        imageView.layer.borderColor = [UIColor colorWithHexString:MCO_Gray_Bounds].CGColor;
        imageView.layer.cornerRadius = 8;
        imageView.layer.borderWidth = 1;
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64-15, 64, 15)];
        
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.backgroundColor = [UIColor whiteColor];
        numLabel.text = [NSString stringWithFormat:@"%@",giftIcon[@"gift_num"]];
        UIFont *fnt = [UIFont systemFontOfSize:11];
        [numLabel setFont:fnt];
        [numLabel setTextAlignment:NSTextAlignmentCenter];
        numLabel.layer.borderColor = [UIColor colorWithHexString:MCO_Gray_Bounds].CGColor;
        
        CGSize size = [numLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName,nil]];
        CGFloat numW = size.width+2;
        
        numLabel.frame = CGRectMake(64-numW, 64-15, numW, 15);
        UIBezierPath *cornerRdiusPath = [UIBezierPath bezierPathWithRoundedRect:numLabel.bounds byRoundingCorners: UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *cornerRadiusLayer = [[CAShapeLayer alloc] init];
        cornerRadiusLayer.frame = numLabel.bounds;
        cornerRadiusLayer.path = cornerRdiusPath.CGPath;
        numLabel.layer.mask = cornerRadiusLayer;
        numLabel.layer.borderWidth = 1;
        
        [self downloadImage:image url:giftIcon[@"icon_url"]];
        [imageView addSubview:image];
        [imageView addSubview:numLabel];
        [giftView addSubview:imageView];
    }

    return giftView;
}

//加载图片
-(void)downloadImage:(UIImageView *)view url:(NSString *)url{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *imageUrl = [NSURL URLWithString:url];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        view.image = image;
    });
}

/**
 倒计时
 */
-(void)countDownWithTimer:(dispatch_source_t)timer timeInterval:(NSTimeInterval)timeInterval complete:(void(^)())completeBlock progress:(void(^)(int mHours, int mMinute, int mSecond))progressBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        __block int timeout = timeInterval; //倒计时时间
        if (timeout!=0) {
            dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(timer);
                    dispatch_async(dispatch_get_main_queue(), ^{ // block 回调
                        if (completeBlock) {
                            completeBlock();
                        }
                    });
                }else{
                    int hours = (int)((timeout)/3600);
                    int minute = (int)(timeout-hours*3600)/60;
                    int second = (int)(timeout-hours*3600-minute*60);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (progressBlock) { //进度回调
                            progressBlock(hours, minute, second);
                        }
                    });
                    timeout--;
                }
            });
            dispatch_resume(timer);
        }
    });
}

-(void)resetCountdown:(NSInteger)endTime timeTip:(UITextView *)timeTip{
    [self cancelCountDownTimer];
    NSInteger nowTime = [[GetDeviceData getTimeStp] intValue];;
    NSInteger count = endTime - nowTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _countdownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    [self countDownWithTimer:_countdownTimer timeInterval:count complete:^{
        //完成操作
        
    } progress:^(int mHours, int mMinute, int mSecond) {
//        MCOLog(@"倒计时 : %d时 %d分 %d秒",mHours,mMinute,mSecond);
        NSString *timeStr = [NSString stringWithFormat:@"%d:%d:%d",mHours,mMinute,mSecond];
        timeTip.text = timeStr;
    }];
}

-(void)cancelCountDownTimer{
    if (_countdownTimer) {
        dispatch_source_cancel(_countdownTimer);
        _countdownTimer = nil;
    }
}

-(void)dealloc{
    if (_countdownTimer) {
        dispatch_source_cancel(_countdownTimer);
        _countdownTimer = nil;
    }
}

@end
