//
//  SwitchUserModel.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/20.
//

#import "SwitchUserModel.h"

@implementation SwitchUserModel

-(id)initWithShowInfor:(NSDictionary *)infor{
    if (self = [super init]) {
       [self setValuesForKeysWithDictionary:infor];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
}


@end
