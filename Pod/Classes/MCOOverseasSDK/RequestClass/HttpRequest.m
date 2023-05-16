//
//  HttpRequest.m
//  MCOStandAlone
//
//  Created by 王都都 on 2019/8/23.
//  Copyright © 2019 test. All rights reserved.
//

#import "HttpRequest.h"

/**
 GET请求
 
 @param urlString 接口地址
 @param headerDic 请求头
 @param parameters 内容
 @param successBlock 请求成功
 @param serverErrorBlock 服务器失败
 @param failBlock 请求失败
 */
@implementation HttpRequest

+ (void)GETRequestUrlString:(NSString *)urlString
                  headerDic:(NSDictionary *)headerDic
                 parameters:(NSDictionary *)parameters
               successBlock:(void(^)(id result))successBlock
           serverErrorBlock:(void(^)(id result))serverErrorBlock
                  failBlock:(void(^)(void))failBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager] ;
    //直接使用服务器应该返回的数据，不做任何解析
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //忽略缓存
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    //超时设置
    manager.requestSerializer.timeoutInterval = 30;
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",@"application/javascript", nil]];
    
    //  设置请求头
    if (headerDic.count) {
        for (NSString *key in headerDic)
        {
            [manager.requestSerializer setValue:headerDic[key] forHTTPHeaderField:key];
        }
    }
    
    //  添加字段信息
    parameters = [self addAllParameterWithParameter:parameters IsAddUserData:YES];
    
    //  开始请求
    [manager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil] ;
        
        if ([dic[@"error"] integerValue]==0)
        {
            //  数据成功
            if (successBlock)
            {
                successBlock(dic) ;
            }
        }else
        {
            //            [MBProgressHUDInLoading MBProgressHUDInTitleWithTitle:dic[@"msg"]];
            if (serverErrorBlock)
            {
                serverErrorBlock(dic) ;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //        [MBProgressHUDInLoading MBProgressHUDInTitleWithTitle:HttpUrlError];
        
        if(failBlock)
        {
            failBlock();
        }
        
    }] ;
}

