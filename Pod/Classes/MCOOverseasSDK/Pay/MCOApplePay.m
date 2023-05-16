//
//  MCOApplePay.m
//  MCOStandAlone
//

#import "MCOApplePay.h"

@implementation MCOApplePay
int repeatTime = 0;
dispatch_source_t timer;
bool startTimer = NO;

+(instancetype)MCOSharedApplePay{
    static MCOApplePay *applePay = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        applePay = [[MCOApplePay alloc]init];
    });
    return applePay;
}

-(instancetype)init{
//    [MCOSAMKeychain deletePasswordForService:@"newOrder" account:@"list" error:nil];
    if ([SKPaymentQueue defaultQueue]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

-(void)applePay:(PayOrderModel *)order{
    MCOLog(@"订单信息-----:%@-----:%@----------:%@",order,order.productID,order.desc);
    
    //将本次购买存储到本地维护的购买记录中
    NSDictionary *dic = @{
        @"order_id":self.order_id,
        @"token":self.token,
        @"user_name":order.user_name,
        @"transactionIdentifier":@"",
        @"status":@"",
        @"extra":[publicMath isBlankString:order.extra]?order.extra:@"",
        @"productIdentifier":order.productID,
        @"receipt":@"",
        @"isVerify":@NO,
    };
    
    [self saveOrderArr:dic];
    
    if ([SKPaymentQueue canMakePayments]) {
        //请求苹果后台商品
        [self appleStartPay:order];
    }else{
        //不允许支付
        [self payInfo:@"手机不允许支付" stateInfo:MCOSDKPayFailure gameOrderId:self.payOrder.extra];
    }
        
}

//开始后请求支付
-(void)appleStartPay:(PayOrderModel *)order{
    if(timer!=nil){
        [self suspendTimer];
    }
    //判断是否有未完成的支付订单
    NSArray *transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count>0) {
        [self autoPay:false];
    }
    [self createApplePay:order];
}

//创建请求
-(void)createApplePay:(PayOrderModel *)order{
    //判断商品ID不为空
    if (order.productID) {
        //订单ID就对应着苹果后台的商品ID，通过这个ID进行联系
        NSSet *set = [NSSet setWithArray:@[order.productID]];
        //初始化请求
        SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:set];
        request.delegate = self;
        self.payOrder = order;
        [request start];
        
        MCOLog(@"苹果内购请求开始");
    }
}

//查找商品
-(void)returnProductInfo{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSArray *productIdArr = [user valueForKey:@"productIds"];
    if([productIdArr count] < 1){
//        [self productInfo:(NSMutableArray *)productIdArr];
        return;
    }
    
//    NSMutableArray *productIdArr = [[NSMutableArray alloc] init];
//    [productIdArr addObject:@"com.mco.game.ssll.iap.gift.newbie.1"];
//    [productIdArr addObject:@"com.mco.game.ssll.iap.monthlyCard"];
    SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdArr]];
    productRequest.delegate = self;
    [productRequest start];
}

//请求失败
-(void)request:(SKRequest *)request didFailWithError:(nonnull NSError *)error{
    MCOLog(@"请求失败error: %@ ",error);
    [self payInfo:@"请求失败" stateInfo:MCOSDKPayFailure gameOrderId:self.payOrder.extra];
}

