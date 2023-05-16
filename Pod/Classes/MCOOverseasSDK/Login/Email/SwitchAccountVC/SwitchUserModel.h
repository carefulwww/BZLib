//
//  SwitchUserModel.h
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/20.
//

#import <Foundation/Foundation.h>
@interface SwitchUserModel : NSObject

@property(nonatomic,copy)NSString * uuid;
@property(nonatomic,copy)NSString * token;
@property(nonatomic,copy)NSString * emailStr;//用户名
@property(nonatomic,assign)BOOL isSelf;

-initWithShowInfor:(NSDictionary *)infor;
@end
