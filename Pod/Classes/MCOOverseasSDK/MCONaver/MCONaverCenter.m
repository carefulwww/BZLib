//
//  MCONaverCenter.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/11/18.
//

#import "MCONaverCenter.h"

@implementation MCONaverCenter

+(instancetype)MCONaverShare{
    static MCONaverCenter *sdk = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sdk = [[MCONaverCenter alloc]init];
//        [[NNGSDKManager shared] setClientId:@"OBGlPIIaBZZQvnFhaxap" clientSecret:@"05WfzoKn9T" loungeId:@"laws_of_power"];
//        [[NNGSDKManager shared] setClientId:[MCOOSSDKCenter MCOShareSDK].plugClientId clientSecret:[MCOOSSDKCenter MCOShareSDK].plugSecret loungeId:@"laws_of_power"];
    });
    return sdk;
}

-(void)MCONaverInit:(NSString *)clientId
            secret:(NSString *)secret
            loungeId:(NSString *)loungeId{
    [[NNGSDKManager shared] setClientId:clientId clientSecret:secret loungeId:loungeId];
    NNGSDKManager.shared.delegate = self;
}

/**
 显示横幅
 */
-(void)displayBanner:(UIViewController *)mainView{
    [[NNGSDKManager shared] setParentViewController:mainView];
    [[NNGSDKManager shared] presentBannerViewController];
}

/**
 显示紧急通知页面
 */
-(void)displaySorry:(UIViewController *)mainView{
    [[NNGSDKManager shared] setParentViewController:mainView];
    [[NNGSDKManager shared] presentSorryViewController];
}

/**
 显示公告栏
 */
-(void)displayBoard:(UIViewController *)mainView boardId:(NSNumber *)boardId;{
    [[NNGSDKManager shared] setParentViewController:mainView];
    [[NNGSDKManager shared] presentBoardViewControllerWith:boardId];
}

-(void)closeView{
    [[NNGSDKManager shared] dismiss];
}

-(void)nngSDKDidLoad{
    NSLog(@"naver sdk loaded");
}

- (void)nngSDKDidUnload{
    NSLog(@"naver sdk unloaded");
}

- (void)nngSDKDidReceiveInGameMenuCode:(NSString *)inGameMenuCode{
    NSLog(@"naver in-game menu code received:[%@]",inGameMenuCode);
}

@end
