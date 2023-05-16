//
//  MCOClause.h
//  MCOOverseasProject
//

#import "BaseViewVC.h"
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>

@interface MCOClause : BaseViewVC<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)UIButton *agreenBtn;

@property(nonatomic,strong)NSString *pathUrl;

@property(nonatomic,strong)NSDictionary *dic;

@end
