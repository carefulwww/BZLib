//
//  CommunityCenterVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/2/7.
//

#import "CommunityCenterVC.h"

@implementation CommunityCenterVC

-(void)viewDidLoad{
    
    [super viewDidLoad];

    [self initView];
    
}

-(void)initView{
    
    BOOL isBigDisplay = [self logoDisplay];
    
    if (ScreenWidth > ScreenHeight) {
        //水平布局
        if (isBigDisplay) {
            
            self.bgView.frame = CGRectMake((ScreenWidth-346)/2, (ScreenHeight-204)/2, 346, 204);
            
        }else{
            
            self.bgView.frame = CGRectMake((ScreenWidth-346)/2, (ScreenHeight-138)/2, 346, 138);
            
        }
        
        self.thirdLoginView.frame = CGRectMake(37, 62, self.thirdLoginView.frame.size.width, self.thirdLoginView.frame.size.height);
    }else{
        //竖直布局
        if (isBigDisplay) {
            
            self.bgView.frame = CGRectMake((ScreenWidth-303)/2, (ScreenHeight-220)/2, 303, 220);
            
        }else{
            
            self.bgView.frame = CGRectMake((ScreenWidth-303)/2, (ScreenHeight-143)/2, 303, 143);
        
        }
        
        //横线
        self.thirdLoginView.frame = CGRectMake(16, 73, self.thirdLoginView.frame.size.width, self.thirdLoginView.frame.size.height);
    }
    
    [self.titleLabel setText:[publicMath getLocalString:@"gameCenter"]];
    self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-200)/2, 16, 200, 25);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.titleLabel];
    
    [self.closeBtn addTarget:self action:@selector(closePress) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.closeBtn];
    
    [self.bgView addSubview:self.thirdLoginView];
    
    [self.view addSubview:self.bgView];
    
}

-(void)closePress{
    MCOLog(@"关闭界面");
    [self dismissViewControllerAnimated:NO completion:nil];
    
}


//游戏图标顺序排位
-(BOOL)logoDisplay{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSArray *communityArr = [user objectForKey:@"game_community"];
    
    if (communityArr.count < 1) {
        return NO;
    }
    
    if (communityArr.count < 4) {
        //app数量小等于4，一行显示
        [self displayBtn1:communityArr];
        return NO;
    }else{
        //app数量大于4，两行显示
        [self displayBtn2:communityArr];
        return YES;
    }
    
    
    
}

