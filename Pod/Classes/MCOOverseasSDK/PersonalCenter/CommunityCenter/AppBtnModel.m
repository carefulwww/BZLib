//
//  AppBtnModel.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/3/9.
//

#import "AppBtnModel.h"

@implementation AppBtnModel

-(id)initWithShowInfor:(NSDictionary *)infor{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:infor];
        
    }
    
    return self;
    
}

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    
    
    
}

-(id)valueForUndefinedKey:(NSString *)key{
    
    return nil;

}

@end
