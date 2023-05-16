//
//  MCOUserModel.h
//  MCOStandAlone
//
//  Copyright © 2019 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCOUserModel : NSObject

@property(strong,nonatomic) NSString* showName;
@property(strong,nonatomic) NSString* token;
@property(strong,nonatomic) NSString* uuid;
@property (nonatomic, copy) NSString * code;

@property(nonatomic,copy) NSString *expireTime; //token过期时间，时间戳
@property(nonatomic,copy) NSString *isNew; //0:表示老用户，1表示新用户
@property(nonatomic,copy) NSString *displayName;
@property(nonatomic,copy) NSString *third_login_type;
@property(nonatomic,copy) NSString *sdk_op_type;//1.登陆 2.切换 3.绑定
@property(nonatomic,copy) NSString *third_identifier;//第三方ID

@property(nonatomic,copy) NSString *isSuspend;//是否封号 0.未封号 1.封号
@property(nonatomic,copy) NSString *suspendTime;//封号时间
@property(nonatomic,copy) NSString *suspendReason;//封号原因
@property(nonatomic,copy) NSString *note;//封号备注

@property(nonatomic,copy) UIView *view;

-initWithShowInfor:(NSDictionary *)Infor;

@end
