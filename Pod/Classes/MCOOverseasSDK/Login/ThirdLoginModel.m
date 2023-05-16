//
//  ThirdLoginModel.m
//  MCOOverseasProject
//

#import "ThirdLoginModel.h"

@implementation ThirdLoginModel

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
