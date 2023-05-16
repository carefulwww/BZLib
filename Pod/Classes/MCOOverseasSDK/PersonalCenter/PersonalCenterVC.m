//
//  PersonalCenterVC.m
//  MCOOverseasProject
//

#import "PersonalCenterVC.h"

@implementation PersonalCenterVC 

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self getDeleteCountDownTime];
    
//    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindThirdLoginSuc:) name:@"bindThirdLoginSuc" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueBind) name:@"continueBind" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueBind) name:@"backPressSuc" object:nil];
    
    /**
     注销返回跳转
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownBack:) name:@"countDownBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelDeleteBack) name:@"cancelDeleteBack" object:nil];
    
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bindThirdLoginSuc" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"continueBind" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backPressSuc" object:nil];
    
    /**
     注销
     */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"countDownBack" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelDeleteBack" object:nil];
    if (_countdownTimer) {
        dispatch_source_cancel(_countdownTimer);
        _countdownTimer = nil;
    }
}

-(void)bindThirdLoginSuc:(NSNotification *)notification{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *nickName = [user objectForKey:@"displayName"];
    int third_login_type = [[user objectForKey:@"third_login_type"] intValue];
    
    NSString *text;
    if (third_login_type == 0) {
        //游客账号：MVFN;
        [self.userFace setImage:[UIImage imageNamed:MCO_User_Red]];
        text = [NSString stringWithFormat:@"MVFN：%@",nickName];
//        [self.userNameLabel setText:[NSString stringWithFormat:@"MVFN：%@",nickName]];
    }else if(third_login_type == 1){
        //谷歌：GOGL;
//        [self.userNameLabel setText:[NSString stringWithFormat:@"GOGL：%@",nickName]];
        [self.userFace setImage:[UIImage imageNamed:MCO_Google_Face]];
        text = [NSString stringWithFormat:@"GOGL：%@",nickName];
    }else if(third_login_type == 2){
        //Facebook:FCBK;
//        [self.userNameLabel setText:[NSString stringWithFormat:@"FCBK：%@",nickName]];
        [self.userFace setImage:[UIImage imageNamed:MCO_Facebook_Face]];
        text = [NSString stringWithFormat:@"FCBK：%@",nickName];
    }else if (third_login_type == 3){
        //苹果账号：APGC;
//        [self.userNameLabel setText:[NSString stringWithFormat:@"APFC：%@",nickName]];
        [self.userFace setImage:[UIImage imageNamed:MCO_Apple_Face]];
        text = [NSString stringWithFormat:@"APFC：%@",nickName];
    }else if(third_login_type == 6){
        //邮箱账号 Email
        [self.userFace setImage:[UIImage imageNamed:MCO_Email_Face]];
        text = [NSString stringWithFormat:@"Email：%@",nickName];
    }
    
    [self setUserNameLabelCopyBtn:text];
    [self.userFace reloadInputViews];
    [self.userNameLabel reloadInputViews];
    
    NSDictionary *backInfo = [notification userInfo];
    BOOL isChangeAccoutn = [backInfo[@"isOldAccount"] boolValue];
    
    if (isChangeAccoutn) {
        [self changeSameAccountTip];
    }else{
        [self backPress];
    }
    
    [self.collectionView reloadData];
}

-(void)backPressSuc{
    [self backPress];
}

