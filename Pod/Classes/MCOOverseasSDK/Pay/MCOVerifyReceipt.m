//
//  MCOVerifyReceipt.m
//  MCODomesticProject
//  向苹果服务端请求验证票据
//  Created on 2022/9/15.
//

#import "MCOVerifyReceipt.h"

//沙盒测试环境验证
#define IAPVerifyReceiptSandboxAPI @"https://sandbox.itunes.apple.com/verifyReceipt"

//正式环境验证
#define IAPVerifyReceiptProxAPI @"https://buy.itunes.apple.com/verifyReceipt"

@implementation MCOVerifyReceipt

/**
 向服务端发送请求验证
 */
+(void)verifyPurchaseWithProductionEnvironment:(NSString *)receiptString appleUrl:(NSString *)appleUrl{
    MCOLog(@"预订 verifyPurchaseWithProductionEnvironment");
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    //1.验证正式环境
    //创建请求to苹果服务器
    NSURL *url = [NSURL URLWithString:appleUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPBody = bodyData;
    request.HTTPMethod = @"POST";
    
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        MCOLog(@"验证票据过程中发生错误 错误信息：%@",error.localizedDescription);
        return;
    }
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    int status = [dic[@"status"] intValue];
    
    MCOLog(@"验证票据结果 status = %d",status);
    
    switch (status) {
        case 0:
        {
            //正式环境验证通过
            NSDictionary *receiptDic = dic[@"receipt"];
            MCOLog(@"验证票据结果 receipt = %@",receiptDic);
            if(receiptDic[@"preorder_date_pst"]){
                MCOLog(@"预订玩家，需要上报票据");
                [self reportBookingData:receiptString];
            }else{
                [MCOSAMKeychain setPassword:@"NO" forService:@"isReportSuc" account:@"list"];
                MCOLog(@"不是预订下载玩家，不需要上报票据");
            }
            break;
        }
            
        case 21007:
            //沙盒环境
            [self verifyPurchaseWithProductionEnvironment:receiptString appleUrl:MCOIAPVerifyReceiptSandboxAPI];
        default:
            break;
    }
    
}

/**
 上报预约数据
 */
+(void)reportBookingData:(NSString *)receiptDataString{
    MCOLog(@"预订 reportBookingData");
    
    NSDictionary *params = @{
        @"uuid":[MCOOSSDKCenter MCOShareSDK].saveUUID,
        @"token":[MCOOSSDKCenter MCOShareSDK].saveToken,
        @"role_id":[MCOOSSDKCenter MCOShareSDK].roleId,
        @"server_id":[MCOOSSDKCenter MCOShareSDK].serverId,
        @"user_name":[MCOOSSDKCenter MCOShareSDK].saveUserName,
        @"product_id":[MCOOSSDKCenter MCOShareSDK].bookingProductID,
        @"receipt_data":receiptDataString,
        @"pay_channel_id":@(3)
    };
    
    [HttpRequest POSTRequestWithUrlString:MCO_Booking_Info_Report isPay:YES headerDic:nil parameters:params successBlock:^(id result) {
        MCOLog(@"预订上报成功 result = %@",result);
        [MCOSAMKeychain setPassword:@"OK" forService:@"isReportSuc" account:@"list"];
    } serverErrorBlock:^(id result) {
        MCOLog(@"预订上报失败 result = %@",result);
    } failBlock:^{
        MCOLog(@"预订上报成功 网络错误");
    }];
    
}

@end
