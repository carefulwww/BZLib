//
//  ThirdLoginBtn.h
//  MCOOverseasProject
//

#import <UIKit/UIKit.h>

@interface ThirdLoginBtn : UIButton{
    
    NSString *appName;
    
    NSString *appId;
    
    NSString *type;
    
}

@property(nonatomic,readwrite,retain)NSString *appName;

@property(nonatomic,readwrite,retain)NSString *appId;

@property(nonatomic,readwrite,retain)NSString *type;


@end

