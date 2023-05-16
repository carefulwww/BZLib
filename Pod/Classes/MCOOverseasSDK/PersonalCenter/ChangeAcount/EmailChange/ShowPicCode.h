//
//  Header.h
//  MCODomesticProject
//
//  Created by 王都都 on 2022/7/19.
//

#import "ShowPicCode.h"

@interface ShowPicCode : BaseViewVC<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)NSString *pathUrl;
@property(nonatomic,assign)int type;

@end
