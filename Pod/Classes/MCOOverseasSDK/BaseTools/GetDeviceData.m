//
//  GetDeviceData.m
//  GetDataSourceSDK
//
//  Created by jay on 2018/2/10.
//  Copyright © 2018年 MCOSDK.jay. All rights reserved.
//

#import "GetDeviceData.h"

#import <UIKit/UIKit.h>
#import "sys/utsname.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <AdSupport/AdSupport.h>
#import "GetUUID.h"
#import <CommonCrypto/CommonDigest.h>
#import "GetIDFV.h"


@implementation GetDeviceData

+(NSMutableDictionary *)getDataSource
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [dic setObject:[self getTimeStp] forKey:@"time"];//激活时间戳,
    [dic setObject:[self getVersionApp] forKey:@"app_version"];//版本号
    [dic setObject:[self getVersionSDK] forKey:@"sdk_version"];//版本号
    [dic setObject:[self getPhoneType] forKey:@"device_type"];//用户手机型号
//    [dic setObject:[self getUUID] forKey:@"device_id"];//手机设备UUID，唯一识别码
//    [dic setObject:[self getIDFA] forKey:@"device"];//广告跟踪用，对于ios是idfa
    [dic setObject:[self getIDFV] forKey:@"device"];
    [dic setObject:[self getSize] forKey:@"screen_size"];//屏幕尺寸
    [dic setObject:[self getOS] forKey:@"system_version"];//操作系统
//    [dic setObject:@"" forKey:@"server_id"];
//    [dic setObject:@"" forKey:@"mac"];
    NSString *serverId = [MCOOSSDKCenter MCOShareSDK].serverId == nil ? @"0" : [MCOOSSDKCenter MCOShareSDK].serverId;
    [dic setObject:serverId forKey:@"server_id"];
    [dic setObject:@"" forKey:@"mac"];
    [dic setObject:[self getOperation] forKey:@"operator"];//运营商
    [dic setObject:[self getNetworkType] forKey:@"network_type"];//网络类型
    [dic setObject:[self getIP] forKey:@"client_ip"];//ip地址
    
    return dic;
}

//判空
+(BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        
        return YES;
        
    }
    
    if (string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        return YES;
        
    }
    return NO;
}
//获取UUID
+(NSString *)getUUID
{
    NSString *uuid = [GetUUID getUUID];
    if ([self isBlankString:uuid]) {
        uuid = @"";
    }
    
    return uuid;
}
//idfv
+(NSString *)getIDFV{
    NSString *idfv = [GetIDFV getIDFV];
    if ([self isBlankString:idfv]) {
        idfv = @"";
    }
    return idfv;
}
//屏幕的宽高
+(NSString *)getSize
{
    float screenW =  [UIScreen mainScreen].bounds.size.width;
    float screenH =  [UIScreen mainScreen].bounds.size.height;
    
    NSString *size = [NSString stringWithFormat:@"%f*%f",screenW,screenH];
    
    return size;
}
//获取APP版本号
+(NSString *)getVersionApp
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *versionAPP = [[bundle infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if ([self isBlankString:versionAPP]) {
        versionAPP = @"";
    }
    return versionAPP;
}

//获取SDK版本号
+(NSString *)getVersionSDK{
    return MCOSDKVersion;
}

//获取手机型号
+(NSString *)getPhoneType
{
    NSString *phoneModel = [self iphoneType];
    if ([self isBlankString:phoneModel]) {
        phoneModel = @"";
    }
    return phoneModel;
}
//获取操作系统
+(NSString *)getOS
{
    NSString *osVersion = [UIDevice currentDevice].systemVersion;
    NSString *osName = [UIDevice currentDevice].systemName;
    
    NSString *os = [NSString stringWithFormat:@"%@ %@",osName,osVersion];
    
    if ([self isBlankString:os]) {
        os = @"";
    }
    
    
    return os;
}
//IP地址
+(NSString *)getIP
{
    NSString *ipStr = [self getDeviceIPAdress];
    if ([self isBlankString:ipStr]) {
        ipStr = @"";
    }
    
    return ipStr;
}
//激活时间戳（激活时，获取当地时间戳就行了）
+(NSString *)getTimeStp
{
    NSString *timeStp = [self getNowTime];
    if ([self isBlankString:timeStp]) {
        timeStp = @"";
    }
    
    
    return timeStp;
}
//网络状态
+(NSString *)networktype{
    
    NSString *networkStr;
    
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            MCOLog(@"No wifi or cellular");
            networkStr = @"";
            break;
            
        case 1:
            MCOLog(@"2G");
            networkStr=@"2G";
            break;
            
        case 2:
            MCOLog(@"3G");
            networkStr=@"3G";
            break;
            
        case 3:
            MCOLog(@"4G");
            networkStr=@"4G";
            break;
            
        case 4:
            MCOLog(@"LTE");
            networkStr=@"LTE";
            break;
            
        case 5:
            MCOLog(@"Wifi");
            networkStr=@"Wifi";
            break;
            
            
        default:
            break;
    }
    return networkStr;
}
//获取运营商
+(NSString *)getcarrierName{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry=[carrier carrierName];
    MCOLog(@"[carrier isoCountryCode]==%@,[carrier allowsVOIP]=%d,[carrier mobileCountryCode=%@,[carrier mobileCountryCode]=%@",[carrier isoCountryCode],[carrier allowsVOIP],[carrier mobileCountryCode],[carrier mobileNetworkCode]);
    
    return currentCountry;
}