-(void)continueBind{
    [self changeAccount];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *nickName = [user objectForKey:@"displayName"];
    int third_login_type = [[user objectForKey:@"third_login_type"] intValue];
    
    
    NSString *text;
    if (third_login_type == 0) {
        //游客账号：MVFN
        [self.userFace setImage:[UIImage imageNamed:MCO_User_Red]];
//        [self.userNameLabel setText:[NSString stringWithFormat:@"MVFN：%@",nickName]];
        text = [NSString stringWithFormat:@"MVFN：%@",nickName];
    }else if(third_login_type == 1){
        //谷歌：GOGL;
        [self.userFace setImage:[UIImage imageNamed:MCO_Google_Face]];
//        [self.userNameLabel setText:[NSString stringWithFormat:@"GOGL：%@",nickName]];
        text = [NSString stringWithFormat:@"GOGL：%@",nickName];
    }else if(third_login_type == 2){
        //Facebook:FCBK
        [self.userFace setImage:[UIImage imageNamed:MCO_Facebook_Face]];
//        [self.userNameLabel setText:[NSString stringWithFormat:@"FCBK：%@",nickName]];
        text = [NSString stringWithFormat:@"FCBK：%@",nickName];
    }else if (third_login_type == 3){
        //苹果账号：APGC
        [self.userFace setImage:[UIImage imageNamed:MCO_Apple_Face]];
//        [self.userNameLabel setText:[NSString stringWithFormat:@"APFC：%@",nickName]];
        text = [NSString stringWithFormat:@"APFC：%@",nickName];
    }else if(third_login_type == 6){
        //邮箱账号 Email
        [self.userFace setImage:[UIImage imageNamed:MCO_Email_Face]];
        text = [NSString stringWithFormat:@"Email：%@",nickName];
    }
    
    [self setUserNameLabelCopyBtn:text];
    
}

-(void)setUserNameLabelCopyBtn:(NSString *)text{
    
    //初始化
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    //图片
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:MCO_Fuzhi];
    
    attachment.bounds = CGRectMake(10, 0, 14, 14);

    NSAttributedString *imageAttachment = [NSAttributedString attributedStringWithAttachment:attachment];
    
    [attributedString appendAttributedString:imageAttachment];
    
    [self.userNameLabel setAttributedText:attributedString];
    
}

-(UIButton *)backBtn{
    if (!_backBtn) {
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _backBtn;
}

-(UIImageView *)userFace{
    if (!_userFace) {
        self.userFace = [[UIImageView alloc] init];
//        self.userFace.frame = CGRectMake(27, self.backBtn.frame.size.height+self.backBtn.frame.origin.y+28, 42, 42);
    }
    return _userFace;
}

-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
//        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.userFace.frame.origin.x+self.userFace.frame.size.width+15, (self.userFace.frame.origin.y+self.userFace.frame.size.height/2)-11, 300, 30)];
        self.userNameLabel = [[UILabel alloc] init];
        [self.userNameLabel setFont:[UIFont systemFontOfSize:16]];
        [self.userNameLabel setTextColor:[UIColor whiteColor]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copyUserName)];
        [self.userNameLabel addGestureRecognizer:tapGesture];
        self.userNameLabel.userInteractionEnabled = YES;
    }
    return _userNameLabel;
}

-(void)copyUserName{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [user objectForKey:@"displayName"];
    NSString *tip = [publicMath getLocalString:@"copyUserNameSuc"];
    [publicMath MCOHub:tip messageView:self.view];
}

-(void)changeLayout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout invalidateLayout];
    //设置单元格大小
    flowLayout.itemSize = CGSizeMake(self.itemWidth, 56);
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    //设置UICollectionView滑动方向
    flowLayout.scrollDirection = UICollectionViewScrollPositionNone;
    self.collectionView.collectionViewLayout = flowLayout;
//    self.collectionView.frame = CGRectMake(0, self.bgImage.frame.size.height, ScreenWidth, ScreenHeight-self.bgImage.frame.size.height);
    self.collectionView.frame = CGRectMake(0, self.bgImage.frame.size.height, ScreenWidth, ScreenHeight-self.bgImage.frame.size.height);
}