//请求成功拿到产品信息
- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
    MCOLog(@"------收到产品反馈信息--------");
    NSArray *products = response.products;
    MCOLog(@"无效产品Product ID: %@",response.invalidProductIdentifiers);
    MCOLog(@"产品付费数量：%d",(int)[products count]);
    
    if([products count] > 1){
        //获取商品信息
        NSMutableArray *productArr = [NSMutableArray array];
        for (SKProduct *pro in products) {
            NSMutableDictionary *proDic = [NSMutableDictionary dictionary];
            //商品ID
            [proDic setValue:pro.productIdentifier forKey:@"product_id"];
            //本地化描述
            [proDic setValue:pro.localizedDescription forKey:@"localizedDescription"];
            //本地化商品名称
            [proDic setValue:pro.localizedTitle forKey:@"title"];
            
            //指示产品是否可在App Store Connect中用于家庭共享。
            if (@available(iOS 14.0, *)) {
                [proDic setValue:@(pro.isFamilyShareable) forKey:@"isFamilyShareable"];
            } else {
                // Fallback on earlier versions
            }
            
            //The cost of the product in the local currency.
            [proDic setValue:pro.price forKey:@"price"];
            [proDic setValue:pro.price forKey:@"priceAmountMicros"];
            /**
                用来格式化价格的本地化环境 priceLocale
             **/
            //区域设置的国家或地区代码。国家或地区码的示例包括“GB”、“FR”和“HK”。
            [proDic setValue:pro.priceLocale.countryCode forKey:@"countryCode"];
            //区域设置的货币代码。示例货币代码包括“USD”、“EUR”和“JPY”。
            [proDic setValue:pro.priceLocale.currencyCode forKey:@"priceCurrencyCode"];
            //区域设置的货币符号。示例货币符号包括“$”、“€”和“¥”。
            [proDic setValue:pro.priceLocale.currencySymbol forKey:@"symbol"];
        
            
            /**
             折扣
             */
            if (@available(iOS 12.2, *)) {
                if(pro.discounts){
                    NSMutableArray *discountArr = [NSMutableArray array];
                    for(SKProductDiscount *discount in pro.discounts){
                        NSMutableDictionary *discountDic = [NSMutableDictionary dictionary];
                        [discountDic setValue:discount.identifier forKey:@"discount.identifier"];
                        [discountDic setValue:@(discount.type) forKey:@"discount.type"];
                        [discountDic setValue:discount.price forKey:@"discount.price"];
                        //SKProductDiscountPaymentModePayAsYouGo = 0 随用随付,SKProductDiscountPaymentModePayUpFront = 1 提前支付,SKProductDiscountPaymentModeFreeTrial = 2 免费试用
                        [discountDic setValue:@(discount.paymentMode) forKey:@"discount.paymentMode"];
                        //产品折扣可用的周期数
                        [discountDic setValue:@(discount.numberOfPeriods) forKey:@"discount.numberOfPeriods"];
                        
                        [discountArr addObject:discountDic];
                    }
                    [proDic setObject:discountArr forKey:@"discounts"];
                }
            } else {
                // Fallback on earlier versions
            }
            
            //订阅所属的订阅组的标识符
            if (@available(iOS 12.0, *)) {
                [proDic setValue:pro.subscriptionGroupIdentifier forKey:@"subscriptionGroupIdentifier"];
            } else {
                // Fallback on earlier versions
            }
            
            /**
             subscriptionPeriod 订阅产品的期间详细信息
             */
            if (@available(iOS 11.2, *)) {
                //For example, if the number of units is 3, and the unit is SKProductPeriodUnitMonth, the subscription period is 3 months.
                if(pro.subscriptionPeriod){
                    //周期类别 SKProductPeriodUnitDay = 0,SKProductPeriodUnitWeek,SKProductPeriodUnitMonth,SKProductPeriodUnitYear
                    [proDic setValue:@(pro.subscriptionPeriod.unit) forKey:@"subscriptionPeriod.unit"];
                    //每个订阅周期的单位数
                    [proDic setValue:@(pro.subscriptionPeriod.numberOfUnits) forKey:@"subscriptionPeriod.numberOfUnits"];
                }
            } else {
                // Fallback on earlier versions
            }
            
            
            [productArr addObject:proDic];
        }
        
        [self productInfo:productArr];
        
        return;
    }
    
    for (SKProduct *product in products) {
        MCOLog(@"product info : %@",product);
        MCOLog(@"SKProduct 无效商品描述信息%@",response.invalidProductIdentifiers);
        MCOLog(@"产品标题 %@" , product.localizedTitle);
        MCOLog(@"产品描述信息: %@" , product.localizedDescription);
        MCOLog(@"价格: %@" , product.price);
        MCOLog(@"商品IDProduct id: %@" , product.productIdentifier);
    }
    
    //如果服务器没有产品
    if ([products count]==0) {
        MCOLog(@"没有商品");
        [self payInfo:@"没有商品" stateInfo:MCOSDKPayProductIdInvalid gameOrderId:@""];
    }
    
    SKProduct *product = nil;
    for (SKProduct *pro in products) {
        if ([pro.productIdentifier isEqualToString:self.payOrder.productID]) {
            product = pro;
            break;
        }
    }
    
    if (product) {
        //发送购买请求
        //创建内购订单，加入苹果内购交易队列
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
        //将订单号存储到payment的applictionUserName字段
        payment.applicationUsername = self.order_id;
        //发送内购请求
        if ([SKPaymentQueue defaultQueue]) {
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
    }
}

-(void)purchasingTransaction:(SKPaymentTransaction *)transaction{
    MCOLog(@"--交易进行中---purchasing----购买交易：%@ ",transaction);
    
}

- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {

    for(NSInteger i = 0;i < [transactions count]; ++i){
        SKPaymentTransaction *transaction = (SKPaymentTransaction*)transactions[i];
        
        switch (((SKPaymentTransaction*)transactions[i]).transactionState) {
            case SKPaymentTransactionStatePurchased:
                MCOLog(@"交易完成");
                //对订阅进行特殊处理
                
                if (transaction.originalTransaction) {
                    //自动续费订单
                    MCOLog(@"苹果返回状态：自动订阅交易完成 originalTransaction = %@",transaction.originalTransaction);
                    [self reportAutoSubscriptions:YES Transaction:transaction];
//                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                }else{
                    //普通购买或第一次购买自动续费产品
                    MCOLog(@"苹果返回状态：交易完成 , transaction = %@",transaction);
                    [self reportOrderSuccessStatus:transaction isAuto:NO];
//                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                }
                break;
                
            case SKPaymentTransactionStateFailed:
                MCOLog(@"苹果返回状态：交易失败-----------code:%ld-----描述：%@ ",transaction.error.code,transaction.error.description);
                [self reportOrderFailStatus:transaction isAuto:NO];
                break;
            case SKPaymentTransactionStateRestored://已经购买过的商品 非消耗型商品
                MCOLog(@"苹果返回状态：事务从用户的购买历史中恢复。客户应完成交易。已经购买过");
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                MCOLog(@"苹果返回状态：商品添加进列表");
                [self purchasingTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                //例如家长模式时存在此情况
                MCOLog(@"苹果返回状态：事务在队列中，但其最终状态是等待外部操作。");
                break;
            default:
                MCOLog(@"苹果返回状态：default状态");
                break;
        }
    }
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    //交易失败
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    MCOLog(@"restoreCompletedTransactionsFailedWithError 恢复失败");
}

//服务端上报成功订单内容
-(void)reportOrderSuccessStatus:(SKPaymentTransaction *)transaction isAuto:(BOOL)isAuto{
    
    if(![publicMath isBlankString:[MCOOSSDKCenter MCOShareSDK].saveUUID]){
        MCOLog(@"pay uuid is null");
        return;
    }
    
    //获取票据信息
    NSURL *receiptURL = [NSBundle mainBundle].appStoreReceiptURL;
    if(![[NSFileManager defaultManager] fileExistsAtPath:receiptURL.path])
    {
        SKReceiptRefreshRequest *receiptRefreshRequest = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:nil];
        receiptRefreshRequest.delegate = self;
        [receiptRefreshRequest start];
    }
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString *receiptDataString = [publicMath jptbase64StringFromData:receiptData length:[receiptData length]];
    
    //上报票据
    [self reportReceipt:transaction receiptDataString:receiptDataString];
    
    //从本地存储的信息中找到和本次SKPaymentTransaction相同transactionIdentifier的订单信息
    //若本地没有相同的transactionIdentifier的订单，则寻找相同的productId订单信息
    NSArray *nowOrderArr = [self getOrderArr];
    NSMutableArray *saveOrderArr = [self getSaveOrderArr:nowOrderArr];
    
    NSMutableDictionary *tempOrder ;
    
    LeakageOrderModel *nowTransaction = nil;
    
    if(transaction.payment.applicationUsername != nil){
        NSString *applicationUsername = [NSString stringWithFormat:@"%@",transaction.payment.applicationUsername];
        //applicationUsername不为空，则代表有对应服务端的order_id
        if([saveOrderArr count] > 0){
            //本地存在订单数据
            for (NSMutableDictionary *getDic in saveOrderArr) {
                
                LeakageOrderModel *leakage = [[LeakageOrderModel alloc] initWithShowInfor:getDic];
                NSString *orderId = [NSString stringWithFormat:@"%@",leakage.order_id];
                if ([orderId isEqualToString:applicationUsername]) {
                    //本地找到了对应order_id的订单
                    //更新本地数据
                    NSMutableDictionary *tempGetDic = [NSMutableDictionary dictionaryWithDictionary:getDic];
                    tempOrder = tempGetDic;
                    [tempOrder setObject:@"1" forKey:@"status"];
                    [tempOrder setObject:transaction.transactionIdentifier forKey:@"transactionIdentifier"];
                    if ([[tempOrder objectForKey:@"isVerify"] boolValue] == YES) {
                        receiptData = transaction.transactionReceipt;
                        receiptDataString =  [publicMath jptbase64StringFromData:receiptData length:[receiptData length]];
                    }
//                    [tempOrder setObject:receiptDataString forKey:@"receipt"];
                    [self removeOrderArr:getDic];
                    [self saveOrderArr:tempOrder];
                    
                    nowTransaction = leakage;
                    break;
                }
            }
        }else{
            //本地不存在订单
            
        }
    }else{
        //applicationUsername为空，代表苹果存储的该订单已经没有存储的order_id了，说明该订单是没有被finish的订单
    //需要根据transactionIdentifier查找在本地存储的信息；若没有对应的transactionIdentifier的本地订单则根据productId进行查找
        
        if([saveOrderArr count] > 0){
            //本地存在订单数据
            for (NSMutableDictionary *getDic in saveOrderArr) {
                LeakageOrderModel *leakage = [[LeakageOrderModel alloc]initWithShowInfor:getDic];
                if ([leakage.transactionIdentifier isEqualToString:transaction.transactionIdentifier]) {
                    //本地找到了对应transactionIdentifier的订单
                    NSMutableDictionary *tempGetDic = [NSMutableDictionary dictionaryWithDictionary:getDic];
                    tempOrder = tempGetDic;
                    
                    if ([[tempOrder objectForKey:@"isVerify"] boolValue] == YES) {
                        receiptData = transaction.transactionReceipt;
                        receiptDataString =  [publicMath jptbase64StringFromData:receiptData length:[receiptData length]];
                    }
//                    [tempOrder setObject:receiptDataString forKey:@"receipt"];
                    
                    
                    nowTransaction = leakage;
                    break;
                }
            }
            
            if (nowTransaction == nil) {
                for (NSMutableDictionary *getDic in saveOrderArr) {
                    LeakageOrderModel *leakage = [[LeakageOrderModel alloc]initWithShowInfor:getDic];
                    if ([leakage.productIdentifier isEqualToString:transaction.payment.productIdentifier]) {
                        //本地找到了对应productIdentifier的订单
                        NSMutableDictionary *tempGetDic = [NSMutableDictionary dictionaryWithDictionary:getDic];
                        tempOrder = tempGetDic;
                        [tempOrder setObject:@"1" forKey:@"status"];
                        [tempOrder setObject:transaction.transactionIdentifier forKey:@"transactionIdentifier"];
//                        [tempOrder setObject:receiptDataString forKey:@"receipt"];
                        
                        [self removeOrderArr:getDic];
                        [self saveOrderArr:tempOrder];
                        leakage.transactionIdentifier = transaction.transactionIdentifier;
                        nowTransaction = leakage;
                        break;
                    }
                }
            }
            
        }else{
            //本地不存在订单数据
            //一般不存在该情况
            
        }
        
    }
    
    if (nowTransaction != nil) {
    
        NSDictionary *params = @{
            @"uuid":[MCOOSSDKCenter MCOShareSDK].saveUUID,
            @"token":[MCOOSSDKCenter MCOShareSDK].saveToken,
            @"receipt_data":receiptDataString,
            @"order_token":nowTransaction.token,
            @"order_id":nowTransaction.order_id,
            @"pay_time":[GetDeviceData getTimeStp],
            @"status":@"1",
            @"user_name":nowTransaction.user_name,
            @"transactionIdentifier":transaction.transactionIdentifier,
        };
        
        [HttpRequest POSTRequestWithUrlString:MCO_IOS_Pay isPay:YES headerDic:nil parameters:params successBlock:^(id result) {
            MCOLog(@"成功订单上报结果返回成功-------:%@",result[@"msg"]);
            [self finishTransaction:transaction];
            if (saveOrderArr.count>0) {
                [self removeOrderArr:tempOrder];
            }
            if (!isAuto) {
                [self payInfo:@"支付成功" stateInfo:MCOSDKPaySuccess gameOrderId:tempOrder[@"extra"]];
            }
          } serverErrorBlock:^(id result) {
              MCOLog(@"上报结果返回验证失败-------:%@",result);
              //此时会finish该订单信息
              if ([result[@"error"] intValue] == 1) {
                  NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:tempOrder];
                  [mutableDic setObject:@YES forKey:@"isVerify"];
                  [self removeOrderArr:tempOrder];
                  [self saveOrderArr:mutableDic];
                  [self createTimer];
                  MCOLog(@"苹果订单票据信息已存在");
              }else{
                  [self finishTransaction:transaction];
                  if (saveOrderArr.count>0) {
                      [self removeOrderArr:tempOrder];
                  }
              }

              if (!isAuto) {
                  [self payInfo:@"支付失败2" stateInfo:MCOSDKPayFailure gameOrderId:tempOrder[@"extra"]];

              }

          } failBlock:^{
              MCOLog(@"服务器错误");
              if (!isAuto) {
                  [self payInfo:@"服务器错误" stateInfo:MCOSDKPayFailure gameOrderId:tempOrder[@"extra"]];
              }
              [self createTimer];
          }];
        
    }else{
        //一般不存在该情况
        if ([publicMath isBlankString:receiptDataString]) {
            [self finishTransaction:transaction];
        }
        
        if (!isAuto) {
            if (self.payOrder.extra) {
                [self payInfo:@"支付失败3" stateInfo:MCOSDKPayFailure gameOrderId:self.payOrder.extra];
            }else{
                [self payInfo:@"支付失败3" stateInfo:MCOSDKPayFailure gameOrderId:@""];
            }
            
        }
    }
}

