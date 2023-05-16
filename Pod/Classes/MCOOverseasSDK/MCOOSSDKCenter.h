//
//  MCOOSSDKCenter.h
//  MCOOverseasProject
//

#import <Foundation/Foundation.h>
#import "GameProductModel.h"
#import "MCOUserModel.h"
#import "PayOrderModel.h"
#import "MCOApplePay.h"
#import "KVNProgress.h"
#import <GoogleSignIn/GIDSignIn.h>

typedef NS_ENUM(NSInteger,MCOSDKLoginState) {
    MCOSDKLoginSuccess,
    MCOSDKLogiinCancel,
    MCOSDKLoginFailure,
    MCOSDKLoginOut,
};

typedef NS_ENUM(NSInteger,MCOSDKBindState) {
    MCOSDKBindSuccess,
    MCOSDKBindFailure,
};

typedef NS_ENUM(NSInteger,MCOSDKPayState) {
    MCOSDKPaySuccess = 0,
    MCOSDKPayCancel = 1,
    MCOSDKPayFailure = 2,
    MCOSDKPayProductIdInvalid = 3,
    MCOSDKPayInfoLess = 4,
    MCOSDKPayDenied = 5,
    MCOSDKPayDeferred = 6
};

typedef NS_ENUM(NSInteger,MCOSDKRestoreState) {
    MCOSDKRestoreSuccess = 0,
    MCOSDKRestoreNoProduct = 1,
};

@class MCOApplePay;

@protocol MCOSDKDelegate <NSObject>

@required
-(void)payInfo:(NSString *)pay payState:(MCOSDKPayState)state gameOrderId:(NSString *)gameOrderId;
-(void)loginSuccess:(MCOUserModel*)user loginState:(MCOSDKLoginState)state;
-(void)restoreInfo:(MCOSDKRestoreState)state restoreArray:(NSMutableArray*)restoreArray;
//实名认证返回信息 0:没有身份认证; 1:小于8岁; 2:大于8岁小于18岁;3:大于18岁;4:假身份(格式符合要求的身份证)
-(void)realNameReturn:(NSDictionary *)info;
-(void)productInfo:(NSMutableArray *)productArray;
//绑定信息
//-(void)bindSuccess:(MCOUserModel *)user bindState:(MCOSDKBindState)bindState;
//init返回
-(void)initSuccess:(NSDictionary *)dic;
//首次激活回调
-(void)firstActiveBack;
//协议回调
-(void)clauseBack;
//协议入口按钮回调
-(void)clauseClickBtnBack;
//社区点击
-(void)clickCommunityBack:(NSString *)communityName;
//商城评论
-(void)storeReviewBack:(NSString *)reason;
//订单创建成功
-(void)createOrderBack:(PayOrderModel *)orderModel;
//问卷初始化回调成功
-(void)initUserSurveySuccess;
//问卷初始化回调失败
-(void)initUserSurveyFail;
//消息上报成功
-(void)pushTokenBack;
//获取当前时间回调
-(void)currentTimeBack:(long)currentTime;
//无网络回调
-(void)netWorkingStatusBack:(BOOL)status;
@end

@interface MCOOSSDKCenter : NSObject<UIApplicationDelegate,UIWindowSceneDelegate>

//url
@property(nonatomic,strong)NSString *mcoBaseUrl;

//参数
@property(nonatomic,strong)NSString *sdkKey;
@property(nonatomic,strong)NSString *gameId;//游戏ID
@property(nonatomic,strong)NSString *payKey;//U8
@property(nonatomic,strong)NSString *appScheme;//
@property(nonatomic,strong)NSString *channel;//渠道标识+分包标识
@property(nonatomic,strong)NSString *appId;
@property(nonatomic,strong)NSString *appKey;
@property(nonatomic,strong)NSString *serverId;
@property(nonatomic,strong)NSString *roleId;
@property(nonatomic,assign)NSInteger company_entity;//公司主体 1:mojoy，2: neojoy
@property(nonatomic,strong)NSMutableArray *gameProductArr;
@property(nonatomic,strong)NSMutableArray *productIdArr;
@property(nonatomic,strong)NSString *language;
//支付
@property(nonatomic,strong)MCOApplePay *applePay;

@property(nonatomic,strong)NSString *appleAppID;

@property(nonatomic,strong)NSString *googleClient;

@property(weak,nonatomic) id<MCOSDKDelegate> delegate;

@property(nonatomic,copy)NSString *bookingProductID;//预订ProductID

@property(nonatomic,strong)NSString *surveyCallBackUrl; //问卷callback

/**
 init失败尝试
 */
@property(nonatomic,assign)int initTryNum;
@property(nonatomic,assign)BOOL isInitSuc;//是否初始化成功
@property(nonatomic,assign)int  listenNetworkNum;

