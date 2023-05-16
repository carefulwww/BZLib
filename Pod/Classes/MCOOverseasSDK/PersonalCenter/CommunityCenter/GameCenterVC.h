//
//  GameCenterVC.h
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/3/9.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>

@interface GameCenterVC : UIViewController<WKUIDelegate,WKNavigationDelegate>

@property(nonatomic,strong)WKWebView *webView;

@property(nonatomic,strong)UIBarButtonItem *navBackBtn;

@property(nonatomic,strong)NSString *pathUrl;

@property(nonatomic,assign)NSInteger *countGO;

@property(nonatomic,strong)NSString *url;

@end
