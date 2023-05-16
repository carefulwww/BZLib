//
//  MCOApplePay.h
//  MCOStandAlone
//
//  Copyright © 2019 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface MCOApplePay : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property(nonatomic,strong)NSString *order_id;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)PayOrderModel *payOrder;
@property(nonatomic,strong)NSMutableArray *restoreArray;

//@property(nonatomic,strong)dispatch_source_t timer;

+(instancetype)MCOSharedApplePay;

-(void)applePay:(PayOrderModel *)order;
//-(void)reportOrderStatus:(BOOL)status  Transaction:(SKPaymentTransaction*)transaction;
//-(void)reportOrderSuccessStatus:(SKPaymentTransaction*)transaction;

-(void)returnProductInfo;

@end
NS_ASSUME_NONNULL_END