// 获取当前设备IP

+ (NSString *)getDeviceIPAdress {
    
    NSString *address = @"an error occurred when obtaining ip address";
    
    struct ifaddrs *interfaces = NULL;
    
    struct ifaddrs *temp_addr = NULL;
    
    int success = 0;
    
    success = getifaddrs(&interfaces);
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        
        while (temp_addr != NULL) {
            
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                
                // Check if interface is en0 which is the wifi connection on the iPhone
                
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    
                    // Get NSString from C String
                    
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    
    return address;
}
//获取当前的时间戳
+(NSString *)getNowTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *date = [NSDate date];
    NSString *timeStp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    return timeStp;
    
}

//获取本机运营商名称
+(NSString *)getOperation
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    //当前手机所属运营商名称
    NSString *mobile;
    
    //先判断有没有SIM卡，如果没有则不获取本机运营商
    if (!carrier.isoCountryCode) {
        
        MCOLog(@"没有SIM卡");
        mobile = @"";
        
    }else{
        mobile = [carrier carrierName];
        MCOLog(@"运营商：%@",mobile);
    }
    if ([self isBlankString:mobile]) {
        mobile = @"";
    }
    
    return mobile;
}
//网络类型
+(NSString *)getNetworkType
{
    NSString *networkStr = [self networktype];
    if ([self isBlankString:networkStr]) {
        networkStr = @"";
    }
    
    return networkStr;
}

//获取广告追踪idfa
+(NSString *)getIDFA
{
    //先判断用户是否开启了广告追踪
    NSString *idfa = @"";
    if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled] ) {
        
        idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }else{
        idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    if ([self isBlankString:idfa]) {
        idfa = @"";
    }
    
    return idfa;
}