-(void)initView{
    self.bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.backBtn setImage:[UIImage imageNamed:MCO_Back] forState:UIControlStateNormal];
    
    if (ScreenWidth > ScreenHeight) {
        //水平布局
        self.bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MCOResource.bundle/person_center_bg_horizon"]];
        self.bgImage.frame = CGRectMake(0, 0, ScreenWidth, 146);
//        self.backBtn.frame = CGRectMake(20, 16, 9, 14);
        self.backBtn.frame = CGRectMake(30, 16, 30, 30);
        [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 10, 3, 10)];
        self.userFace.frame = CGRectMake(57, self.backBtn.frame.size.height+self.backBtn.frame.origin.y+23, 42, 42);
        self.itemWidth = (self.bgView.frame.size.width/2)-1;
    }else{
        //竖直布局
        self.bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MCOResource.bundle/person_center_bg_horizon"]];
        self.bgImage.frame = CGRectMake(0, 0, ScreenWidth, 160);
//        backBtn.frame = CGRectMake(18, 36, 9, 14);
        self.backBtn.frame = CGRectMake(8, 28, 30, 30);
//        self.backBtn.layer.borderColor = [UIColor greenColor].CGColor;
//        self.backBtn.layer.borderWidth = 1;
        [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 10, 3, 10)];
        self.userFace.frame = CGRectMake(27, self.backBtn.frame.size.height+self.backBtn.frame.origin.y+28, 42, 42);
        self.itemWidth = self.bgView.frame.size.width;
    }
        
    [self.bgImage addSubview:self.userFace];
    
    if (self.company_entity == 1) {
        //mujoy
        self.logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MCO_App_Logo_White]];
    }else if(self.company_entity == 2){
        //nejoy
        self.logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MCO_Neojoy_Icon]];
    }else if(self.company_entity == 3){
        self.logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MCO_Metajoy_Icon]];
    }else if(self.company_entity == 4){
        self.logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MCO_Normalmove_Icon]];
    }else if(self.company_entity == 6){
        self.logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MCO_Neorigin_Icon]];
    }
    
//    self.logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MCO_App_Logo_White]];
    self.logoImage.frame = CGRectMake((ScreenWidth-64.5)/2, self.backBtn.frame.origin.y+10, 64.5, 22);
    [self.bgImage addSubview:self.logoImage];
    self.userNameLabel.frame = CGRectMake(self.userFace.frame.origin.x+self.userFace.frame.size.width+15, (self.userFace.frame.origin.y+self.userFace.frame.size.height/2)-11, 300, 30);
    [self.bgImage addSubview:self.userNameLabel];
    [self.backBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:self.collectionView];
    [self.bgView addSubview:self.bgImage];
    [self.bgView addSubview:self.backBtn];
    [self.bgView setBackgroundColor:[UIColor colorWithHexString:MCO_Background_Color]];
    
