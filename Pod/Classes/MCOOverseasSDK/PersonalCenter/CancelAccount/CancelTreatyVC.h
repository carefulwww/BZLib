//
//  CancelTreatyVC.h
//  MCOOverseasProject
//

/**
 账号注销-游戏账号注销协议界面
 */

#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>
#import "CancelUserDetailVC.h"
#import "CancelMessageVC.h"

@interface CancelTreatyVC : BaseViewVC<WKUIDelegate,WKNavigationDelegate,UITextFieldDelegate>

@property(nonatomic,strong)WKWebView *webView;

@property(nonatomic,strong)NSString *pathUrl;

@end
