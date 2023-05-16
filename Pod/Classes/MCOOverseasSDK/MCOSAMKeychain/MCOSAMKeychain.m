//
//  SAMKeychain.m
//  SAMKeychain
//
//  Created by Sam Soffes on 5/19/10.
//  Copyright (c) 2010-2014 Sam Soffes. All rights reserved.
//

#import "MCOSAMKeychain.h"
#import "MCOSAMKeychainQuery.h"

NSString *const mcoKSAMKeychainErrorDomain = @"com.samsoffes.samkeychain";
NSString *const mcokSAMKeychainAccountKey = @"acct";
NSString *const mcokSAMKeychainCreatedAtKey = @"cdat";
NSString *const mcokSAMKeychainClassKey = @"labl";
NSString *const mcokSAMKeychainDescriptionKey = @"desc";
NSString *const mcokSAMKeychainLabelKey = @"labl";
NSString *const mcokSAMKeychainLastModifiedKey = @"mdat";
NSString *const mcokSAMKeychainWhereKey = @"svce";

#if __IPHONE_4_0 && TARGET_OS_IPHONE
    static CFTypeRef SAMKeychainAccessibilityType = NULL;
#endif

@implementation MCOSAMKeychain

+ (nullable NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account {
    return [self passwordForService:serviceName account:account error:nil];
}


+ (nullable NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account error:(NSError *__autoreleasing *)error {
    MCOSAMKeychainQuery *query = [[MCOSAMKeychainQuery alloc] init];
    query.mcoService = serviceName;
    query.mcoAccount = account;
    [query fetch:error];
    return query.password;
}

+ (nullable NSData *)passwordDataForService:(NSString *)serviceName account:(NSString *)account {
    return [self passwordDataForService:serviceName account:account error:nil];
}

+ (nullable NSData *)passwordDataForService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error {
    MCOSAMKeychainQuery *query = [[MCOSAMKeychainQuery alloc] init];
    query.mcoService = serviceName;
    query.mcoAccount = account;
    [query fetch:error];

    return query.mcoPasswordData;
}


+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account {
    return [self deletePasswordForService:serviceName account:account error:nil];
}


+ (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account error:(NSError *__autoreleasing *)error {
    MCOSAMKeychainQuery *query = [[MCOSAMKeychainQuery alloc] init];
    query.mcoService = serviceName;
    query.mcoAccount = account;
    return [query deleteItem:error];
}


+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account {
    return [self setPassword:password forService:serviceName account:account error:nil];
}


+ (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account error:(NSError *__autoreleasing *)error {
    MCOSAMKeychainQuery *query = [[MCOSAMKeychainQuery alloc] init];
    query.mcoService = serviceName;
    query.mcoAccount = account;
    query.password = password;
    return [query save:error];
}

+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)serviceName account:(NSString *)account {
    return [self setPasswordData:password forService:serviceName account:account error:nil];
}


+ (BOOL)setPasswordData:(NSData *)password forService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error {
    MCOSAMKeychainQuery *query = [[MCOSAMKeychainQuery alloc] init];
    query.mcoService = serviceName;
    query.mcoAccount = account;
    query.mcoPasswordData = password;
    return [query save:error];
}

+ (nullable NSArray *)allAccounts {
    return [self allAccounts:nil];
}


+ (nullable NSArray *)allAccounts:(NSError *__autoreleasing *)error {
    return [self accountsForService:nil error:error];
}


+ (nullable NSArray *)accountsForService:(nullable NSString *)serviceName {
    return [self accountsForService:serviceName error:nil];
}


+ (nullable NSArray *)accountsForService:(nullable NSString *)serviceName error:(NSError *__autoreleasing *)error {
    MCOSAMKeychainQuery *query = [[MCOSAMKeychainQuery alloc] init];
    query.mcoService = serviceName;
    return [query fetchAll:error];
}


#if __IPHONE_4_0 && TARGET_OS_IPHONE
+ (CFTypeRef)accessibilityType {
    return SAMKeychainAccessibilityType;
}


+ (void)setAccessibilityType:(CFTypeRef)accessibilityType {
    CFRetain(accessibilityType);
    if (SAMKeychainAccessibilityType) {
        CFRelease(SAMKeychainAccessibilityType);
    }
    SAMKeychainAccessibilityType = accessibilityType;
}
#endif

@end
