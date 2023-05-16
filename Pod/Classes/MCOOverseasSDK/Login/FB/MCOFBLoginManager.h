//
//  MCOFBLogin.h
//  MCOOverseasProject
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <UIKit/UIKit.h>

@interface MCOFBLoginManager : NSObject

+(void)fbLogin:(nullable UIViewController *)fromViewController isChange:(BOOL)isChange hud:(UIView *)hud;
+(void)fbBind:(nullable UIViewController *)fromViewController hud:(UIView *)hud;
@end
