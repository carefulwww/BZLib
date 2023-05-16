//
//  ShowPicCode.m
//  MCODomesticProject
//
//  Created by 王都都 on 2022/7/19.
//

#import "ShowPicCode.h"

@implementation ShowPicCode

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWeb];
}

-(void)setWeb{
    
    //js配置
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    //需要js调用ios原生方法
    [userContentController addScriptMessageHandler:self name:@"getData"];
    [userContentController addScriptMessageHandler:self name:@"cancelData"];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    
    configuration.selectionGranularity = WKSelectionGranularityCharacter;
    
    self.bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    NSURL *url = [[NSURL alloc] initWithString:self.pathUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) configuration:configuration];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:self.webView];
    [self.webView setOpaque:NO];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.backgroundColor = [UIColor clearColor];
    
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.webView loadRequest:request];

    [self.view addSubview:self.bgView];
    
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    MCOLog(@"方法名称：%@",message.name);
    MCOLog(@"参数：%@",message.body);
    if ([message.name isEqualToString:@"getData"]) {
        NSData *data = [message.body dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [self.navigationController popViewControllerAnimated:NO];
        
        if(self.type == 1){
            //第一次获取code
            NSNotification *notification = [NSNotification notificationWithName:@"checkCodeSucBack" object:nil userInfo:dic];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else{
            NSNotification *notification = [NSNotification notificationWithName:@"retryCheckCodeSucBack" object:nil userInfo:dic];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        
    }else if([message.name isEqualToString:@"cancelData"]){
        NSDictionary *dic = (NSDictionary *)message.body;
        MCOLog(@"cancelData dic = %@",dic);
        [self.navigationController popViewControllerAnimated:NO];
        
        if(self.type == 1){
            //第一次获取code
            NSNotification *notification = [NSNotification notificationWithName:@"checkCodeFailBack" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else{
            NSNotification *notification = [NSNotification notificationWithName:@"retryCheckCodeFailBack" object:nil userInfo:dic];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
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


-(void)toBack{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        MCOLog(@"关闭webView");
        [self closeView];
    }
}

//关闭SDK
-(void)closeView{
    NSNotification *notification =[NSNotification notificationWithName:@"backPressSuc" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)dealloc{
    
    self.webView.navigationDelegate = nil;
    [self.webView setUIDelegate:nil];
}

@end