//ironsource服务端是否回调
@property(nonatomic,assign)BOOL ironsource_server_callback_open;

@property(nonatomic,assign)int pic_code_open;//1.开启;2.关闭
@property(nonatomic,strong)NSString *picVerifyUrl;
@property(nonatomic,assign)int pic_platform_id;

/**
 naver社区
 */
@property(nonatomic,strong)NSString *plugClientId;
@property(nonatomic,strong)NSString *plugSecret;
@property(nonatomic,strong)NSString *loungeId;

//获取uuid
-(NSString *)saveUUID;

//登录状态
-(NSString *)saveToken;

//获取idfv
-(NSString *)saveIDFV;

//获取saveAppKey
-(NSString *)saveAppKey;

-(NSString *)saveUserName;

//实例化
+(instancetype)MCOShareSDK;

//sdk初始化
//-(void)initSDK;

//init
-(void)initSDKSetting:(NSString *)urlString sdkKey:(NSString *)SDKKey gameId:(NSString *)gameId payKey:(NSString *)payKey APPScheme:(NSString *)AppScheme channel:(NSString *)channel appId:(NSString *)appId googleClient:(NSString *)googleClient appleAppID:(NSString *)appleAppID plugClientId:(NSString *)plugClientId plugSecret:(NSString *)plugSecret loungeId:(NSString *)loungeId;

//一键登录
-(void)oneKeyLogin:(int)appState;

//游客登陆
-(void)touristLogin:(NSString *)userName;

//token登陆
-(void)tokenLogin;

//登录
-(void)login;

//推出
-(void)logout;

//兼容老游戏登录
-(void)loginStandAlone:(NSString *)userName;

//个人中心
-(void)personalCenter;

//登录成功
-(void)loginSuccess:(MCOUserModel *)userInfo loginState:(MCOSDKLoginState)state;

//绑定成功
//-(void)bindSuccess:(MCOUserModel *)user bindState:(MCOSDKBindState)bindState;

//获取商品信息
-(void)getProductInfo;

//恢复购买
-(void)restoreTransactions:(NSDictionary *)restoreDic;

//支付
-(void)payInfo:(PayOrderModel *)order;

//商城评价
-(void)storeReview:(NSString *)reason;

//获得所有问卷信息
-(void)getSurveys:(NSString *)roleId;

//是否有问卷
-(void)initUserSurver:(NSString *)roleID serverID:(NSString *)serverID;
-(void)initUserSurver:(NSString *)roleID serverID:(NSString *)serverID callbackUrl:(NSString *)callbackUrl;

//获取问卷内容
-(void)openUserSurvey;

//切换账号
-(void)changeAccount;

//绑定账号
-(void)bindAccount;

//注销账号
-(void)cancelAccount;

//fireBase-token上报
-(void)pushToken:(NSString *)token;

//邮箱切换
-(void)changeEmailAccountVC;

//邮箱登录
-(void)loginEmailAccountVC;

//邮箱绑定
-(void)bindEmailAccountVC;

//获取当前时间
-(void)getCurrentTime;

//获取用户信息
-(void)getUserInfoBack:(void (^)(id result))successCallBack failCallBack:(void(^)(id error))failCallBack;

/**
 naver社区
 */
//主页横幅功能
-(void)displayBanner:(UIViewController *)mainView;

//维护用横幅
-(void)displaySorry:(UIViewController *)mainView;

//跳转公告栏
-(void)displayBoard:(UIViewController *)mainView boardId:(NSNumber *)boardId;

/**
 信息回调
 */

//恢复商品信息回调成功信息
-(void)restoreSuccess:(MCOSDKRestoreState)state restoreArray:(NSMutableArray *)restoreArray;
//支付
-(void)paySuccess:(NSString *)pay payState:(MCOSDKPayState)state gameOrderId:(NSString *)gameOrderId;

//商品信息回调
-(void)productSuccess:(NSMutableArray *)productArray;

//初始化回调
-(void)initSuccess:(NSDictionary *)dic;

//协议界面按钮点击回调
-(void)clauseClickBtnBack;

//商城评价界面点击回调
//-(void)storeReviewBack:(NSString *)reason;

//社区点击
-(void)clickCommunityBack:(NSString *)communityName;

//订单创建成功回调
-(void)createOrderBack:(PayOrderModel *)orderModel;

//key存储
-(void)saveKeychain:(NSDictionary *)data service:(NSString *)service account:(NSString *)account;

//keyChain取出
-(NSDictionary*)getKeyChainDic:(NSString *)service account:(NSString *)account;

+ (UIViewController*)currentViewController;

-(void)reportCreateRole;

//网络监听
-(void)listenNetWorkingStatus;

//弹窗显示引导用户允许设置通知权限
-(void)openNotificationAlert;

//设置log模式
-(void)setLogDebug:(BOOL)enable;
-(BOOL)getLogDebug;
@end
