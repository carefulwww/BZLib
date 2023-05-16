//
//  GetIDFV.m
//  MCOStandAlone
//
//  Copyright © 2021 test. All rights reserved.
//

#import "GetIDFV.h"

#define  KEY_USERNAME_PASSWORD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define  KEY_USERNAME @"com.company.app.username"
#define  KEY_PASSWORD @"com.company.app.password"

@implementation GetIDFV

+(NSString *)getIDFV{
    
    NSString * strIDFV = (NSString *)[KeyChainStore load:KEY_USERNAME_PASSWORD];
    
    // 首次执行该方法时，uuid为空
    if ([strIDFV isEqualToString:@""] || !strIDFV)
    {
        strIDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        //将该uuid保存到keychain
        [KeyChainStore save:KEY_USERNAME_PASSWORD data:strIDFV];
        
    }
    return strIDFV;
}

@end
