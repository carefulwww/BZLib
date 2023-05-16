//
//  MCOAppleLogin.h
//  MCOOverseasProject
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AuthenticationServices/AuthenticationServices.h>

typedef NS_ENUM(NSUInteger, AppleLoginType) {
    AppleLoginTypeUnknown = 0,
    AppleLoginTypeSuccessful,
    AppleLoginTypeUserSuccessful,
    AppleLoginTypeFailure
};

typedef void(^MCOAppleLoginBlock) (NSInteger state,NSString *msg,id data);

@interface MCOAppleLogin : UIView<ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)UIView *view;
@property(nonatomic)CGRect rect;
@property(nonatomic,copy)MCOAppleLoginBlock appleLoginBlock;

//  Apple登录
+(instancetype)appLogoinFromUser:(NSString *)user view:(UIView *)view rect:(CGRect)rect block:(void(^)(NSInteger state,NSString *msg,id data))block;

- (void)signInWithApple;

@end