//服务端上报失败订单内容
-(void)reportOrderFailStatus:(SKPaymentTransaction *)transaction isAuto:(BOOL)isAuto{

    NSString *receiptDataString = [NSString stringWithFormat:@"%@",transaction.error];
    MCOLog(@"购买失败描述错误--------receiptDataString %@ = ",receiptDataString);
    
    if (![publicMath isBlankString:[MCOOSSDKCenter MCOShareSDK].saveUUID]) {
        MCOLog(@"pay uuid is null");
        return;
    }
    
    //从本地存储的信息中找到和本次SKPaymentTransaction相同transactionIdentifier的订单信息
    //若本地没有相同的transactionIdentifier的订单，则寻找相同的productId订单信息
    NSArray *nowOrderArr = [self getOrderArr];
    NSMutableArray *saveOrderArr = [self getSaveOrderArr:nowOrderArr];
    
    NSMutableDictionary *tempOrder;
    
    LeakageOrderModel *nowTransaction = nil;
    
    if(transaction.payment.applicationUsername != nil){
        NSString *applicationUsername = [NSString stringWithFormat:@"%@",transaction.payment.applicationUsername];
        //applicationUsername不为空，则代表有对应服务端的order_id
        if([saveOrderArr count] > 0){
            //本地存在订单数据
            for (NSMutableDictionary *getDic in saveOrderArr) {
                LeakageOrderModel *leakage = [[LeakageOrderModel alloc]initWithShowInfor:getDic];
                NSString *order_id = [NSString stringWithFormat:@"%@",leakage.order_id];
                if ([order_id isEqualToString:applicationUsername]) {
                    
                    NSMutableDictionary *tempGetDic = [NSMutableDictionary dictionaryWithDictionary:getDic];
                    tempOrder = tempGetDic;
                    [tempOrder setObject:@"0" forKey:@"status"];
                    if([publicMath isBlankString:transaction.transactionIdentifier]){
                        [tempOrder setObject:transaction.transactionIdentifier forKey:@"transactionIdentifier"];
                    }
                    [self removeOrderArr:getDic];
                    [self saveOrderArr:tempOrder];
                    
                    //本地找到了对应order_id的订单
                    nowTransaction = leakage;
                    break;
                }
            }
        }else{
            //本地不存在订单
            //一般不存在该情况
            MCOLog(@"本地不存在订单");
        }
    }else{
        //applicationUsername为空，代表找不到对应的order_id
    //需要根据transactionIdentifier查找在本地存储的信息；若没有对应的transactionIdentifier的本地订单则根据productId进行查找
        
        if([saveOrderArr count] > 0){
            //本地存在订单数据
            for (NSMutableDictionary *getDic in saveOrderArr) {
                LeakageOrderModel *leakage = [[LeakageOrderModel alloc]initWithShowInfor:getDic];
                if ([publicMath isBlankString:transaction.transactionIdentifier]&&[leakage.transactionIdentifier isEqualToString:transaction.transactionIdentifier]) {
                    //本地找到了对应transactionIdentifier的订单
                    NSMutableDictionary *tempGetDic = [NSMutableDictionary dictionaryWithDictionary:getDic];
                    tempOrder = tempGetDic;
                    nowTransaction = leakage;
                    break;
                }
            }
            
            if (nowTransaction == nil) {
                for (NSMutableDictionary *getDic in saveOrderArr) {
                    LeakageOrderModel *leakage = [[LeakageOrderModel alloc]initWithShowInfor:getDic];
                    if ([publicMath isBlankString:leakage.transactionIdentifier]==NO
                        &&[leakage.productIdentifier isEqualToString:transaction.payment.productIdentifier]) {
                        //本地找到了对应productIdentifier的订单
                        NSMutableDictionary *tempGetDic = [NSMutableDictionary dictionaryWithDictionary:getDic];
                        tempOrder = tempGetDic;
                        [tempOrder setObject:@"0" forKey:@"status"];
                        if([publicMath isBlankString:transaction.transactionIdentifier]){
                            [tempOrder setObject:transaction.transactionIdentifier forKey:@"transactionIdentifier"];
                        }
                        [self removeOrderArr:getDic];
                        [self saveOrderArr:tempOrder];
                        
                        nowTransaction = leakage;
                        break;
                    }
                }
            }
        }else{
            //本地不存在订单数据
            //一般不存在该情况
            MCOLog(@"本地不存在订单");
        }
        
    }
    
    if (nowTransaction != nil) {
        
        NSDictionary *params_dic= @{
            @"uuid":[MCOOSSDKCenter MCOShareSDK].saveUUID,
            @"token":[MCOOSSDKCenter MCOShareSDK].saveToken,
            @"receipt_data":receiptDataString,
            @"order_token":nowTransaction.token,
            @"order_id":nowTransaction.order_id,
            @"pay_time":[GetDeviceData getTimeStp],
            @"status":@"0", //失败订单
            @"user_name":nowTransaction.user_name,
        };
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:params_dic];
        
        if ([publicMath isBlankString:transaction.transactionIdentifier]) {
            [params setValue:transaction.transactionIdentifier forKey:@"transactionIdentifier"];
        }
        
        [HttpRequest POSTRequestWithUrlString:MCO_IOS_Pay isPay:YES headerDic:nil parameters:params successBlock:^(id result) {
            MCOLog(@"失败上报结果返回成功-------:%@",result[@"msg"]);
            [self finishErrorOrder:transaction extra:tempOrder[@"extra"]];
            if (saveOrderArr.count > 0) {
                [self removeOrderArr:tempOrder];
            }
          } serverErrorBlock:^(id result) {
              MCOLog(@"上报结果返回失败-------:%@",result);
              //此时会finish该订单信息
              [self finishTransaction:transaction];
              if (saveOrderArr.count>0) {
                  [self removeOrderArr:tempOrder];
              }
              if (!isAuto) {
                  [self payInfo:@"支付失败2" stateInfo:MCOSDKPayFailure gameOrderId:tempOrder[@"extra"]];

              }
          } failBlock:^{
              MCOLog(@"服务器错误");
              if (!isAuto) {
                  [self payInfo:@"支付失败2" stateInfo:MCOSDKPayFailure gameOrderId:tempOrder[@"extra"]];
              }
//              [self createTimer];
          }];
        
    }else{
        //一般不存在该情况
        MCOLog(@"本地不存在订单");
        [self finishTransaction:transaction]; 
        if (!isAuto) {
            if (self.payOrder.extra) {
                [self payInfo:@"支付失败2" stateInfo:MCOSDKPayFailure gameOrderId:self.payOrder.extra];
            }else{
                [self payInfo:@"支付失败3" stateInfo:MCOSDKPayFailure gameOrderId:@""];
            }
            
        }
    }
}