//三个以内
-(void)displayBtn1:(NSArray *)communityArr{
    
    CGFloat width = 53*communityArr.count+20*(communityArr.count-1);
    
    self.thirdLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 52)];
    
    self.btnArr = [NSMutableArray array];
    
    for (int i = 0; i < communityArr.count; i++) {
        AppBtn *appBtn = [AppBtn buttonWithType:UIButtonTypeCustom];
        AppBtnModel *app = [[AppBtnModel alloc] initWithShowInfor:communityArr[i]];
        if ([app.open isEqualToString:@"1"]) {
            NSString *appName = app.name.lowercaseString;
            NSString *imageName;
            imageName = [NSString stringWithFormat:@"%@%@%@",@"MCOResource.bundle/",appName,@"_icon"];
            
            UIImage *btnImg = [UIImage imageNamed:imageName];
            
            CGFloat x = (53+20)*i;
            appBtn.frame = CGRectMake(x, 0, 53, 54);
            
            [appBtn setImage:btnImg forState:UIControlStateNormal];
            [appBtn setTitle:[self firstWord:appName] forState:UIControlStateNormal];
            [appBtn setTitleColor:[UIColor colorWithHexString:MCO_Grey_Color] forState:UIControlStateNormal];
            appBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            
            appBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            //top, left, bottom, right
            [appBtn setTitleEdgeInsets:UIEdgeInsetsMake(appBtn.imageView.frame.size.height, -appBtn.imageView.frame.size.width, 0, 0)];
            //top, left, bottom, right
            [appBtn setImageEdgeInsets:UIEdgeInsetsMake(-(appBtn.frame.size.height-appBtn.imageView.frame.size.height), (appBtn.frame.size.width-appBtn.imageView.frame.size.width)/2, 0, 0)];
        
//            appBtn.appId = app.appid;
            appBtn.url = app.url;
            appBtn.appName = app.name;
//            appBtn.type = app.type;
            [self.btnArr addObject:appBtn];
            [appBtn addTarget:self action:@selector(appBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            [self.thirdLoginView addSubview:appBtn];
        }
    }
}

//4个以上
-(void)displayBtn2:(NSArray *)communityArr{
    
    CGFloat width = 53*3+20*(3-1);
    CGFloat height = 52*2+15;
    
    self.thirdLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    self.btnArr = [NSMutableArray array];
    
    for (int i = 0; i < 4; i++) {
        AppBtn *appBtn = [AppBtn buttonWithType:UIButtonTypeCustom];
        AppBtnModel *app = [[AppBtnModel alloc] initWithShowInfor:communityArr[i]];
        if ([app.open isEqualToString:@"1"]) {
            NSString *appName = app.name.lowercaseString;
            NSString *imageName;
            imageName = [NSString stringWithFormat:@"%@%@%@",@"MCOResource.bundle/",appName,@"_icon"];
            
            UIImage *btnImg = [UIImage imageNamed:imageName];
            
            CGFloat x = (53+20)*i;
            appBtn.frame = CGRectMake(x, 0, 53, 54);
            
            [appBtn setImage:btnImg forState:UIControlStateNormal];
            [appBtn setTitle:[self firstWord:appName] forState:UIControlStateNormal];
            [appBtn setTitleColor:[UIColor colorWithHexString:MCO_Grey_Color] forState:UIControlStateNormal];
            appBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            
            appBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            //top, left, bottom, right
            [appBtn setTitleEdgeInsets:UIEdgeInsetsMake(appBtn.imageView.frame.size.height, -appBtn.imageView.frame.size.width, 0, 0)];
            //top, left, bottom, right
            [appBtn setImageEdgeInsets:UIEdgeInsetsMake(-(appBtn.frame.size.height-appBtn.imageView.frame.size.height), (appBtn.frame.size.width-appBtn.imageView.frame.size.width)/2, 0, 0)];
        
//            appBtn.appId = app.appid;
            appBtn.url = app.url;
            appBtn.appName = app.name;
//            appBtn.type = app.type;
            [self.btnArr addObject:appBtn];
            [appBtn addTarget:self action:@selector(appBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            [self.thirdLoginView addSubview:appBtn];
        }
    }
    
    for (int i = 4; i < communityArr.count; i++) {
        AppBtn *appBtn = [AppBtn buttonWithType:UIButtonTypeCustom];
        AppBtnModel *app = [[AppBtnModel alloc] initWithShowInfor:communityArr[i]];
        if ([app.open isEqualToString:@"1"]) {
            NSString *appName = app.name.lowercaseString;
            NSString *imageName;
            imageName = [NSString stringWithFormat:@"%@%@%@",@"MCOResource.bundle/",appName,@"_icon"];
            
            UIImage *btnImg = [UIImage imageNamed:imageName];
            
            CGFloat x = (53+20)*(i-4);
            appBtn.frame = CGRectMake(x, 54+15, 53, 54);
            
            [appBtn setImage:btnImg forState:UIControlStateNormal];
            [appBtn setTitle:[self firstWord:appName] forState:UIControlStateNormal];
            [appBtn setTitleColor:[UIColor colorWithHexString:MCO_Grey_Color] forState:UIControlStateNormal];
            appBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            
            appBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            //top, left, bottom, right
            [appBtn setTitleEdgeInsets:UIEdgeInsetsMake(appBtn.imageView.frame.size.height, -appBtn.imageView.frame.size.width, 0, 0)];
            //top, left, bottom, right
            [appBtn setImageEdgeInsets:UIEdgeInsetsMake(-(appBtn.frame.size.height-appBtn.imageView.frame.size.height), (appBtn.frame.size.width-appBtn.imageView.frame.size.width)/2, 0, 0)];
        
//            appBtn.appId = app.appid;
            appBtn.appName = app.name;
            appBtn.url = app.url;
//            appBtn.type = app.type;
            [self.btnArr addObject:appBtn];
            [appBtn addTarget:self action:@selector(appBtnPress:) forControlEvents:UIControlEventTouchUpInside];
            [self.thirdLoginView addSubview:appBtn];
        }
    }
}



-(void)appBtnPress:(AppBtn *)btn{
    MCOLog(@"社区app");
    
    /**
        判断是否为plug社区
     */
    NSString *url = btn.url;
    if (![publicMath isBlankString:url]) {
        MCOLog(@"url不可以为空");
        return;
    }
    
    GameCenterVC *gameCenterVC = [[GameCenterVC alloc] init];
    gameCenterVC.url = url;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:gameCenterVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:NO completion:nil];
    
    [[MCOOSSDKCenter MCOShareSDK] clickCommunityBack:btn.appName];
}

-(NSString *)firstWord:(NSString *)name{
    NSString *resultString = @"";
    if (name.length > 0) {
        resultString = [name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[name substringToIndex:1] capitalizedString]];
    }
    return resultString;
}

@end
