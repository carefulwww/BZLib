//
//  HttpRequest.h
//  MCOStandAlone
//
//  Created by 王都都 on 2019/8/23.
//  Copyright © 2019 test. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HttpRequest : NSObject
/**
 GET请求
 
 @param urlString 接口地址
 @param headerDic 请求头
 @param parameters 内容
 @param successBlock 请求成功
 @param serverErrorBlock 服务器失败
 @param failBlock 请求失败
 */
+ (void)GETRequestUrlString:(NSString *)urlString
                  headerDic:(NSDictionary *)headerDic
                 parameters:(NSDictionary *)parameters
               successBlock:(void(^)(id result))successBlock
           serverErrorBlock:(void(^)(id result))serverErrorBlock
                  failBlock:(void(^)(void))failBlock;


/**
 POST请求
 
 @param urlString 接口地址
 @param pay 是否是支付
 @param headerDic 请求头
 @param parameters 内容
 @param successBlock 请求成功
 @param serverErrorBlock 服务器失败
 @param failBlock 请求失败
 */
+ (void)POSTRequestWithUrlString:(NSString *)urlString
                           isPay:(BOOL)pay
                       headerDic:(NSDictionary *)headerDic
                      parameters:(NSDictionary *)parameters
                    successBlock:(void(^)(id result))successBlock
                serverErrorBlock:(void(^)(id result))serverErrorBlock
                       failBlock:(void(^)(void))failBlock;



/**
 POST请求     单张图片
 
 @param urlString 接口地址
 @param headerDic 请求头
 @param parameters 内容
 @param image 图片
 @param imageName 图片名称
 @param successBlock 请求成功
 @param serverErrorBlock 服务器失败
 @param failBlock 请求失败
 */
+ (void)POSTRequestUploadImageWithUrlString:(NSString *)urlString
                                  headerDic:(NSDictionary *)headerDic
                                 parameters:(NSDictionary *)parameters
                                      image:(UIImage *)image
                                  imageName:(NSString *)imageName
                               successBlock:(void(^)(id result))successBlock
                           serverErrorBlock:(void(^)(id result))serverErrorBlock
                                  failBlock:(void(^)(void))failBlock;


/**
 POST请求     多张图片
 
 @param urlString 接口地址
 @param headerDic 请求头
 @param parameters 内容
 @param imagesNameArray 图片名称
 @param imagesArray 图片
 @param successBlock 请求成功
 @param serverErrorBlock 服务器失败
 @param failBlock 请求失败
 */
+ (void)POSTRequestUploadImageArrayWithUrlString:(NSString *)urlString
                                       headerDic:(NSDictionary *)headerDic
                                      parameters:(NSDictionary *)parameters
                                 imagesNameArray:(NSArray *)imagesNameArray
                                     imagesArray:(NSArray *)imagesArray
                                    successBlock:(void(^)(id result))successBlock
                                serverErrorBlock:(void(^)(id result))serverErrorBlock
                                       failBlock:(void(^)(void))failBlock;


/**
 POST请求
 
 @param urlString 接口地址
 @param headerDic 请求头
 @param parameters 内容
 @param successBlock 请求成功
 @param serverErrorBlock 服务器失败
 @param failBlock 请求失败
 */
+ (void)UnReadCountWithUrlString:(NSString *)urlString
                       headerDic:(NSDictionary *)headerDic
                      parameters:(NSDictionary *)parameters
                    successBlock:(void(^)(id result))successBlock
                serverErrorBlock:(void(^)(id result))serverErrorBlock
                       failBlock:(void(^)(void))failBlock;

@end