/**
 POST请求
 
 @param urlString 接口地址
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
                       failBlock:(void(^)(void))failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager] ;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    manager.requestSerializer.timeoutInterval = 30;
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",@"application/javascript", nil]];
    
    //  设置请求头
    for (NSString *keyString in headerDic.allKeys)
    {
        [manager.requestSerializer setValue:[headerDic valueForKey:keyString] forHTTPHeaderField:keyString] ;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [dic setObject:[GetDeviceData getIDFV] forKey:@"device"];    
    [dic setObject:[GetDeviceData getPhoneType] forKey:@"device_type"];
    [dic setObject:@"1" forKey:@"mac"];
    [dic setObject:[GetDeviceData getOS] forKey:@"system_version"];
    [dic setObject:[GetDeviceData getVersionSDK] forKey:@"sdk_version"];
    [dic setObject:[GetDeviceData getVersionApp] forKey:@"app_version"];
    NSString *serverId = [publicMath isBlankString:[MCOOSSDKCenter MCOShareSDK].serverId] ? [MCOOSSDKCenter MCOShareSDK].serverId : @"0";
    [dic setObject:serverId forKey:@"server_id"];
    
    [dic setObject:[GetDeviceData getTimeStp] forKey:@"time"];
    [dic setObject:[MCOOSSDKCenter MCOShareSDK].gameId forKey:@"game_id"];
    [dic setObject:[MCOOSSDKCenter MCOShareSDK].channel forKey:@"channel"];
    if (![publicMath isBlankString:[MCOOSSDKCenter MCOShareSDK].language]) {
        [dic setObject:@"ZH" forKey:@"lang_code"];
    }else{
        [dic setObject:[MCOOSSDKCenter MCOShareSDK].language forKey:@"lang_code"];
    }
    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *uuid = [user objectForKey:@"uuid"];
//    if ([publicMath isBlankString:uuid]) {
//        [dic setObject:uuid forKey:@"uuid"];
//    }
    
    [dic setObject:[publicMath getAppName] forKey:@"sdk_game_name"];
    
    [dic addEntriesFromDictionary:parameters];
    NSMutableArray *array = [self dictSortedByKeys:dic];
    NSMutableString *string = [[array componentsJoinedByString:@""] mutableCopy];
    if (pay) {
        [string appendString:[MCOOSSDKCenter MCOShareSDK].payKey];
    }else{
        [string appendString:[MCOOSSDKCenter MCOShareSDK].sdkKey];
    }
    
    
    NSString *md5Sign = [GetDeviceData md5String:string];
    [dic setObject:md5Sign forKey:@"sign"];
    
    
    //  添加字段信息  不添加用户数据
    //    parameters = [self addAllParameterWithParameter:parameters IsAddUserData:NO];
//    urlString = [MCOSDKBaseURL stringByAppendingString:urlString];
    if(![publicMath isBlankString:[MCOOSSDKCenter MCOShareSDK].mcoBaseUrl]){
        MCOLog(@"域名不可为空");
        failBlock();
    }
    urlString = [[MCOOSSDKCenter MCOShareSDK].mcoBaseUrl stringByAppendingString:urlString];
    
    MCOLog(@"urlString = %@\n parameters = %@",urlString,dic);
    
    
    //  开始请求
    [manager POST:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil] ;
        if (dic.count==0) {
            return ;
        }
        if ([dic[@"error"] integerValue]==0){
            //  数据成功
            if (successBlock) {
                successBlock(dic) ;
            }
            
        }else{
            if (serverErrorBlock){
                serverErrorBlock(dic) ;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MCOLog(@"错误的URL = = %@ error == %@  params=%@",urlString,error,dic);
        if(failBlock){
            failBlock();
        }
    }] ;
}



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
                                  failBlock:(void(^)(void))failBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    manager.requestSerializer.timeoutInterval = 30;
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",@"application/javascript", nil]];
    
    // 设置请求头
    for (NSString *keyString in headerDic.allKeys)
    {
        [manager.requestSerializer setValue:[headerDic valueForKey:keyString] forHTTPHeaderField:keyString] ;
    }
    
    //  添加字段信息
    parameters = [self addAllParameterWithParameter:parameters IsAddUserData:YES];
    
    //  添加加载框
    //    [MBProgressHUDInLoading MBProgressHUDInLoading];
    
    //  开始请求
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //  设置图片
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3) ;
        
        NSString *imageNameJPG = [NSString stringWithFormat:@"%@.jpg",imageName];
        
        [formData appendPartWithFileData:imageData name:imageName fileName:imageNameJPG mimeType:@"image.jpg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //  移除加载框
        //        [MBProgressHUDInLoading MBProgressHUDInStop];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil] ;
        
        if ([dic[@"error"] integerValue]==0)
        {
            //  数据成功
            if (successBlock) {
                successBlock(dic) ;
            }
        }else
        {
            //            [MBProgressHUDInLoading MBProgressHUDInTitleWithTitle:dic[@"msg"]];
            if (serverErrorBlock)
            {
                serverErrorBlock(dic) ;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //        [MBProgressHUDInLoading MBProgressHUDInTitleWithTitle:HttpUrlError];
        
        if(failBlock)
        {
            failBlock();
        }
        
    }] ;
}

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
                                       failBlock:(void(^)(void))failBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    manager.requestSerializer.timeoutInterval = 30;
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",@"application/javascript", nil]];
    
    // 设置请求头
    for (NSString *keyString in headerDic.allKeys)
    {
        [manager.requestSerializer setValue:[headerDic valueForKey:keyString] forHTTPHeaderField:keyString] ;
    }
    
    //  添加字段信息
    parameters = [self addAllParameterWithParameter:parameters IsAddUserData:YES];
    
    //  添加加载框
    //    [MBProgressHUDInLoading MBProgressHUDInLoading];
    
    //  开始请求
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //  设置图片
        for (NSInteger i=0; i<imagesArray.count ;i++)
        {
            NSData *imageData = UIImageJPEGRepresentation(imagesArray[i], 0.3) ;
            
            NSString *imageNameJPG = [NSString stringWithFormat:@"%@.jpg",imagesNameArray[i]];
            
            [formData appendPartWithFileData:imageData name:imagesNameArray[i] fileName:imageNameJPG mimeType:@"image.jpg"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //  移除加载框
        //        [MBProgressHUDInLoading MBProgressHUDInStop];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil] ;
        
        if ([dic[@"error"] integerValue]==0)
        {
            //  数据成功
            if (successBlock) {
                successBlock(dic) ;
            }
        }else
        {
            //            [MBProgressHUDInLoading MBProgressHUDInTitleWithTitle:dic[@"msg"]];
            if (serverErrorBlock)
            {
                serverErrorBlock(dic) ;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //        [MBProgressHUDInLoading MBProgressHUDInTitleWithTitle:HttpUrlError];
        
        if(failBlock)
        {
            failBlock();
        }
        
    }] ;
}


//  添加字段信息  IsAddUserData判断是否加入用户数据
+ (NSDictionary *)addAllParameterWithParameter:(NSDictionary *)parameters IsAddUserData:(BOOL)IsAdd
{
    //  添加公共参数
    //    parameters = [self addPublicWithParameter:parameters];
    //
    //    if (IsAdd) {
    //        //  添加用户参数 uid hashid
    //        parameters = [self addUserWithParameter:parameters];
    //    }
    //
    //    //  对所有参数的加密字段添加
    //    parameters = [self addEncryptionWithParameter:parameters];
    
    
    return parameters;
}


//  对所有参数的加密字段添加
+ (NSDictionary *)addEncryptionWithParameter:(NSDictionary *)parameter
{
    NSMutableDictionary *dic_m = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *allValue_M_Array = [[NSMutableArray alloc]init];
    
    
    for (NSString *key in parameter.allKeys)
    {
        [dic_m setValue:parameter[key] forKey:key];
        
        NSString *string = [NSString stringWithFormat:@"%@%@",key,parameter[key]];
        
        [allValue_M_Array addObject:string];
        
    }
    
    //  添加所有参数字符串加密
    if(allValue_M_Array.count>0)
    {
        
        //        NSString *string = [[self riseSortExchangeDataWith:allValue_M_Array] componentsJoinedByString:@""];
        //
        //        NSString *mdsting = [string stringByAppendingString:APIKey];
        //
        //        NSString *md5string = [SJEncryptionTool MD5StringWithString:mdsting];
        //
        //        [dic_m setObject:md5string forKey:@"hash"];
    }
    
    return dic_m;
}

//  添加公共参数
+ (NSDictionary *)addPublicWithParameter:(NSDictionary *)parameter
{
    
    NSMutableDictionary *dic_m = [[NSMutableDictionary alloc]initWithDictionary:parameter];
    
    
    //  添加
    //    [dic_m setValue:[NSNumber numberWithInteger:[SJDateConvertTool getThePresentTimeStamp]] forKey:@"time"];
    //    [dic_m setValue:@"306e1b5728ae097e30c411c10415976f" forKey:@"apiId"];
    //    [dic_m setValue:@"2" forKey:@"terminal"];
    
    
    return dic_m;
}


//  添加用户参数
+ (NSDictionary *)addUserWithParameter:(NSDictionary *)parameter
{
    
    NSMutableDictionary *dic_m = [[NSMutableDictionary alloc]initWithDictionary:parameter];
    
    
    //    UserSingle *userSingle = [UserSingle shareUserSingle];
    //    if(userSingle.memberId)
    //    {
    //        //  添加
    //        [dic_m setValue:userSingle.hashid forKey:@"hashid"];
    //        [dic_m setValue:userSingle.uid forKey:@"uid"];
    //
    //    }else{
    //        //  添加
    //        [dic_m setValue:@"" forKey:@"hashid"];
    //        [dic_m setValue:@"" forKey:@"uid"];
    //    }
    
    return dic_m;
}


/**
 *  升序,交换数据位置
 *
 *  @param array 修改之前的数据数组
 *
 *  @return 升序排好的数据数组
 */
