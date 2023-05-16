//
//  MCOVerifyReceipt.h
//  MCODomesticProject
//
//  Created by 王都都 on 2022/9/15.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface MCOVerifyReceipt : NSObject

+(void)verifyPurchaseWithProductionEnvironment:(NSString *)receiptString appleUrl:(NSString *)appleUrl;

@end

