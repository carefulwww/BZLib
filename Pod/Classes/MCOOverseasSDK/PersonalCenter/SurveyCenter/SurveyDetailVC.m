//
//  SurveyDetailVC.m
//  MCOOverseasProject
//
//

#import "SurveyDetailVC.h"

@implementation SurveyDetailVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWeb];
    self.countGO = 0;
}

-(void)setWeb{
    
    self.bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    UIView *titleView = [[UIView alloc] init];
    
    [titleView setBackgroundColor:[UIColor whiteColor]];
    UITextView *textView = [[UITextView alloc] init];
    [textView setText:[publicMath getLocalString:@"surveyItem"]];
    [textView setFont:[UIFont systemFontOfSize:18]];
    [textView sizeToFit];
    
    if (ScreenWidth > ScreenHeight) {
        //水平
        titleView.frame = CGRectMake(0, 0, ScreenWidth, 64);
        textView.frame = CGRectMake((titleView.frame.size.width - textView.frame.size.width)/2, (titleView.frame.size.height-textView.frame.size.height-13), textView.frame.size.width, textView.frame.size.height);
    }else{
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
    
    self.backBtn.frame = CGRectMake(30,(textView.frame.origin.y+12), 30, 30);
    [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(3, 10, 3, 10)];
    [self.backBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:textView];
    [titleView addSubview:self.backBtn];
    [self.bgView addSubview:titleView];
    
    
    NSURL *url = [[NSURL alloc] initWithString:self.pathUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, titleView.frame.size.height, ScreenWidth, ScreenHeight-titleView.frame.size.height)];
    [self.bgView addSubview:self.webView];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.webView loadRequest:request];
    self.navigationItem.title = @"survey";
    
    [self.view addSubview:self.bgView];
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
    [self setNavBar];
}
/* 页面加载失败 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    MCOLog(@"didFailProvisionalNavigation");
}



/* 3.在收到响应后，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    MCOLog(@"decidePolicyForNavigationResponse");
    decisionHandler(WKNavigationResponsePolicyAllow);
    [self setNavBar];
}

-(void)setNavBar{
    self.navigationItem.leftBarButtonItem = self.navBackBtn;
    if ([self.webView canGoBack]) {
        self.navigationItem.rightBarButtonItem = self.navCloseBtn;
        self.countGO++;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
        self.countGO = 0;
    }
}

-(UIBarButtonItem *)navBackBtn{
    if (!_navBackBtn) {
        self.navBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:MCO_Black_Back] style:UIBarButtonItemStylePlain target:self action:@selector(toBack)];
    }
    return _navBackBtn;
}

-(UIBarButtonItem *)navCloseBtn{
    if (!_navCloseBtn) {
        self.navCloseBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:MCO_Black_Back] style:UIBarButtonItemStylePlain target:self action:@selector(toBack)];
    }
    return _navCloseBtn;
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
//    NSNotification *notification =[NSNotification notificationWithName:@"bindSuc" object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)dealloc{
    
    self.webView.navigationDelegate = nil;
    [self.webView setUIDelegate:nil];
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