- (void)dealloc {
    if ([SKPaymentQueue defaultQueue]) {
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    }
}


//支付信息和状态
-(void)payInfo:(NSString *)pay stateInfo:(MCOSDKPayState)state gameOrderId:(NSString *)gameOrderId{
    [[MCOOSSDKCenter MCOShareSDK] paySuccess:pay payState:state gameOrderId:gameOrderId];
}

//非消耗商品恢复信息
-(void)restoreInfo:(MCOSDKRestoreState)state restoreArray:(NSMutableArray *)restoreArray {
    [[MCOOSSDKCenter MCOShareSDK] restoreSuccess:state restoreArray:restoreArray];
}

//
-(void)productInfo:(NSMutableArray *)productArray{
    if([productArray count] > 0){
        [[MCOOSSDKCenter MCOShareSDK] productSuccess:productArray];
    }
}

-(void)autoPay:(BOOL)isRepeat{
    MCOLog(@"autoPay====----====");
    if (isRepeat) {
        //定时任务
        if (repeatTime > 2) {
            //大于两次后取消定时服务
            MCOLog(@"repeatTime = %d,结束循环",repeatTime);
            [self suspendTimer];
            return;
        }
        repeatTime++;
    }
    
    MCOLog(@"repeatTime = %d",repeatTime);
    
    //遍历Queen
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;

    if (transactions.count > 0 ) {
        //检测苹果是否有未完成的交易且本地也存在订单数据
        for(NSInteger i = 0;i < [transactions count]; ++i){
            SKPaymentTransaction *transaction = (SKPaymentTransaction*)transactions[i];
            switch (transaction.transactionState) {
                case SKPaymentTransactionStatePurchased:
                    MCOLog(@"autoPay 购买成功");
                    //对订阅进行特殊处理
                    if (transaction.originalTransaction) {
                        //自动续费订单
                        MCOLog(@"苹果返回状态：自动订阅交易完成 originalTransaction = %@",transaction.originalTransaction);
                        [self reportAutoSubscriptions:YES Transaction:transaction];
                    }else{
                        //普通购买或第一次购买自动续费产品
                        MCOLog(@"苹果返回状态：交易完成 , transaction = %@",transaction);
                        [self reportOrderSuccessStatus:transaction isAuto:YES];
                    }
                    break;
                case SKPaymentTransactionStateFailed:
                    MCOLog(@"苹果返回状态：交易失败-----------code:%ld-----描述：%@ ",transaction.error.code,transaction.error.description);
                    [self reportOrderFailStatus:transaction isAuto:YES];
                    break;
                case SKPaymentTransactionStateRestored://已经购买过的商品 非消耗型商品
                    MCOLog(@"苹果返回状态：事务从用户的购买历史中恢复。客户应完成交易。已经购买过");
                    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                    break;
                case SKPaymentTransactionStatePurchasing:
                    MCOLog(@"苹果返回状态：商品添加进列表");
                       [self purchasingTransaction:transaction];
                    break;
                case SKPaymentTransactionStateDeferred:
                    //例如家长模式时存在此情况
                    MCOLog(@"苹果返回状态：事务在队列中，但其最终状态是等待外部操作。");
                    break;
                default:
                    MCOLog(@"苹果返回状态：default状态");
                    break;
            }
        }
    }else{
        //定时任务
        if (isRepeat) {
            //无需要补单的内容，取消循环
            MCOLog(@"无需要补单的内容，取消循环");
            [self suspendTimer];
        }
    }
}

