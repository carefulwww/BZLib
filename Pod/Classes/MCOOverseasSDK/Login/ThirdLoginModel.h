//
//  ThirdLoginModel.h
//  MCOOverseasProject
//

#import <Foundation/Foundation.h>

@interface ThirdLoginModel : NSObject

//第三方登录名称
@property(nonatomic,assign)NSString *provider;

//appId
@property(nonatomic,assign)NSString *appid;

//是否开启
@property(nonatomic,assign)NSString *open;

//类型
@property(nonatomic,assign)NSString *type;

-(id)initWithShowInfor:(NSDictionary *)infor;

@end
