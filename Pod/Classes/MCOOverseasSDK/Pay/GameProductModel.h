//
//  GameProductModel.h
//  MCOStandAlone
//
//  Created by 王都都 on 2019/8/23.
//  Copyright © 2019 test. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameProductModel : NSObject

@property (nonatomic, copy) NSString * money;//金额

@property (nonatomic, copy) NSString * product_id;//商品ID

@property (nonatomic, copy) NSString * product_name;//商品名

@property (nonatomic,copy)NSString  *product_type;//商品类型

-initWithShowInfor:(NSDictionary *)Infor;
@end

NS_ASSUME_NONNULL_END

