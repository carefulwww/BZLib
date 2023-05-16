//
//  HistorySurveyVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/11/17.
//

#import "HistorySurveyVC.h"

@implementation HistorySurveyVC

-(void)viewDidLoad{

    [super viewDidLoad];
    
    [self initView];
    
}

-(void)initView{
    
    self.navigationItem.leftBarButtonItem = self.navBackBtn;
    self.navigationItem.title = [publicMath getLocalString:@"surveyItem"];
    
    if (ScreenWidth > ScreenHeight) {
        //水平
        self.itemWidth = ScreenWidth - 16;
        
    }else{
        //垂直
        self.itemWidth = ScreenWidth -40;
    }
    
    self.bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.bgView.backgroundColor = [UIColor colorWithHexString:MCO_Background_Color];
 
    self.collectionView.frame = CGRectMake( 0 , 80,  ScreenWidth, ScreenHeight);
    
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
        [self.collectionView registerClass:[HistorySurveyCell class] forCellWithReuseIdentifier:historyIdentifier];
        //设置代理源
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
    }
    
    return _collectionView;

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
    HistorySurveyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:historyIdentifier forIndexPath:indexPath];
    
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

-(UIBarButtonItem *)navBackBtn{
    if (!_navBackBtn) {
        self.navBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:MCO_Back] style:UIBarButtonItemStylePlain target:self action:@selector(backPress)];
    }
    return _navBackBtn;
}

-(void)backPress{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end


