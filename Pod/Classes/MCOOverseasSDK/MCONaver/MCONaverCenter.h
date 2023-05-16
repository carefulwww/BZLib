//
//  MCONaverCenter.h
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/11/18.
//

#import <Foundation/Foundation.h>
#import <NNGSDK/NNGSDKManager.h>

@interface MCONaverCenter : NSObject<NNGSDKDelegate>
//@interface MCONaverCenter : NSObject

+(instancetype)MCONaverShare;

-(void)MCONaverInit:(NSString *)clientId secret:(NSString *)secret loungeId:(NSString *)loungeId;

//主页横幅功能
-(void)displayBanner:(UIViewController *)mainView;

//维护用横幅
-(void)displaySorry:(UIViewController *)mainView;

//跳转公告栏
-(void)displayBoard:(UIViewController *)mainView boardId:(NSNumber *)boardId;

@end
