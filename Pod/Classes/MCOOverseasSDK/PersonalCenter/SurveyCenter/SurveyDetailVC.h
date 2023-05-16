//
//  SurveyDetailVC.h
//  MCOOSSDK
//
//

#import <WebKit/WebKit.h>
#import "BaseViewVC.h"

@interface SurveyDetailVC : BaseViewVC<WKUIDelegate,WKNavigationDelegate>

@property(nonatomic,strong)WKWebView *webView;

@property(nonatomic,strong)UIBarButtonItem *navBackBtn;
@property(nonatomic,strong)UIBarButtonItem *navCloseBtn;

@property(nonatomic,strong)NSString *pathUrl;

@property(nonatomic,assign)NSInteger *countGO;

@property(nonatomic,strong)UIButton *backBtn;

@end
