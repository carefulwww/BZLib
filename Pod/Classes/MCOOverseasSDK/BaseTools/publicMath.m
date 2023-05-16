//
//  publicMath.m
//  MCOStandAlone
//
//  Copyright © 2019 test. All rights reserved.
//
#import "publicMath.h"

@implementation publicMath

static BOOL mcoLogEnable = NO;

static char jptbase64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

//字符串是否为空
+(BOOL)isBlankString:(NSString *)string{
    if (string == nil) {
        return NO;
    }
    if (string == NULL) {
        return NO;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([string isEqual:[NSNull null]]) {
        return NO;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    return YES;
}

+(NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
+(NSString *) jptbase64StringFromData:(NSData *)data length:(long)length {
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", jptbase64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}

+(BOOL)verfiyPhoneNumber:(NSString *)phone{
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phone.length != 11) {
        return NO;
    }
    return YES;
//    else{
//        /**
//         * 移动号段正则表达式
//        */
//        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
//        /**
//         * 联通号段正则表达式
//         */
//        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
//        /**
//         * 电信号段正则表达式
//         */
//        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
//        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
//        BOOL isMatch1 = [pred1 evaluateWithObject:phone];
//        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
//        BOOL isMatch2 = [pred2 evaluateWithObject:phone];
//        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
//        BOOL isMatch3 = [pred3 evaluateWithObject:phone];
//
//        if (isMatch1 || isMatch2 || isMatch3) {
//            return YES;
//        }else{
//            return NO;
//        }
//    }
}

//邮箱地址的正则表达式
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//提示框
+(void)MCOHub:(NSString *)message messageView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    //背景框颜色
    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    hud.label.textColor = [UIColor whiteColor];
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:12];
    
    NSInteger width = 0;
    NSInteger height = 0;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        width = ScreenHeight;
        height = ScreenWidth;
    }else{
        width = ScreenWidth;
        height = ScreenHeight;
    }
    [hud hideAnimated:YES afterDelay:2];
}

+(NSString *)replaceStringWithAsterisk:(NSString *)originalStr startLocation:(NSInteger)startLocation length:(NSInteger)lenght{
    NSString *newStr = originalStr;
    for (int i= 0; i < lenght; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return newStr;
}

//判断是否为纯数字
+(BOOL)isPureNum:(NSString *)text{
    if (!text) {
        return NO;
    }
    NSScanner *scan = [NSScanner scannerWithString:text];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
{
    NSDate *dateFrom = [self getCustomDateWithHour:fromHour];
    NSDate *dateTo = [self getCustomDateWithHour:toHour];
    NSDate *currentDate = [NSDate date];
    
    if (fromHour > toHour) {
        //当前时间大于起始时间或者当前时间小于结束时间
        if ([currentDate compare:dateFrom]==NSOrderedDescending || [currentDate compare:dateTo]==NSOrderedAscending)
         {
            MCOLog(@"该时间在 %ld:00-%ld:00 之间！", (long)fromHour, (long)toHour);
            return YES;
            
        }
        else
        {
            MCOLog(@"不在该时间段 %ld:00-%ld:00 之间！", (long)fromHour, (long)toHour);
            return NO;
        }
    }else{
        //当前时间大于起始时间并且当前时间小于结束时间
        if ([currentDate compare:dateFrom]==NSOrderedDescending && [currentDate compare:dateTo]==NSOrderedAscending)
         {
            MCOLog(@"该时间在 %ld:00-%ld:00 之间！", (long)fromHour, (long)toHour);
            return YES;
        }
        else
        {
            MCOLog(@"不在该时间段 %ld:00-%ld:00 之间！", (long)fromHour, (long)toHour);
            return NO;
        }
    }
}
 
 
+(NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
    
}

+(NSString *)getLocalString:(NSString *)key{
    NSBundle *bundle = [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource: @"MCOResource" ofType: @"bundle"]];
//    NSString *enPath = [bundle pathForResource:@"en" ofType:@"lproj"];
//    NSString *enStr = [[NSBundle bundleWithPath:enPath] localizedStringForKey:key value:key table:@""];
    
    NSString *language = [NSLocale preferredLanguages][0];
    NSString *languagePath;
    
    if ([language hasPrefix:@"zh-Hans"]) {
        //简体中文
        languagePath = [bundle pathForResource:@"zh-Hans" ofType:@"lproj"];
    }else if([language hasPrefix:@"zh-Hant"]){
        //繁体中文
        languagePath = [bundle pathForResource:@"zh-Hant" ofType:@"lproj"];
    }else if([language hasPrefix:@"zh-HK"]){
        //繁体中文
        languagePath = [bundle pathForResource:@"zh-HK" ofType:@"lproj"];
    }else if([language hasPrefix:@"ja"]){
        //日语
        languagePath = [bundle pathForResource:@"ja" ofType:@"lproj"];
    }else if ([language hasPrefix:@"ko"]){
        //韩语
        languagePath = [bundle pathForResource:@"ko" ofType:@"lproj"];
    }else{
        languagePath = [bundle pathForResource:@"en" ofType:@"lproj"];
    }
    
    return [[NSBundle bundleWithPath:languagePath] localizedStringForKey:key value:key table:@""];

    //    return [bundle localizedStringForKey:key value:enStr table:@""];
}

+ (BOOL)isIPhoneNotchScreen{
    BOOL result = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return result;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            result = YES;
        }
    }
    return result;
}

/**
 获取app名称
 */
+(NSString *)getAppName{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    if ([publicMath isBlankString:[NSString stringWithFormat:@"%@",appName]]) {
        return appName;
    }else{
        return @"nil";
    }
}

/*
 *  判断字符串 中文字符 字母 数字 以及下划线
 */
+(BOOL)isLettersAndNumbersAndUnderScore:(NSString *)string
{
    BOOL isNum = NO;
    BOOL isChart = NO;
    NSInteger alength = [string length];
    for (int i = 0; i<alength; i++) {
        char commitChar = [string characterAtIndex:i];
        NSString *temp = [string substringWithRange:NSMakeRange(i,1)];
        const char *u8Temp = [temp UTF8String];
        if (3==strlen(u8Temp)){
            MCOLog(@"字符串中含有中文");
            return NO;
        }else if((commitChar>64)&&(commitChar<91)){
            MCOLog(@"字符串中含有大写英文字母");
            isChart = YES;
        }else if((commitChar>96)&&(commitChar<123)){
            MCOLog(@"字符串中含有小写英文字母");
            isChart = YES;
        }else if((commitChar>47)&&(commitChar<58)){
            MCOLog(@"字符串中含有数字");
            isNum = YES;
        }else{
            MCOLog(@"字符串中含有非法字符");
            return NO;
        }
    }
    
    if (isNum&&isChart) {
        return YES;
    }
    return NO;
}

// 将字典或者数组转化为JSON串
+ (NSString *)objectToJson:(id)obj
{
    if (obj == nil) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
 
    if ([jsonData length] && error == nil) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

//关闭游戏
+(void)closeGame{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.5f animations:^{
            window.alpha = 0;
            window.frame = CGRectMake(0, window.bounds.size.height / 2, window.bounds.size.width, 0.5);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

+(void)setLogEnable:(BOOL)enable{
    mcoLogEnable = enable;
}

+(BOOL)getLogEnable{
    return mcoLogEnable;
}

+(void)customLogWithString:(NSString *)formatString{
    if([self getLogEnable]){
        // 开启了Log
        NSLog(@"\n\n-----------------MCOLog-----------------\n\n Log: %@ ---------------------------------------\n",formatString);
    }
}

@end
