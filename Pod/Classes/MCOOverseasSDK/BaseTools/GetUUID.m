//
//  GetUUID.m
//  GetDataSourceSDK
//
//  Created by jay on 2018/2/8.
//  Copyright © 2018年 MCOSDK.jay. All rights reserved.
//

#import "GetUUID.h"
#import "KeyChainStore.h"

#define  KEY_USERNAME_PASSWORD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define  KEY_USERNAME @"com.company.app.username"
#define  KEY_PASSWORD @"com.company.app.password"


@implementation GetUUID

+ (NSString *)getUUID {
    
    NSString * strUUID = (NSString *)[KeyChainStore load:KEY_USERNAME_PASSWORD];
    
    // 首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [KeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
        
    }
    return strUUID;
}


@end
