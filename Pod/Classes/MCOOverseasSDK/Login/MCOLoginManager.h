//
//  MCOLoginManager.h
//  MCOOverseasProject
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MCOLoginManager : NSObject

+(void)reportThirdLogin:(NSDictionary *)dic isChange:(BOOL)isChange hud:(UIView *)hud;

//第三方登录token失败
+(void)reportTokenLogin:(NSString *)userName;

//绑定第三方账号
+(void)reportBindThirdLogin:(NSDictionary *)dic hud:(UIView *)hud;

@end
