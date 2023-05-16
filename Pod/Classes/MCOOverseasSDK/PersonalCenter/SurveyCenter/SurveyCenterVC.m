//
//  SurveyCenterVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/5/13.
//

#import "SurveyCenterVC.h"

@implementation SurveyCenter

-(void)viewDidLoad{

    [super viewDidLoad];
    
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backPressSuc) name:@"backPressSuc" object:nil];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backPressSuc" object:nil];

}

-(void)backPressSuc{
    
    NSDictionary *dic = @{
        @"role_id":self.roleId,
        @"uuid":[MCOOSSDKCenter MCOShareSDK].saveUUID
    };
    [HttpRequest POSTRequestWithUrlString:MCO_Get_Surveys isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
        MCOLog(@"问卷成功 result = %@",result);
        self.surveyArr = result[@"data"][@"survey"];
        [self.collectionView reloadData];
    } serverErrorBlock:^(id result) {
        MCOLog(@"问卷失败 result = %@",result);
    } failBlock:^{
        MCOLog(@"--------服务器错误----------");
    }];
    
}

-(void)initView{
    
    UIView *titleView = [[UIView alloc] init];
    
    UITextView *textView = [[UITextView alloc] init];
    [textView setText:[publicMath getLocalString:@"surveyItem"]];
    [textView setFont:[UIFont systemFontOfSize:18]];
    [textView sizeToFit];
    
    if (ScreenWidth > ScreenHeight) {
        //水平
        self.itemWidth = ScreenWidth - 16;
        titleView.frame = CGRectMake(0, 0, ScreenWidth, 64);
        
        textView.frame = CGRectMake((titleView.frame.size.width - textView.frame.size.width)/2, (titleView.frame.size.height-textView.frame.size.height-13), textView.frame.size.width, textView.frame.size.height);
    }else{
        //垂直
        
        self.itemWidth = ScreenWidth -40;
        
        //垂直
        if([publicMath isIPhoneNotchScreen]){
            //刘海
            titleView.frame = CGRectMake(0, 0, ScreenWidth, 88);
            textView.frame = CGRectMake((titleView.frame.size.width - textView.frame.size.width)/2, (titleView.frame.size.height-textView.frame.size.height-13), textView.frame.size.width, textView.frame.size.height);
        }else{
            //非刘海屏
            titleView.frame = CGRectMake(0, 0, ScreenWidth, 68);
            textView.frame = CGRectMake((titleView.frame.size.width - textView.frame.size.width)/2, (titleView.frame.size.height-textView.frame.size.height)/2, textView.frame.size.width, textView.frame.size.height);
        }
    }
    
    self.bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.bgView.backgroundColor = [UIColor colorWithHexString:MCO_Background_Color];
    
    [titleView setBackgroundColor:[UIColor whiteColor]];
    
    self.backBtn.frame = CGRectMake(30,(textView.frame.origin.y+12), 30, 30);
    [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 10, 3, 10)];
    [self.backBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:textView];
    [titleView addSubview:self.backBtn];
    [self.bgView addSubview:titleView];
    
    UITextView *tipText = [[UITextView alloc] init];
    [tipText setBackgroundColor:[UIColor clearColor]];
    [tipText setText:[publicMath getLocalString:@"surveyCompleteTip"]];
    [tipText setFont:[UIFont systemFontOfSize:12]];
    [tipText setTextColor:[UIColor colorWithHexString:MCO_Survey_Tip_Color]];
    [tipText sizeToFit];
    tipText.frame = CGRectMake((ScreenWidth-tipText.frame.size.width)/2, titleView.frame.size.height+8, tipText.frame.size.width, tipText.frame.size.height);
    [self.bgView addSubview:tipText];
    
    self.collectionView.frame = CGRectMake( 0 , tipText.frame.size.height + tipText.frame.origin.y + 8,  ScreenWidth, ScreenHeight - (tipText.frame.size.height + tipText.frame.origin.y + 8));
    
    [self.bgView addSubview:self.collectionView];
    
    [self.view addSubview:self.bgView];
    
    [self.collectionView reloadData];
}

