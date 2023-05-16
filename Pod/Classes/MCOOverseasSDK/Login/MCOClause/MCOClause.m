//
//  MCOClause.m
//  MCOOverseasProject
//

#import "MCOClause.h"

@implementation MCOClause

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self initView];
    
}

-(void)initView{
    
    if (ScreenWidth > ScreenHeight) {
        //水平布局
        self.bgView.frame = CGRectMake((ScreenWidth-346)/2, (ScreenHeight-248)/2, 346, 248);
        
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-298)/2, 36, 298, 144)];
        
        self.agreenBtn.frame = CGRectMake((self.bgView.frame.size.width-298)/2, 194, 298, 36);
        
    }else{
        //竖版
        self.bgView.frame = CGRectMake((ScreenWidth-303)/2, (ScreenHeight-314)/2, 303, 314);
        
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-271)/2, 36, 271, 202)];
        
        self.agreenBtn.frame = CGRectMake((self.bgView.frame.size.width-271)/2, 254, 271, 36);
        
    }
    [self.titleLabel setText:[publicMath getLocalString:@"ruleTitle"]];
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width - self.titleLabel.frame.size.width)/2, 10, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    
    [self setWebView];
    
    [self.closeBtn addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.closeBtn];
    [self.bgView addSubview:self.titleLabel];
    
    [self.bgView addSubview:self.agreenBtn];
    
    [self.bgView addSubview:self.webView];
    
    [self.view addSubview:self.bgView];
    
}

-(void)closeWindow{
    MCOLog(@"关闭窗口");
    [self dismissViewControllerAnimated:NO completion:^{
        DisagreenTipVC *tipVC = [[DisagreenTipVC alloc] init];
        tipVC.dic = self.dic;
        tipVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        tipVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        UIViewController *newTop = [MCOOSSDKCenter currentViewController];
        [newTop presentViewController:tipVC animated:NO completion:nil];
    }];
    
}

-(void)setWebView{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *pathUrl = [user objectForKey:@"user_policy"];
    
    NSURL *url = [[NSURL alloc] initWithString:pathUrl];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    
    if (ScreenWidth > ScreenHeight) {
        //水平布局
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-298)/2, 36, 298, 144)];
    }else{
        //竖版
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-271)/2, 36, 271, 202)];
    }
    
    
    self.webView.scrollView.bounces = NO;
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.webView loadRequest:request];
}

-(void)dealloc{
    self.webView.navigationDelegate = nil;
    [self.webView setUIDelegate:nil];
}


-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    MCOLog(@"didStartProvisionalNavigation");
}

-(void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    MCOLog(@"didCommitNavigation");
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    MCOLog(@"didFinishNavigation");
}



-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    MCOLog(@"webViewWebContentProcessDidTerminate %@",webView);
}



-(UIButton *)agreenBtn{
    
    if (!_agreenBtn) {
        self.agreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.agreenBtn.layer.cornerRadius = 4;
        [self.agreenBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Main_Theme_Color]];
        [self.agreenBtn setTitle:[publicMath getLocalString:@"agreen"] forState:UIControlStateNormal];
        [self.agreenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.agreenBtn addTarget:self action:@selector(agreenPress) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _agreenBtn;
}

-(void)agreenPress{
    MCOLog(@"同意");
    [self dismissViewControllerAnimated:NO completion:^{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:@(1) forKey:@"isOpenPolicy"];
        [user synchronize];
        
//        [[MCOOSSDKCenter MCOShareSDK] touristLogin];
        [[MCOOSSDKCenter MCOShareSDK] initSuccess:self.dic];
        //回调
        [[MCOOSSDKCenter MCOShareSDK] clauseClickBtnBack];
    }];
}

@end
