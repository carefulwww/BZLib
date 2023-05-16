//
//  publicMath.h
//  MCOStandAlone
//
//  Copyright © 2019 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface publicMath : NSObject

//判断字符串是否为空
+(BOOL)isBlankString:(NSString *)string;

+(NSString*)dictionaryToJson:(NSDictionary *)dic;

//base64
+(NSString *) jptbase64StringFromData:(NSData *)data length:(long)length;

//判断手机号码是否符合规则
+(BOOL)verfiyPhoneNumber:(NSString *)phone;

//提示框
+(void)MCOHub:(NSString *)message messageView:(UIView *)view;

//电话号码加星号
+(NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation length:(NSInteger)lenght;

//判断是否为纯数字
+(BOOL)isPureNum:(NSString *)text;

//判断是否为邮箱
+ (BOOL)isValidateEmail:(NSString *)email;

//判断时间是是否在22：00到次日8:00
+(BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour;

//国际化语言
+(NSString *)getLocalString:(NSString *)key;

//获取app名字
+(NSString *)getAppName;

//是否包含数字和字母
+(BOOL)isLettersAndNumbersAndUnderScore:(NSString *)string;

//是否刘海屏
+ (BOOL)isIPhoneNotchScreen;

+(NSString *)objectToJson:(id)obj;

//关闭游戏
+(void)closeGame;

# pragma mark -- 控制台打印方法
//设置打印状态
+(void)setLogEnable:(BOOL)enable;

//获取打印状态
+(BOOL)getLogEnable;

//日志输出方法
+(void)customLogWithString:(NSString *)formatString;
@end
