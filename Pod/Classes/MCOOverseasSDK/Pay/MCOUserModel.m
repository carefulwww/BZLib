//
//  MCOUserModel.m
//  MCOStandAlone
//
//  Created by 王都都 on 2019/8/23.
//  Copyright © 2019 test. All rights reserved.
//

#import "MCOUserModel.h"

@implementation MCOUserModel

-(id)initWithShowInfor:(NSDictionary *)Infor{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:Infor];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    
}

-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
}

@end
