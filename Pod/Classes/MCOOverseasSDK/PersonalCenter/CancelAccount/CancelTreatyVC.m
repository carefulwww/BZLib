//
//  CancelTreatyVC.m
//  MCOOverseasProject
//

#import "CancelTreatyVC.h"

@implementation CancelTreatyVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePress) name:@"cancelBack" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteUserBack:) name:@"deleteUserBack" object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelBack" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteUserBack" object:nil];
}

-(void)deleteUserBack:(NSNotification *)notification{
    
    [self dismissViewControllerAnimated:NO completion:^{
        NSDictionary *backInfo = [notification userInfo];
        int nowStamp = [[GetDeviceData getTimeStp] intValue];
        int timeStamp = [backInfo[@"timeStamp"] intValue];
        int day = [backInfo[@"day"] intValue];
        int count = (timeStamp+day*24*60*60)-nowStamp;
        NSDictionary *dic = @{
            @"count":@(count)
        };
        NSNotification *notification =[NSNotification notificationWithName:@"countDownBack" object:nil userInfo:dic];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }];
}

-(void)initView{
    self.bgView.frame = CGRectMake((ScreenWidth-304)/2, (ScreenHeight-346)/2, 304, 346);
    
    self.titleLabel.text = [publicMath getLocalString:@"cancelAccountItem"];
    self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-200)/2, 16, 200, 25);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.closeBtn addTarget:self action:@selector(closePress) forControlEvents:UIControlEventTouchUpInside];
    
    //账号注销协议
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *pathUrl = [user objectForKey:@"delete_user_policy"];
    NSURL *url = [[NSURL alloc] initWithString:pathUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-274)/2, 45, 274, 208)];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.webView loadRequest:request];
    
    self.checkBoxBtn.frame = CGRectMake(20-11, self.webView.frame.origin.y+self.webView.frame.size.height+6, 22, 22);
    self.checkBoxBtn.tag = 1;
    [self.checkBoxBtn addTarget:self action:@selector(checkPress) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 209,25)];
//    NSString *text = @"我已阅读并知晓《账号注销需知》";
    NSString *text = [publicMath getLocalString:@"treatyCheckTip"];
    [checkLabel setTextColor:[UIColor colorWithHexString:MCO_CheckTip_Gray]];
    [checkLabel setFont:[UIFont systemFontOfSize:11]];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setAlignment:NSTextAlignmentLeft];
    [paragraphStyle1 setLineSpacing:1];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
//    [checkLabel setAttributedTitle:attributedString1 forState:UIControlStateNormal];
    [checkLabel setAttributedText:attributedString1];
    checkLabel.numberOfLines = 0;
    [checkLabel sizeToFit];
    checkLabel.frame = CGRectMake(self.checkBoxBtn.frame.size.width+self.checkBoxBtn.frame.origin.x+4, self.checkBoxBtn.frame.origin.y-1, 209, checkLabel.frame.size.height);
    [self.bgView addSubview:checkLabel];
//    [checkLabel addTarget:self action:@selector(checkPress) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkPress)];
    [checkLabel addGestureRecognizer:labelTap];
    checkLabel.userInteractionEnabled = YES;
    
    [self.mcoCancelBtn setTitle:[publicMath getLocalString:@"cancel"] forState:UIControlStateNormal];
    self.mcoCancelBtn.frame = CGRectMake(36, self.webView.frame.origin.y+self.webView.frame.size.height+46, 107.5, 30.5);
    [self.mcoCancelBtn addTarget:self action:@selector(cancelPress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sureBtn setTitle:[publicMath getLocalString:@"sure"] forState:UIControlStateNormal];
    self.sureBtn.frame = CGRectMake((self.mcoCancelBtn.frame.size.width+self.mcoCancelBtn.frame.origin.x+12), self.mcoCancelBtn.frame.origin.y, 107.5, 30.5);
    [self.sureBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Btn_Gray]];
    self.sureBtn.enabled = NO;
    [self.sureBtn addTarget:self action:@selector(surePress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.closeBtn];
    
    [self.bgView addSubview:self.webView];
    
    [self.bgView addSubview:self.checkBoxBtn];
    [self.bgView addSubview:checkLabel];
    
    [self.bgView addSubview:self.mcoCancelBtn];
    [self.bgView addSubview:self.sureBtn];
    
    [self.view addSubview:self.bgView];
    
}

/* 2.页面开始加载 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    MCOLog(@"didStartProvisionalNavigation");
}
/* 开始返回内容 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    MCOLog(@"didCommitNavigation");
}
/* 页面加载完成 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    MCOLog(@"didFinishNavigation");
    [webView evaluateJavaScript:@"document.body.style.backgroundColor=\"#FFFFFF\"" completionHandler:nil];
}
/* 页面加载失败 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    MCOLog(@"didFailProvisionalNavigation");
}

/* 3.在收到响应后，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    MCOLog(@"decidePolicyForNavigationResponse");
    decisionHandler(WKNavigationResponsePolicyAllow);
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return NO;
}

-(void)closePress{
    MCOLog(@"关闭");
    //关闭界面
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)cancelPress{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)checkPress{
    MCOLog(@"check box");
    if (self.checkBoxBtn.tag == 1) {
        //未被选中==>被选中
        self.checkBoxBtn.tag = 2;
        [self.checkBoxBtn setImage:[UIImage imageNamed:MCO_Check_Btn_Image] forState:UIControlStateNormal];
        [self.sureBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Main_Theme_Color]];
        self.sureBtn.enabled = YES;
    }else{
        //被选中==>未被选中
        self.checkBoxBtn.tag = 1;
        [self.checkBoxBtn setImage:[UIImage imageNamed:MCO_UnCheck_Btn_Image] forState:UIControlStateNormal];
        [self.sureBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Btn_Gray]];
        self.sureBtn.enabled = NO;
    }
}

-(void)surePress{
    //校验身份证
    NSDictionary *dic = @{
        @"uuid":[MCOOSSDKCenter MCOShareSDK].saveUUID
    };
    [HttpRequest POSTRequestWithUrlString:MCO_Get_Role_Info isPay:NO headerDic:nil parameters:dic successBlock:^(id result) {
        CancelUserDetailVC *userDetailVC = [[CancelUserDetailVC alloc] init];
        NSArray *roleArr = result[@"data"][@"role_info"];
        userDetailVC.userDetailArr = roleArr;
        [self.navigationController pushViewController:userDetailVC animated:NO];
    } serverErrorBlock:^(id result) {
        MCOLog(@"获取用户信息失败");
        [publicMath MCOHub:[publicMath getLocalString:@"netError"] messageView:[MCOOSSDKCenter currentViewController].view];
    } failBlock:^{
        [publicMath MCOHub:[publicMath getLocalString:@"netError"] messageView:[MCOOSSDKCenter currentViewController].view];
    }];
    
}
@end
