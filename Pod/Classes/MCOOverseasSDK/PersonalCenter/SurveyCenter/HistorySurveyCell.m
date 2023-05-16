//
//  HistorySurveyCell.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/11/17.
//

#import "HistorySurveyCell.h"

@implementation HistorySurveyCell

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
    NSArray *gift_arr = [dic objectForKey:@"gift_content"];
    
    UITextView *tipTextView = [[UITextView alloc] init];
    [tipTextView setFont:[UIFont systemFontOfSize:12]];
    [tipTextView setTextColor:[UIColor colorWithHexString:MCO_Grey_Text]];
    [tipTextView setText:[publicMath getLocalString:@"completeTime"]];
    [tipTextView sizeToFit];
    
    _timeDisplay = [[UITextView alloc] init];
    [_timeDisplay setFont:[UIFont systemFontOfSize:12]];
    [_timeDisplay setTextColor:[UIColor colorWithHexString:MCO_Grey_Text]];
    [_timeDisplay setText:[dic objectForKey:@"complete_time"]];
    _timeDisplay.frame = CGRectMake(0, 0, self.frame.size.width/2, 25);
    
    _imageView = [self displayGiftIcon:gift_arr cell:self];
    
    if (ScreenWidth > ScreenHeight) {
        //横
        tipTextView.frame = CGRectMake(20, 16, tipTextView.frame.size.width, tipTextView.frame.size.height);
        _timeDisplay.frame = CGRectMake(tipTextView.frame.origin.x + tipTextView.frame.size.width + 2, 16, _timeDisplay.frame.size.width, _timeDisplay.frame.size.height);
    }else{
        //竖
        tipTextView.frame = CGRectMake((self.frame.size.width - tipTextView.frame.size.width)/2-50, 16, tipTextView.frame.size.width, tipTextView.frame.size.height);
        _timeDisplay.frame = CGRectMake(tipTextView.frame.origin.x + tipTextView.frame.size.width + 2, 16, _timeDisplay.frame.size.width, _timeDisplay.frame.size.height);
    }

    [self addSubview:tipTextView];
    [self addSubview:_timeDisplay];

    //礼物View
    [self addSubview:_imageView];
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
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(64-30, 64-15, 30, 15)];
        UIBezierPath *cornerRdiusPath = [UIBezierPath bezierPathWithRoundedRect:numLabel.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *cornerRadiusLayer = [[CAShapeLayer alloc] init];
        cornerRadiusLayer.frame = numLabel.bounds;
        cornerRadiusLayer.path = cornerRdiusPath.CGPath;
        numLabel.layer.mask = cornerRadiusLayer;
        numLabel.layer.borderWidth = 1;
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.backgroundColor = [UIColor whiteColor];
        numLabel.text = [NSString stringWithFormat:@"%@",giftIcon[@"gift_num"]];
        [numLabel setFont:[UIFont systemFontOfSize:11]];
        [numLabel setTextAlignment:NSTextAlignmentCenter];
        numLabel.layer.borderColor = [UIColor colorWithHexString:MCO_Gray_Bounds].CGColor;
        [self downloadImage:image url:giftIcon[@"icon_url"]];
        [imageView addSubview:image];
        [imageView addSubview:numLabel];
        [giftView addSubview:imageView];
    }

    return giftView;
}

//加载图片
-(void)downloadImage:(UIImageView *)view url:(NSString *)url{
    NSURL *imageUrl = [NSURL URLWithString:url];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    view.image = image;
}

@end
