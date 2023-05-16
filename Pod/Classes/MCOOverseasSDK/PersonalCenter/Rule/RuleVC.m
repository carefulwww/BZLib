//
//  RuleVC.m
//  MCOOverseasProject
//
//

#import "RuleVC.h"

@implementation RuleVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setWeb];
    self.countGO = 0;
}

-(WKWebView *)webView{
    if (!_webView) {
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        self.webView.allowsBackForwardNavigationGestures = YES;
    }
    return _webView;
}

-(void)setWeb{
    //导航栏
    self.navigationController.navigationBarHidden = NO;
//    NSBundle *bundle = [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource: @"MCOResource" ofType: @"bundle"]];
    NSString *title = [publicMath getLocalString:@"ruleTitle"];
    self.navigationItem.title = [publicMath getLocalString:title];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *pathUrl = [user objectForKey:@"user_policy"];
    NSURL *url = [[NSURL alloc] initWithString:pathUrl];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [self.view addSubview:self.webView];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.webView loadRequest:request];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(title)];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"title"]&&object == self.webView) {
        self.navigationItem.title = self.webView.title;
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
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
    [self setNavBar];
}
/* 页面加载失败 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    MCOLog(@"didFailProvisionalNavigation");
}

/* 1.在发送请求之前，决定是否跳转 */
//-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    MCOLog(@"decidePolicyForNavigationAction");
//    [self setNavBar];
//    decisionHandler(WKNavigationActionPolicyAllow); // 必须实现 加载
//}


/* 3.在收到响应后，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    MCOLog(@"decidePolicyForNavigationResponse");
    decisionHandler(WKNavigationResponsePolicyAllow);
    [self setNavBar];
}

-(void)setNavBar{
    self.navigationItem.leftBarButtonItem = self.navBackBtn;
    if ([self.webView canGoBack]) {
//        self.navigationItem.rightBarButtonItem = self.navCloseBtn;
        self.countGO++;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
        self.countGO = 0;
    }
}

-(UIBarButtonItem *)navBackBtn{
    if (!_navBackBtn) {
        self.navBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:MCO_Back] style:UIBarButtonItemStylePlain target:self action:@selector(toBack)];
    }
    return _navBackBtn;
}

-(void)toBack{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        self.countGO--;
        if (self.countGO==0) {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }else{
        self.countGO = 0;
        MCOLog(@"关闭webView");
        [self closeView];
    }
}

//关闭SDK
-(void)closeView{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"title"];
    self.webView.navigationDelegate = nil;
    [self.webView setUIDelegate:nil];
}

@end
