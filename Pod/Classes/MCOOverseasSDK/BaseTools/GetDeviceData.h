//
//  GetDeviceData.h
//  GetDataSourceSDK
//
//  Created by jay on 2018/2/10.
//  Copyright © 2018年 MCOSDK.jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetDeviceData : NSObject

+(NSMutableDictionary *)getDataSource;
//判空
+(BOOL)isBlankString:(NSString *)string;
//获取UUID
+(NSString *)getUUID;
//idfv
+(NSString *)getIDFV;
//屏幕的宽高
+(NSString *)getSize;
//获取APP版本号
+(NSString *)getVersionApp;
//获取SDK版本号
+(NSString *)getVersionSDK;
//获取手机型号
+(NSString *)getPhoneType;
//获取操作系统
+(NSString *)getOS;
//IP地址
+(NSString *)getIP;
//激活时间戳（激活时，获取当地时间戳就行了）
+(NSString *)getTimeStp;
//网络状态
+(NSString *)networktype;
//获取运营商
+(NSString *)getcarrierName;
// 获取当前设备IP

+ (NSString *)getDeviceIPAdress;
//获取当前的时间戳
+(NSString *)getNowTime;
//获取本机运营商名称
+(NSString *)getOperation;
//网络类型
+(NSString *)getNetworkType;
//获取广告追踪idfa
+(NSString *)getIDFA;

+ (NSString*)iphoneType;
//MD5加密
+(NSString *)md5String:(NSString*)string;

+(BOOL)isSIMInstalled;
@end