//    [self.bgView addSubview:self.userNameLabel];
    
    [self.view addSubview:self.bgView];
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        //自动网格布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout invalidateLayout];
//        CGFloat itemWidth = (self.bgView.frame.size.width/2)-1;
        //设置单元格大小
        flowLayout.itemSize = CGSizeMake(self.itemWidth, 56);
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 1;
        //设置UICollectionView滑动方向
        flowLayout.scrollDirection = UICollectionViewScrollPositionNone;
        //网格布局
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.bgImage.frame.size.height, ScreenWidth, ScreenHeight-self.bgImage.frame.size.height) collectionViewLayout:flowLayout];
        [self.collectionView setBackgroundColor:[UIColor colorWithHexString:MCO_Background_Color]];
        //注册cell
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
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
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSArray *game_community = [user objectForKey:@"game_community"];
    
    if(self.isShowSurvey){
        if ([game_community count] < 1) {
            return 5;
        }else{
            return 6;
        }
    }else{
        if ([game_community count] < 1) {
            return 4;
        }else{
            return 5;
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //根据identifier从缓冲池里去出cell
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    for (UIView *cellView in cell.subviews) {
        [cellView removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    if (ScreenWidth > ScreenHeight) {
        //水平布局
        imageView.frame = CGRectMake(44, 19, 18, 18);
    }else{
        //竖直布局
        imageView.frame = CGRectMake(20, 19, 18, 18);
    }
    
    
    UILabel *cellName = [[UILabel alloc] init];
    cellName.textColor = [UIColor colorWithHexString:MCO_Grey_Text];
    cellName.font = [UIFont systemFontOfSize:14];
    
    BOOL isCountDown = NO;
    UILabel *countDown = [[UILabel alloc] init];
    countDown.textColor = [UIColor colorWithHexString:MCO_CountDown_Gray];
    countDown.font = [UIFont systemFontOfSize:12];
    countDown.layer.borderColor = [UIColor redColor].CGColor;
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSArray *game_community = [user objectForKey:@"game_community"];
    NSArray *bind_third_login_type = [user objectForKey:@"bind_third_login_type"];
    
    BOOL isSurveyDot = NO;
    
    if(self.isShowSurvey){
        //问卷调查
        if ([game_community count] < 1) {
            switch (indexPath.item) {
                case 0:
                    //绑定账号
                    [imageView setImage:[UIImage imageNamed:MCO_User_Bind]];
                    [cellName setText:[publicMath getLocalString:@"bindAccountBtn"]];
                    break;
                case 1:
                    //切换用户
                    [imageView setImage:[UIImage imageNamed:MCO_User_Change]];
                    [cellName setText:[publicMath getLocalString:@"accountChangeBtn"]];
                    break;
                case 2:
                    //问卷
                    isSurveyDot = YES;
                    [imageView setImage:[UIImage imageNamed:MCO_WenJuan]];
                    [cellName setText:[publicMath getLocalString:@"surveyItem"]];
                    break;
                case 3:
                    //注销账号
                    [imageView setImage:[UIImage imageNamed:MCO_Cancel_Account_Image]];
                    [cellName setText:[publicMath getLocalString:@"cancelAccountItem"]];
                    isCountDown = YES;
                    break;
                case 4:
                    //相关条款
                    [imageView setImage:[UIImage imageNamed:MCO_Terms]];
                    [cellName setText:[publicMath getLocalString:@"relatedTerms"]];
                    break;
                default:
                    break;
            }
        }else{
            switch (indexPath.item) {
                case 0:
                    //绑定
                    [imageView setImage:[UIImage imageNamed:MCO_User_Bind]];
                    [cellName setText:[publicMath getLocalString:@"bindAccountBtn"]];
                    break;
                case 1:
                    //切换
                    [imageView setImage:[UIImage imageNamed:MCO_User_Change]];
                    [cellName setText:[publicMath getLocalString:@"accountChangeBtn"]];
                    break;
                case 2:
                    //社区
                    [imageView setImage:[UIImage imageNamed:MCO_Community_Center]];
                    [cellName setText:[publicMath getLocalString:@"gameCenter"]];
                    break;
                case 3:
                    //问卷
                    isSurveyDot = YES;
                    [imageView setImage:[UIImage imageNamed:MCO_WenJuan]];
                    [cellName setText:[publicMath getLocalString:@"surveyItem"]];
                    break;
                case 4:
                    //注销账号
                    [imageView setImage:[UIImage imageNamed:MCO_Cancel_Account_Image]];
                    [cellName setText:[publicMath getLocalString:@"cancelAccountItem"]];
                    isCountDown = YES;
                    break;
                case 5:
                    //相关条款
                    [imageView setImage:[UIImage imageNamed:MCO_Terms]];
                    [cellName setText:[publicMath getLocalString:@"relatedTerms"]];
                    break;
                default:
                    break;
                    
            }
            
        }
    }else{
        //不开启问卷调查
        if ([game_community count] < 1) {
            switch (indexPath.item) {
                case 0:
                    //绑定
                    [imageView setImage:[UIImage imageNamed:MCO_User_Bind]];
                    [cellName setText:[publicMath getLocalString:@"bindAccountBtn"]];
                    break;
                case 1:
                    //切换
                    [imageView setImage:[UIImage imageNamed:MCO_User_Change]];
                    [cellName setText:[publicMath getLocalString:@"accountChangeBtn"]];
                    break;
                case 2:
                    [imageView setImage:[UIImage imageNamed:MCO_Cancel_Account_Image]];
                    [cellName setText:[publicMath getLocalString:@"cancelAccountItem"]];
                    isCountDown = YES;
                    break;
                case 3:
                    //相关条款
                    [imageView setImage:[UIImage imageNamed:MCO_Terms]];
                    [cellName setText:[publicMath getLocalString:@"relatedTerms"]];
                    break;
                default:
                    break;
            }
        }else{
            switch (indexPath.item) {
                case 0:
                    //绑定
                    [imageView setImage:[UIImage imageNamed:MCO_User_Bind]];
                    [cellName setText:[publicMath getLocalString:@"bindAccountBtn"]];
                    break;
                case 1:
                    //切换
                    [imageView setImage:[UIImage imageNamed:MCO_User_Change]];
                    [cellName setText:[publicMath getLocalString:@"accountChangeBtn"]];
                    break;
                case 2:
                    //社区
                    [imageView setImage:[UIImage imageNamed:MCO_Community_Center]];
                    [cellName setText:[publicMath getLocalString:@"gameCenter"]];
                    break;
                case 3:
                    //注销
                    [imageView setImage:[UIImage imageNamed:MCO_Cancel_Account_Image]];
                    [cellName setText:[publicMath getLocalString:@"cancelAccountItem"]];
                    isCountDown = YES;
                    break;
                case 4:
                    //相关问卷
                    [imageView setImage:[UIImage imageNamed:MCO_Terms]];
                    [cellName setText:[publicMath getLocalString:@"relatedTerms"]];
                    break;
                default:
                    break;
                    
            }
            
        }
    }
    
        
    [cellName sizeToFit];
    cellName.frame = CGRectMake((imageView.frame.size.width+imageView.frame.origin.x+8), (cell.frame.size.height-cellName.frame.size.height)/2, cellName.frame.size.width, cellName.frame.size.height);
   
    [cell addSubview:imageView];
    [cell addSubview:cellName];
    
    if (self.isDeleteUser&&isCountDown) {
        isCountDown = NO;
        countDown.text = [NSString stringWithFormat:@"%@99:99:99",[publicMath getLocalString:@"deleteUserCountDown"]];
        [self resetCountdown:self.deleteUserTime timeTip:countDown];
        [countDown sizeToFit];
        countDown.frame = CGRectMake((cell.frame.size.width-countDown.frame.size.width-34), (cell.frame.size.height-countDown.frame.size.height)/2, countDown.frame.size.width, countDown.frame.size.height);
        [cell addSubview:countDown];
    }
    
    if(indexPath.item == 0){
        if ([bind_third_login_type count]<1) {
            //没有绑定
            UIButton *redDot = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            redDot.frame = CGRectMake(cellName.frame.origin.x+cellName.frame.size.width+2, cellName.frame.origin.y, 6, 6);
            redDot.layer.cornerRadius = 3;
            redDot.backgroundColor = [UIColor redColor];
            [cell addSubview:redDot];
        }
    }
    
    if (isSurveyDot) {
        isSurveyDot = NO;
        UIButton *redDot = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        redDot.frame = CGRectMake(cellName.frame.origin.x+cellName.frame.size.width+2, cellName.frame.origin.y, 6, 6);
        redDot.layer.cornerRadius = 3;
        redDot.backgroundColor = [UIColor redColor];
        [cell addSubview:redDot];
    }
    
    //go按钮
    UIButton *goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goBtn setImage:[UIImage imageNamed:MCO_Person_Go_Btn] forState:UIControlStateNormal];
    goBtn.frame = CGRectMake(cell.frame.size.width-16-11, (cell.frame.size.height-16)/2, 11, 16);
    [cell addSubview:goBtn];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}

/**
 item点击执行此代理方法
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSArray *game_community = [user objectForKey:@"game_community"];
    
    if(self.isShowSurvey){
        //开启问卷
        if ([game_community count] < 1) {
            switch (indexPath.item) {
                case 0:
                    //账号绑定
                    [self bindAccount];
                    break;
                case 1:
                    //账号切换
                    [self judgeTourist];
                    break;
                case 2:
                    //问卷
                    [self surveyCenter];
                    break;
                case 3:
                    //注销
                    [self cancelAccount];
                    break;
                case 4:
                    //相关条款
                    [self aboutTerms];
                    break;
                default:
                    break;
            }
        }else{
            switch (indexPath.item) {
                case 0:
                    //账号绑定
                    [self bindAccount];
                    break;
                case 1:
                    //账号切换
                    [self judgeTourist];
                    break;
                case 2:
                    //社区帐号
                    [self communityCenter];
                    break;
                case 3:
                    //问卷
                    [self surveyCenter];
                    break;
                case 4:
                    //账号注销
                    [self cancelAccount];
                    break;
                case 5:
                    //相关条款
                    [self aboutTerms];
                    break;
                default:
                    break;
            }
        }
        
        
    }else{
        //不开启问卷
        if ([game_community count] < 1) {
            switch (indexPath.item) {
                case 0:
                    //账号绑定
                    [self bindAccount];
                    break;
                case 1:
                    //账号切换
                    [self judgeTourist];
                    break;
                case 2:
                    //账号注销
                    [self cancelAccount];
                    break;
                case 3:
                    //相关条款
                    [self aboutTerms];
                    break;
                default:
                    break;
            }
        }else{
            switch (indexPath.item) {
                case 0:
                    //账号绑定
                    [self bindAccount];
                    break;
                case 1:
                    //账号切换
                    [self judgeTourist];
                    break;
                case 2:
                    //社区帐号
                    [self communityCenter];
                    break;
                case 3:
                    //账号注销
                    [self cancelAccount];
                    break;
                case 4:
                    //相关条款
                    [self aboutTerms];
                    break;
                default:
                    break;
            }
        }
    }
}

-(void)bindAccount{
//    MCOLog(@"账号绑定");
    BindAccountVC *bindAccountVC = [[BindAccountVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:bindAccountVC];
    nav.navigationBar.hidden = YES;
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nav.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    nav.interactivePopGestureRecognizer.enabled = NO;
    [self presentViewController:nav animated:NO completion:nil];
}

-(void)judgeTourist{
//    MCOLog(@"判断是否为游客账号");
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    int third_login_type = [[user objectForKey:@"third_login_type"] intValue];
    if (third_login_type == 0) {
        //游客提示
        TouristChangeAccountTipVC *changeAccountTip = [[TouristChangeAccountTipVC alloc] init];
        changeAccountTip.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        changeAccountTip.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:changeAccountTip animated:NO completion:nil];
    }else{
        //已经绑定过账号的
        [self changeAccount];
    }
}

-(void)changeAccount{
//    MCOLog(@"账号切换");
    ChangeAccountVC *changeAccountVC = [[ChangeAccountVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:changeAccountVC];
    nav.navigationBar.hidden = YES;
    nav.interactivePopGestureRecognizer.enabled = NO;
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nav.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self presentViewController:nav animated:NO completion:nil];
}

-(void)aboutTerms{
//    MCOLog(@"相关条款");
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *pathUrl = [user objectForKey:@"user_policy"];
    
    if([publicMath isBlankString:pathUrl]){
        RuleVC *ruleVC = [[RuleVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ruleVC];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:NO completion:nil];
    }else{
        [publicMath MCOHub:@"No Related Terms" messageView:self.view];
    }
}

//社区帐号
-(void)communityCenter{
//    MCOLog(@"社区帐号");
    CommunityCenterVC *communityCenterVC = [[CommunityCenterVC alloc] init];
    communityCenterVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    communityCenterVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:communityCenterVC animated:NO completion:nil];
}

//问卷界面
-(void)surveyCenter{
    
    MCOLog(@"问卷调研");
    NSDictionary *dic = @{
        @"role_id":[MCOOSSDKCenter MCOShareSDK].roleId,
        @"uuid":[MCOOSSDKCenter MCOShareSDK].saveUUID
    };
    [HttpRequest POSTRequestWithUrlString:MCO_Get_Surveys isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
        MCOLog(@"问卷成功 result = %@",result);
        SurveyCenter * surveyCenter = [[SurveyCenter alloc] init];
        surveyCenter.roleId = [MCOOSSDKCenter MCOShareSDK].roleId;
        surveyCenter.surveyArr = result[@"data"][@"survey"];
        surveyCenter.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:surveyCenter animated:NO completion:nil];
    } serverErrorBlock:^(id result) {
        MCOLog(@"问卷失败 result = %@",result);
    } failBlock:^{
        MCOLog(@"--------服务器错误----------");
    }];
    
}

-(void)backPress{
    
//    MCOLog(@"backpress personal");
    
    if (_countdownTimer) {
        dispatch_source_cancel(_countdownTimer);
        _countdownTimer = nil;
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)changeSameAccountTip{
    ChangeAccountTipVC *changeAccoutTipVC = [[ChangeAccountTipVC alloc] init];
    changeAccoutTipVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    changeAccoutTipVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:changeAccoutTipVC animated:NO completion:nil];
}

//账号注销
-(void)cancelAccount{
//    MCOLog(@"账号注销");
    if(self.isDeleteUser){
        CancelCountDown *countDownVC = [[CancelCountDown alloc] init];
        countDownVC.countDownTime = self.deleteUserTime;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:countDownVC];
        nav.navigationBar.hidden = YES;
        nav.interactivePopGestureRecognizer.enabled = NO;
        nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
        nav.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self presentViewController:nav animated:NO completion:nil];
    }else{
        CancelTreatyVC *cancelTreatyVC = [[CancelTreatyVC alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cancelTreatyVC];
        nav.navigationBar.hidden = YES;
        nav.interactivePopGestureRecognizer.enabled = NO;
        nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
        nav.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self presentViewController:nav animated:NO completion:nil];
    }
    
}

/**
 注销账号相关内容
 */
-(void)cancelDeleteBack{
    self.isDeleteUser = NO;
    self.deleteUserTime = 0;
    if (_countdownTimer) {
        dispatch_source_cancel(_countdownTimer);
        _countdownTimer = nil;
    }
    [self.collectionView reloadData];
}

-(void)countDownBack:(NSNotification *)notification{
    NSDictionary *backInfo = [notification userInfo];
    int count = [backInfo[@"count"] intValue];
//    MCOLog(@"删除用户返回,count = %d",count);
    self.isDeleteUser = YES;
    self.deleteUserTime = count;
    [self.collectionView reloadData];
}

-(void)resetCountdown:(int)count timeTip:(UILabel *)timeTip{
    [self cancelCountDownTimer];
//    NSInteger nowTime = [[GetDeviceData getTimeStp] intValue];;
//    NSInteger count = endTime - nowTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _countdownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    [self countDownWithTimer:_countdownTimer timeInterval:count complete:^{
        //完成操作
        [publicMath closeGame];
    } progress:^(int mHours, int mMinute, int mSecond) {
//        MCOLog(@"倒计时 : %d时 %d分 %d秒",mHours,mMinute,mSecond);
        NSString *timeStr = [NSString stringWithFormat:@"%@%02d:%02d:%02d ",[publicMath getLocalString:@"deleteUserCountDown"],mHours,mMinute,mSecond];
        timeTip.text = timeStr;
    }];
}

