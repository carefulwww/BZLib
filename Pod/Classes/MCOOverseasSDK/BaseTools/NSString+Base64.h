//
//  NSString+Base64.h
//  MCOStandAlone
//
//  Created by 王都都 on 2019/8/23.
//  Copyright © 2019 test. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Base64)
+ (NSString *) jptbase64StringFromData:(NSData *)data length:(long)length;

@end

NS_ASSUME_NONNULL_END
