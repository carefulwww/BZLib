//
//  AppBtn.h
//  MCOOverseasProject
//
//

#import <UIKit/UIKit.h>

@interface AppBtn : UIButton{
    
    NSString *appName;
    
    NSString *url;
    
}

@property(nonatomic,readwrite,retain)NSString *appName;

@property(nonatomic,readwrite,retain)NSString *url;


@end