+ (NSString*)iphoneType {
    struct utsname  systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
//    if([platform isEqualToString:@"iPhone1,1"]) return@"iPhone 2G";
//    
//    if([platform isEqualToString:@"iPhone1,2"]) return@"iPhone 3G";
//    
//    if([platform isEqualToString:@"iPhone2,1"]) return@"iPhone 3GS";
//    
//    if([platform isEqualToString:@"iPhone3,1"]) return@"iPhone 4";
//    
//    if([platform isEqualToString:@"iPhone3,2"]) return@"iPhone 4";
//    
//    if([platform isEqualToString:@"iPhone3,3"]) return@"iPhone 4";
//    
//    if([platform isEqualToString:@"iPhone4,1"]) return@"iPhone 4S";
//    
//    if([platform isEqualToString:@"iPhone5,1"]) return@"iPhone 5";
//    
//    if([platform isEqualToString:@"iPhone5,2"]) return@"iPhone 5";
//    
//    if([platform isEqualToString:@"iPhone5,3"]) return@"iPhone 5c";
//    
//    if([platform isEqualToString:@"iPhone5,4"]) return@"iPhone 5c";
//    
//    if([platform isEqualToString:@"iPhone6,1"]) return@"iPhone 5s";
//    
//    if([platform isEqualToString:@"iPhone6,2"]) return@"iPhone 5s";
//    
//    if([platform isEqualToString:@"iPhone7,1"]) return@"iPhone 6 Plus";
//    
//    if([platform isEqualToString:@"iPhone7,2"]) return@"iPhone 6";
//    
//    if([platform isEqualToString:@"iPhone8,1"]) return@"iPhone 6s";
//    
//    if([platform isEqualToString:@"iPhone8,2"]) return@"iPhone 6s Plus";
//    
//    if([platform isEqualToString:@"iPhone8,4"]) return@"iPhone SE";
//    
//    if([platform isEqualToString:@"iPhone9,1"]) return@"iPhone 7";
//    
//    if([platform isEqualToString:@"iPhone9,2"]) return@"iPhone 7 Plus";
//    
//    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
//    
//    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
//    
//    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
//    
//    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
//    
//    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
//    
//    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
//    
//    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
//    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS MAX";
//    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
//    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
//    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
//    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
//    if ([platform isEqualToString:@"iPhone12,8"]) return @"iPhone SE (2nd generation)";
//    if ([platform isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
//    if ([platform isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
//    if ([platform isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
//    if ([platform isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";
//    
//    // iPod
//    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1";
//    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2";
//    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3";
//    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4";
//    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5";
//    if ([platform isEqualToString:@"iPod7,1"])  return @"iPod Touch 6";
//    if ([platform isEqualToString:@"iPod9,1"])  return @"iPod Touch 7";
//    
//    if([platform isEqualToString:@"iPad1,1"]) return@"iPad 1G";
//    
//    if([platform isEqualToString:@"iPad2,1"]) return@"iPad 2";
//    
//    if([platform isEqualToString:@"iPad2,2"]) return@"iPad 2";
//    
//    if([platform isEqualToString:@"iPad2,3"]) return@"iPad 2";
//    
//    if([platform isEqualToString:@"iPad2,4"]) return@"iPad 2";
//    
//    if([platform isEqualToString:@"iPad2,5"]) return@"iPad Mini 1G";
//    
//    if([platform isEqualToString:@"iPad2,6"]) return@"iPad Mini 1G";
//    
//    if([platform isEqualToString:@"iPad2,7"]) return@"iPad Mini 1G";
//    
//    if([platform isEqualToString:@"iPad3,1"]) return@"iPad 3";
//    
//    if([platform isEqualToString:@"iPad3,2"]) return@"iPad 3";
//    
//    if([platform isEqualToString:@"iPad3,3"]) return@"iPad 3";
//    
//    if([platform isEqualToString:@"iPad3,4"]) return@"iPad 4";
//    
//    if([platform isEqualToString:@"iPad3,5"]) return@"iPad 4";
//    
//    if([platform isEqualToString:@"iPad3,6"]) return@"iPad 4";
//    
//    if([platform isEqualToString:@"iPad4,1"]) return@"iPad Air";
//    
//    if([platform isEqualToString:@"iPad4,2"]) return@"iPad Air";
//    
//    if([platform isEqualToString:@"iPad4,3"]) return@"iPad Air";
//    
//    if([platform isEqualToString:@"iPad4,4"]) return@"iPad Mini 2G";
//    
//    if([platform isEqualToString:@"iPad4,5"]) return@"iPad Mini 2G";
//    
//    if([platform isEqualToString:@"iPad4,6"]) return@"iPad Mini 2G";
//    
//    if([platform isEqualToString:@"iPad4,7"]) return@"iPad Mini 3";
//    
//    if([platform isEqualToString:@"iPad4,8"]) return@"iPad Mini 3";
//    
//    if([platform isEqualToString:@"iPad4,9"]) return@"iPad Mini 3";
//    
//    if([platform isEqualToString:@"iPad5,1"]) return@"iPad Mini 4";
//    
//    if([platform isEqualToString:@"iPad5,2"]) return@"iPad Mini 4";
//    
//    if([platform isEqualToString:@"iPad5,3"]) return@"iPad Air 2";
//    
//    if([platform isEqualToString:@"iPad5,4"]) return@"iPad Air 2";
//    
//    if([platform isEqualToString:@"iPad6,3"]) return@"iPad Pro 9.7";
//    
//    if([platform isEqualToString:@"iPad6,4"]) return@"iPad Pro 9.7";
//    
//    if([platform isEqualToString:@"iPad6,7"]) return@"iPad Pro 12.9";
//    
//    if([platform isEqualToString:@"iPad6,8"]) return@"iPad Pro 12.9";
//    
//    if ([platform isEqualToString:@"iPad6,11"])  return @"iPad 5";
//    if ([platform isEqualToString:@"iPad6,12"])  return @"iPad 5";
//    if ([platform isEqualToString:@"iPad7,1"])  return @"iPad Pro 2(12.9-inch)";
//    if ([platform isEqualToString:@"iPad7,2"])  return @"iPad Pro 2(12.9-inch)";
//    if ([platform isEqualToString:@"iPad7,3"])  return @"iPad Pro (10.5-inch)";
//    if ([platform isEqualToString:@"iPad7,4"])  return @"iPad Pro (10.5-inch)";
//    if ([platform isEqualToString:@"iPad7,5"])  return @"iPad 6";
//    if ([platform isEqualToString:@"iPad7,6"])  return @"iPad 6";
//    if ([platform isEqualToString:@"iPad7,11"])  return @"iPad 7";
//    if ([platform isEqualToString:@"iPad7,12"])  return @"iPad 7";
//    if ([platform isEqualToString:@"iPad8,1"])  return @"iPad Pro (11-inch) ";
//    if ([platform isEqualToString:@"iPad8,2"])  return @"iPad Pro (11-inch) ";
//    if ([platform isEqualToString:@"iPad8,3"])  return @"iPad Pro (11-inch) ";
//    if ([platform isEqualToString:@"iPad8,4"])  return @"iPad Pro (11-inch) ";
//    if ([platform isEqualToString:@"iPad8,5"])  return @"iPad Pro 3 (12.9-inch) ";
//    if ([platform isEqualToString:@"iPad8,6"])  return @"iPad Pro 3 (12.9-inch) ";
//    if ([platform isEqualToString:@"iPad8,7"])  return @"iPad Pro 3 (12.9-inch) ";
//    if ([platform isEqualToString:@"iPad8,8"])  return @"iPad Pro 3 (12.9-inch) ";
//    if ([platform isEqualToString:@"iPad11,1"])  return @"iPad mini 5";
//    if ([platform isEqualToString:@"iPad11,2"])  return @"iPad mini 5";
//    if ([platform isEqualToString:@"iPad11,3"])  return @"iPad Air 3";
//    if ([platform isEqualToString:@"iPad11,4"])  return @"iPad Air 3";
//        
//    
//    if([platform isEqualToString:@"i386"]) return@"iPhone Simulator";
//    
//    if([platform isEqualToString:@"x86_64"]) return@"iPhone Simulator";
    
    return platform;
    
}

+(NSString *)md5String:(NSString*)string
{
    const char * pointer = [string UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(pointer, (CC_LONG)strlen(pointer), md5Buffer);
    
    NSMutableString *foostring =[NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2] ;
    for(int i = 0;i< CC_MD5_DIGEST_LENGTH;i++)
        [foostring appendFormat:@"%02x",md5Buffer[i]];
    return foostring;
}

+(BOOL)isSIMInstalled{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    if (!carrier.isoCountryCode) {
        //未插入sim卡
        return NO;
    }else{
        //已经插入了sim卡
        return YES;
    }
}

@end