-(void)cancelCountDownTimer{
    if (_countdownTimer) {
        dispatch_source_cancel(_countdownTimer);
        _countdownTimer = nil;
    }
}

/**
 倒计时
 */
-(void)countDownWithTimer:(dispatch_source_t)timer timeInterval:(NSTimeInterval)timeInterval complete:(void(^)(void))completeBlock progress:(void(^)(int mHours, int mMinute, int mSecond))progressBlock{
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
                    self.deleteUserTime--;
                }
            });
            dispatch_resume(timer);
        }
    });
}

//获取注销时间
-(void)getDeleteCountDownTime{
    NSDictionary *dic = @{
        @"uuid":[MCOOSSDKCenter MCOShareSDK].saveUUID
    };
    [HttpRequest POSTRequestWithUrlString:MCO_Get_Cancel_Time isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
        MCOLog(@"获取账号注销时间成功，result = %@",result);
        int status = [result[@"data"][@"status"] intValue];
        if (status == 0) {
            //未注销
            self.isDeleteUser = NO;
        }else if (status == 1){
            //已注销
            self.isDeleteUser = YES;
            self.deleteUserTime = [result[@"data"][@"time"] intValue];
            if(self.deleteUserTime == 0){
                [publicMath closeGame];
            }
        }
        
        [self initView];
        
    } serverErrorBlock:^(id result) {
        self.isDeleteUser = NO;
        MCOLog(@"获取账号注销时间失败,result = %@",result);
        [self initView];
    } failBlock:^{
        self.isDeleteUser = NO;
        MCOLog(@"获取账号注销剩余时间 --- 网络错误");
        [self initView];
    }];
}

@end
