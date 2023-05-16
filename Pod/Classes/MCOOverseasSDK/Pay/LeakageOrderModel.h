//
//  LeakageOrderModel.h
//  MCOStandAlone
//
//  Created by 王都都 on 2019/9/2.
//  Copyright © 2019 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeakageOrderModel : NSObject

@property(nonatomic,copy) NSString* order_id;
@property(nonatomic,copy) NSString* token;
@property(nonatomic,copy) NSString* user_name;
@property(nonatomic,copy) NSString* transactionIdentifier;
@property(nonatomic,copy) NSString* status;
@property(nonatomic,copy) NSString* productIdentifier;

-initWithShowInfor:(NSDictionary *)Infor;

@end
