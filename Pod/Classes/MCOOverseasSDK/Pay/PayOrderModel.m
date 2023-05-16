//
//  PayOrderModel.m
//  MCOStandAlone
//
//  Created by 王都都 on 2019/8/22.
//  Copyright © 2019 test. All rights reserved.
//

#import "PayOrderModel.h"

@implementation PayOrderModel

-(id)initWithShowInforPrice:(NSString *)price productID:(NSString *)productID{
    
    if (self = [super init]) {
        self.parameters =[[NSMutableDictionary alloc]init];
        self.productID = productID;
        self.productPrice = price;
    }
    return self;
}

-(NSMutableDictionary *)payOrderParameters{
    
//    [self.parameters setValue:@"" forKey:@"uuid"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if([publicMath isBlankString:[user stringForKey:@"uuid"]]){
        [self.parameters setValue:[user stringForKey:@"uuid"] forKey:@"uuid"];
    }else{
        MCOLog(@"支付uuid为空");
        [self.parameters setValue:@"0" forKey:@"uuid"];
    }
    
    if ([publicMath isBlankString:self.user_name]) {
        [self.parameters setValue:self.user_name forKey:@"user_name"];
    }else{
        MCOLog(@"支付userName为空");
        [self.parameters setValue:@"0" forKey:@"user_name"];
    }
    
    if ([publicMath isBlankString:self.token]) {
        [self.parameters setValue:self.token forKey:@"token"];
    }else{
        MCOLog(@"支付token为空");
        [self.parameters setValue:@"0" forKey:@"token"];
    }
    
    [self.parameters setValue:@"3" forKey:@"pay_channel_id"];
    
    if ([publicMath isBlankString:self.productID]) {
        [self.parameters setValue:self.productID forKey:@"product_id"];
    }else{
        MCOLog(@"支付productID为空");
        [self.parameters setValue:@"0" forKey:@"product_id"];
    }
    
    if ([publicMath isBlankString:self.roleName]) {
        [self.parameters setValue:self.roleName forKey:@"role_name"];
    }else{
        MCOLog(@"支付role_name为空");
        [self.parameters setValue:@"" forKey:@"role_name"];
    }
    
    if ([publicMath isBlankString:self.transactionID]) {
        [self.parameters setValue:self.transactionID forKey:@"transaction_id"];
    }else{
        MCOLog(@"支付transaction_id为空");
        [self.parameters setValue:@"" forKey:@"transaction_id"];
    }
    
    
    if ([publicMath isBlankString:self.transactionIdentifier]) {
        [self.parameters setValue:self.transactionIdentifier forKey:@"transactionIdentifier"];
    }else{
        MCOLog(@"支付transactionIdentifier为空");
        [self.parameters setValue:@"" forKey:@"transactionIdentifier"];
    }

    
    if ([publicMath isBlankString:self.gameOrderID]) {
        [self.parameters setValue:self.gameOrderID forKey:@"game_order_id"];
    }else{
        MCOLog(@"支付game_order_id为空");
        [self.parameters setValue:@"" forKey:@"game_order_id"];
    }
    
    
    if ([publicMath isBlankString:self.serverID]) {
        [self.parameters setValue:self.serverID forKey:@"server_id"];
    }else{
        MCOLog(@"支付server_id为空");
        [self.parameters setValue:@"" forKey:@"server_id"];
    }
    
    
    if ([publicMath isBlankString:self.desc]) {
        [self.parameters setValue:self.desc forKey:@"desc"];
    }else{
        MCOLog(@"支付desc为空");
        [self.parameters setValue:@"" forKey:@"desc"];
    }
    
    
    if([publicMath isBlankString:self.extra]){
        [self.parameters setValue:self.extra forKey:@"extra"];
    }else{
        MCOLog(@"支付extra为空");
        [self.parameters setValue:@"" forKey:@"extra"];
    }
    
    if(self.productDetails){
        [self.parameters setValue:[publicMath objectToJson:self.productDetails] forKey:@"product_details"];
    }
    
    return self.parameters;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}



-(id)valueForUndefinedKey:(NSString *)key{
    
    return nil;
    
}

@end