//自动订阅支付上报
-(void)reportAutoSubscriptions:(BOOL)status Transaction:(SKPaymentTransaction*)transaction{
    
    if (![publicMath isBlankString:[MCOOSSDKCenter MCOShareSDK].saveUUID]) {
        MCOLog(@"pay uuid is null");
        return;
    }
    
    NSString *receiptDataString = @"";
    NSString *transactionIdentifier = transaction.transactionIdentifier;
    NSString *originalTransactionId = transaction.originalTransaction.transactionIdentifier;
    
    NSURL *receiptURL = [NSBundle mainBundle].appStoreReceiptURL;
    if(![[NSFileManager defaultManager] fileExistsAtPath:receiptURL.path])
    {
        SKReceiptRefreshRequest *receiptRefreshRequest = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:nil];
        receiptRefreshRequest.delegate = self;
        [receiptRefreshRequest start];
    }
    
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    receiptDataString = [publicMath jptbase64StringFromData:receiptData length:[receiptData length]];

    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    if (transaction.payment.applicationUsername != nil) {
        NSString *applicationUsername = [NSString stringWithFormat:@"%@",transaction.payment.applicationUsername];
        [params setObject:transaction.payment.applicationUsername forKey:@"order_id"];
    }
    [params setObject:[MCOOSSDKCenter MCOShareSDK].saveUUID forKey:@"uuid"];
    [params setObject:[MCOOSSDKCenter MCOShareSDK].saveToken forKey:@"token"];
    [params setObject:receiptDataString forKey:@"receipt_data"];
    [params setObject:originalTransactionId forKey:@"original_transaction_id"];
    [params setObject:transactionIdentifier forKey:@"transactionIdentifier"];
    [params setObject:[GetDeviceData getTimeStp] forKey:@"pay_time"];
    [params setObject:transaction.payment.productIdentifier forKey:@"product_id"];
    [params setObject:[GetDeviceData getIDFV] forKey:@"user_name"];
    
    [HttpRequest POSTRequestWithUrlString:MCO_AutoSubscriptionOrder isPay:YES headerDic:nil parameters:params successBlock:^(id result) {
        MCOLog(@"订阅结果返回成功-------:%@",result[@"msg"]);
        [self finishTransaction:transaction];
        if ([publicMath isBlankString:self.payOrder.extra]) {
            [self payInfo:@"续费成功" stateInfo:MCOSDKPaySuccess gameOrderId:self.payOrder.extra];
        }else{
            [self payInfo:@"续费成功" stateInfo:MCOSDKPaySuccess gameOrderId:@""];
        }
        
    } serverErrorBlock:^(id result) {
        MCOLog(@"订阅结果返回失败-------:%@",result);
        [self finishTransaction:transaction];
        if ([publicMath isBlankString:self.payOrder.extra]) {
            [self payInfo:@"续费失败" stateInfo:MCOSDKPayFailure gameOrderId:self.payOrder.extra];
        }else{
            [self payInfo:@"续费失败" stateInfo:MCOSDKPayFailure gameOrderId:@""];
        }
        
    } failBlock:^{
        MCOLog(@"订阅结果-服务器错误");
        if ([publicMath isBlankString:self.payOrder.extra]) {
            [self payInfo:@"续费失败" stateInfo:MCOSDKPayFailure gameOrderId:self.payOrder.extra];
        }else{
            [self payInfo:@"续费失败" stateInfo:MCOSDKPayFailure gameOrderId:@""];
        }
    }];
}

