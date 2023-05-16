//
//  PayOrderModel.h
//  MCOStandAlone
//
//  Created by 王都都 on 2019/8/22.
//  Copyright © 2019 test. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayOrderModel:NSObject

@property(nonatomic,strong) NSString* productID;//商品ID
@property(nonatomic,strong) NSString* productPrice;//商品价格
@property(nonatomic,strong) NSString* roleName;//角色名
@property(nonatomic,strong) NSString* gameOrderID;//游戏订单ID，U8订单ID
@property(nonatomic,strong) NSString* transactionID;//充值渠道订单ID
@property(nonatomic,strong) NSString* serverID;//服务器ID
@property(nonatomic,strong) NSString* desc; //商品描述
@property(nonatomic,strong) NSString* extra; //商品ID
@property(nonatomic,copy) NSString* uuid;//唯一标示
@property(nonatomic,copy) NSString* user_name;//用户名
@property(nonatomic,strong) NSString* sdkOrderID;//SDK订单ID
@property(nonatomic,strong) NSMutableDictionary *parameters;
@property(nonatomic,strong) NSString* token;

@property(nonatomic,strong)NSString* transactionIdentifier;

@property(nonatomic,strong)NSArray *productDetails;

//@property(nonatomic,strong) NSString* receiptDataString; //苹果返回的凭证

-initWithShowInforPrice:(NSString *)price productID:(NSString *)productID;
-(NSMutableDictionary *)payOrderParameters;

@end
NS_ASSUME_NONNULL_END
