//
//  AppBtnModel.h
//  MCOOverseasProject
//

#import <Foundation/Foundation.h>

@interface AppBtnModel : NSObject

//第三方登录名称
@property(nonatomic,assign)NSString *name;

//是否开启
@property(nonatomic,assign)NSString *open;

//网址
@property(nonatomic,assign)NSString *url;

-(id)initWithShowInfor:(NSDictionary *)infor;

@end