//finish失败订单
-(void)finishErrorOrder:(SKPaymentTransaction*)transaction extra:(NSString*) extra{
    switch (transaction.error.code) {
        case NSURLErrorTimedOut:
            [self finishTransaction:transaction];
            [self payInfo:@"time out" stateInfo:MCOSDKPayFailure gameOrderId:extra];
            break;
        case SKErrorUnknown:
            [self finishTransaction:transaction];
            [self payInfo:@"unknown error" stateInfo:MCOSDKPayFailure gameOrderId:extra];
            break;
        case SKErrorCloudServiceNetworkConnectionFailed:
            [self finishTransaction:transaction];
            [self payInfo:@"Service Network Connection Failed" stateInfo:MCOSDKPayFailure gameOrderId:extra];
            break;
        case SKErrorPaymentCancelled:
            [self finishTransaction:transaction];
            [self payInfo:@"user cancelled the request" stateInfo:MCOSDKPayCancel gameOrderId:extra];
            break;
        case SKErrorClientInvalid:
            [self finishTransaction:transaction];
            [self payInfo:@"client is not allowed to issue the request" stateInfo:MCOSDKPayFailure gameOrderId:extra];
            break;
        case SKErrorPaymentInvalid:
            [self finishTransaction:transaction];
            [self payInfo:@"purchase identifier was invalid" stateInfo:MCOSDKPayProductIdInvalid gameOrderId:extra];
            break;
        case SKErrorPaymentNotAllowed:
            [self finishTransaction:transaction];
            [self payInfo:@"client is not allowed to issue the request" stateInfo:MCOSDKPayFailure gameOrderId:extra];
            break;
        case SKErrorStoreProductNotAvailable:
            [self finishTransaction:transaction];
            [self payInfo:@"Product is not available" stateInfo:MCOSDKPayProductIdInvalid gameOrderId:extra];
            break;
        case SKErrorInvalidOfferIdentifier:
            [self finishTransaction:transaction];
            [self payInfo:@"The specified subscription offer identifier is not valid" stateInfo:MCOSDKPayProductIdInvalid gameOrderId:extra];
            break;
        case SKErrorInvalidSignature:
            [self finishTransaction:transaction];
            [self payInfo:@"The cryptographic signature provided is not valid" stateInfo:MCOSDKPayProductIdInvalid gameOrderId:extra];
            break;
        case SKErrorMissingOfferParams:
            [self finishTransaction:transaction];
            [self payInfo:@"One or more parameters from SKPaymentDiscount is missing" stateInfo:MCOSDKPayInfoLess gameOrderId:extra];
            break;
        case SKErrorInvalidOfferPrice:
            [self finishTransaction:transaction];
            [self payInfo:@"The price of the selected offer is not valid" stateInfo:MCOSDKPayProductIdInvalid gameOrderId:extra];
            break;
        default:
            [self finishTransaction:transaction];
            [self payInfo:@"支付失败1" stateInfo:MCOSDKPayFailure gameOrderId:extra];
            break;
    }
}

-(void)finishTransaction:(SKPaymentTransaction *)transaction{
    if ([SKPaymentQueue defaultQueue]&&transaction!=nil) {
        [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    }
}

-(void)createTimer{
    repeatTime=0;
    if (timer==nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 60*NSEC_PER_SEC), 60*NSEC_PER_SEC, 0.1*NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            [self autoPay:true];
        });
    }else{
        [self suspendTimer];
    }
    if (startTimer==NO) {
        dispatch_resume(timer);
        startTimer = YES;
    }
}

-(void)suspendTimer{
    if (startTimer==YES) {
        dispatch_suspend(timer);
        startTimer = NO;
    }
}

-(NSArray*)getOrderArr{
    NSData *orderData = [MCOSAMKeychain passwordDataForService:@"newOrder" account:@"list"];
    NSArray *orderArr = [NSKeyedUnarchiver unarchiveObjectWithData:orderData];
    return orderArr;
}

//NSArray转为NSMutableArray
-(NSMutableArray*) getSaveOrderArr:(NSArray*)orderArr{
    NSMutableArray *saveOrderArr = [NSMutableArray arrayWithArray:orderArr];
    return saveOrderArr;
}


/**
 dic:本次需要存储的订单信息
 saveOrderArr: 本地现在有的订单信息数组
 */
-(void)saveOrderArr:(NSDictionary *)dic{
    NSArray *orderArr = [self getOrderArr];
    NSMutableArray *saveOrderArr = [self getSaveOrderArr:orderArr];
    
    [saveOrderArr addObject:dic];
    orderArr = saveOrderArr;
    NSData *orderTemp = [NSKeyedArchiver archivedDataWithRootObject:orderArr];
    [MCOSAMKeychain setPasswordData:orderTemp forService:@"newOrder" account:@"list"];
}

-(void)removeOrderArr:(NSDictionary *)dic{
    NSArray *nowOrderArr = [self getOrderArr];
    NSMutableArray *saveOrderArr = [self getSaveOrderArr:nowOrderArr];
    
    [saveOrderArr removeObject:dic];
    NSArray *arr = [saveOrderArr copy];
    NSData *orderTemp = [NSKeyedArchiver archivedDataWithRootObject:arr];
    //keyChain存储
    [MCOSAMKeychain setPasswordData:orderTemp forService:@"newOrder" account:@"list"];
}
 
-(void)requestDidFinish:(SKRequest *)request {
    if([request isKindOfClass:[SKReceiptRefreshRequest class]])
    {
        //SKReceiptRefreshRequest
        NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[receiptUrl path]]) {
            MCOLog(@"App Receipt exists");
        }else{
            MCOLog(@"已完成刷新收据请求，但没有收据");
          }
      }
    MCOLog(@"信息反馈结束：%@",request);
  }