+ (NSArray *)riseSortExchangeDataWith:(NSArray *)array
{
    NSArray *resultArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSString *val1 = obj1 ;
        NSString *val2 = obj2 ;
        
        return [val1 compare:val2];
        
    }];
    
    return resultArray ;
}

/**
 请求未读消息数
 */
+ (void)UnReadCountWithUrlString:(NSString *)urlString
                       headerDic:(NSDictionary *)headerDic
                      parameters:(NSDictionary *)parameters
                    successBlock:(void(^)(id result))successBlock
                serverErrorBlock:(void(^)(id result))serverErrorBlock
                       failBlock:(void(^)(void))failBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager] ;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    manager.requestSerializer.timeoutInterval = 30;
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html",@"application/javascript", nil]];
    
    //  设置请求头
    for (NSString *keyString in headerDic.allKeys)
    {
        [manager.requestSerializer setValue:[headerDic valueForKey:keyString] forHTTPHeaderField:keyString] ;
    }
    
    //  添加字段信息  不添加用户数据
    parameters = [self addAllParameterWithParameter:parameters IsAddUserData:NO];
    
    MCOLog(@"123 = = %@",parameters);
    
    //  开始请求
    [manager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil] ;
        
        if ([dic[@"error"] integerValue]==0)
        {
            //  数据成功
            if (successBlock) {
                successBlock(dic) ;
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }] ;
}

//排序
+(NSMutableArray*)dictSortedByKeys:(NSDictionary*)dict
{
    NSArray *sortedKeys=[[dict allKeys]sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *sortedValues=[NSMutableArray array];
    for (NSString *key in sortedKeys) {
        [sortedValues addObject:[dict objectForKey:key]];
    }
    return sortedValues;
}

@end