-(UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        //自动网格布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout invalidateLayout];
        //设置单元格大小
        flowLayout.itemSize = CGSizeMake(self.itemWidth, 204);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 1;
        //设置UICollectionView滑动方向
//        flowLayout.scrollDirection = UICollectionViewScrollPositionNone;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.footerReferenceSize = CGSizeMake(ScreenWidth, 44);
        //网格布局
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 77, ScreenWidth, ScreenHeight-77) collectionViewLayout:flowLayout];
        [self.collectionView setBackgroundColor:[UIColor colorWithHexString:MCO_Background_Color]];
        //注册cell
//        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:scIdentifier];
        [self.collectionView registerClass:[SurveyCellVC class] forCellWithReuseIdentifier:scIdentifier];
        //页脚按钮
//        [self.collectionView registerClass:[CenterFooterVC class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        //设置代理源
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
    }
    
    return _collectionView;

}

/**
 页脚按钮
 */
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
//    UICollectionReusableView *reusableView = nil;
//    if (kind == UICollectionElementKindSectionFooter) {
//        CenterFooterVC *centerFooterVC = (CenterFooterVC *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
//        [centerFooterVC.titleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [centerFooterVC.titleBtn setTitle:[publicMath getLocalString:@"completeRecord"] forState:UIControlStateNormal];
//        [centerFooterVC.titleBtn addTarget:self action:@selector(completePress) forControlEvents:UIControlEventTouchUpInside];
//        reusableView = centerFooterVC;
//    }
//    return reusableView;
//}

-(void)completePress{
    MCOLog(@"survey complete");
    NSDictionary *dic = @{
        @"role_id":self.roleId,
        @"uuid":[MCOOSSDKCenter MCOShareSDK].saveUUID
    };
    [HttpRequest POSTRequestWithUrlString:MCO_Get_History_Surveys isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
        MCOLog(@"历史问卷访问成功：%@",result);
        HistorySurveyVC *historyVC = [[HistorySurveyVC alloc] init];
        historyVC.surveyArr = result[@"data"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:historyVC];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:NO completion:nil];
    } serverErrorBlock:^(id result) {
        MCOLog(@"历史问卷访问失败：%@",result);
        if([result[@"error"] intValue]==2){
            NoSurveyVC *noSurveyVC = [[NoSurveyVC alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:noSurveyVC ];
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:nav animated:NO completion:nil];
        }
    } failBlock:^{
        MCOLog(@"历史问卷访问失败");
    }];
}

//设置分组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

/**
 每个分组有多少个item
 */
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.surveyArr.count;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.surveyArr[indexPath.row];
    if (dic == nil ) {
        return CGSizeMake(self.itemWidth, 204);
    }
    
    NSArray *gift_arr = [dic objectForKey:@"gift_content"];
    
    if (ScreenWidth > ScreenHeight) {
        //水平
        if ([gift_arr count] > 4) {
            return CGSizeMake(self.itemWidth, 202);
        }else{
            return CGSizeMake(self.itemWidth, 128);
        }
    }else{
        //竖直
        if ([gift_arr count] > 4) {
            return CGSizeMake(self.itemWidth, 304);
        }else{
            return CGSizeMake(self.itemWidth, 204);
        }
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //根据identifier从缓冲池里去出cell
    SurveyCellVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:scIdentifier forIndexPath:indexPath];
    
    for (UIView *cellView in cell.subviews) {
        [cellView removeFromSuperview];
    }
    
    NSDictionary *dic = self.surveyArr[indexPath.row];
    if (dic == nil ) {
        return cell;
    }
    [cell displayCellView:dic];
    
    return cell;
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backBtn setImage:[UIImage imageNamed:MCO_Black_Back] forState:UIControlStateNormal];
        
    }
    return _backBtn;
}

-(void)backPress{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end