-(void)reportReceipt:(SKPaymentTransaction *)transaction receiptDataString:(NSString *)receiptDataString{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if (![publicMath isBlankString:[user objectForKey:@"uuid"]]) {
        MCOLog(@"pay uuid is null");
        return;
    }
    
    NSMutableDictionary * params = [NSMutableDictionary new];
    [params setObject:[user objectForKey:@"uuid"] forKey:@"uuid"];
    [params setObject:[user objectForKey:@"token"] forKey:@"token"];
    if ([publicMath isBlankString:transaction.transactionIdentifier]) {
        [params setObject:transaction.transactionIdentifier forKey:@"transaction_id"];
    }
    if ([publicMath isBlankString:transaction.payment.productIdentifier]) {
        [params setObject:transaction.payment.productIdentifier forKey:@"product_id"];
    }
    if ([publicMath isBlankString:receiptDataString]) {
        [params setObject:receiptDataString forKey:@"receipt_data"];
    }
    if (transaction.payment.applicationUsername != nil) {
        [params setObject:transaction.payment.applicationUsername forKey:@"order_id"];
    }

    
    [HttpRequest POSTRequestWithUrlString:MCO_Report_Receipt isPay:YES headerDic:nil parameters:params successBlock:^(id result) {
        MCOLog(@"订单票据信息上报成功 result = %@",result);
        
    } serverErrorBlock:^(id result) {
        MCOLog(@"订单票据信息上报失败 result = %@",result);
        
    } failBlock:^{
        MCOLog(@"订单上报票据信息失败，服务端错误");
        [self repeatReportRecepit:params transaction:transaction];
    }];
}
-(void)repeatReportRecepit:(NSDictionary *)params transaction:(SKPaymentTransaction *)transaction{
    [HttpRequest POSTRequestWithUrlString:MCO_Report_Receipt isPay:YES headerDic:nil parameters:params successBlock:^(id result) {
        MCOLog(@"订单票据信息再次上报成功 result = %@",result);
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:result[@"msg"] forKey:@"restoreMsg"];
        [user synchronize];
    } serverErrorBlock:^(id result) {
        MCOLog(@"订单票据信息再次上报失败 result = %@",result);
        
    } failBlock:^{
        MCOLog(@"订单上报票据再次信息失败，服务端错误");
        
    }];
}

-(void)restoreTransaction:(SKPaymentTransaction *)transaction{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (![publicMath isBlankString:[user objectForKey:@"uuid"]]) {
        MCOLog(@"pay uuid is null");
        return;
    }
    NSMutableDictionary * params = [NSMutableDictionary new];
    [params setObject:[user objectForKey:@"uuid"] forKey:@"uuid"];
    [params setObject:[user objectForKey:@"token"] forKey:@"token"];
    [params setObject:@"10" forKey:@"order_status"];
    
    NSDictionary *restoreDic = [user objectForKey:@"restoreDic"];
    NSString *restoreJson = [self convertToJsonData:restoreDic];
    [params setObject:restoreJson forKey:@"restore_json"];
    
    if ([publicMath isBlankString:transaction.originalTransaction.transactionIdentifier]) {
        [params setObject:transaction.originalTransaction.transactionIdentifier forKey:@"transaction_id"];
    }
    
    if ([publicMath isBlankString:transaction.payment.productIdentifier]) {
        [params setObject:transaction.payment.productIdentifier forKey:@"product_id"];
    }
    
    NSURL *receiptURL = [NSBundle mainBundle].appStoreReceiptURL;
    if(![[NSFileManager defaultManager] fileExistsAtPath:receiptURL.path])
    {
        SKReceiptRefreshRequest *receiptRefreshRequest = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:nil];
        receiptRefreshRequest.delegate = self;
        [receiptRefreshRequest start];
    }
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString *receiptDataString = [publicMath jptbase64StringFromData:receiptData length:[receiptData length]];
    [params setObject:receiptDataString forKey:@"receipt_data"];
    
    
    [HttpRequest POSTRequestWithUrlString:MCO_Report_Receipt isPay:YES headerDic:nil parameters:params successBlock:^(id result) {
        MCOLog(@"恢复购买上报数据成功 = %@",result);
        [user setObject:result[@"msg"] forKey:@"restoreMsg"];
        [user synchronize];
    } serverErrorBlock:^(id result) {
        MCOLog(@"恢复购买上报数据失败");
    } failBlock:^{
        MCOLog(@"恢复购买访问服务器失败");
        [self repeatReportRecepit:params transaction:transaction];
    }];
}


//适用于正常恢复
-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    self.restoreArray = [[NSMutableArray alloc]init];
    
    MCOLog(@"非消耗产品 received restored transactions:%i",queue.transactions.count);
    for(SKPaymentTransaction *transaction in queue.transactions){
        if (![self.restoreArray containsObject:transaction.payment.productIdentifier]) {
            //array中没有该product_id
            [self.restoreArray addObject:transaction.payment.productIdentifier];
            [self restoreTransaction:transaction];
        }
    }
    
    MCOLog(@"restoreArray size : %d",self.restoreArray.count);

    if (self.restoreArray.count > 0) {
        [self restoreInfo:MCOSDKRestoreSuccess restoreArray:self.restoreArray];
    }else{
        [self restoreInfo:MCOSDKRestoreNoProduct restoreArray:self.restoreArray];
    }
    
}

-(NSString *)convertToJsonData:(NSDictionary *)dic
{
    NSError *error = nil;
    NSData *jsonData = nil;
    if (!self) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *keyString = nil;
        NSString *valueString = nil;
        if ([key isKindOfClass:[NSString class]]) {
            keyString = key;
        }else{
            keyString = [NSString stringWithFormat:@"%@",key];
        }

        if ([obj isKindOfClass:[NSString class]]) {
            valueString = obj;
        }else{
            valueString = [NSString stringWithFormat:@"%@",obj];
        }

        [dict setObject:valueString forKey:keyString];
    }];
    jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] == 0 || error != nil) {
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;


}

@end
