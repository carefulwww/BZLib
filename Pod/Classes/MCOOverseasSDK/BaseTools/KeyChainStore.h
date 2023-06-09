//
//  KeyChainStore.h
//  GetDataSourceSDK
//
//  Created by jay on 2018/2/8.
//  Copyright © 2018年 MCOSDK.jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
