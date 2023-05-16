//
//  MCOBindBtn.h
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/10.


#import <UIKit/UIKit.h>

@interface MCOBindBtn : UIButton{
    
    NSString *appName;
    
    NSString *appId;
    
    NSString *type;
    
    NSString *open;//0.未绑定 1.已绑定
    
}

@property(nonatomic,readwrite,retain)NSString *appName;

@property(nonatomic,readwrite,retain)NSString *appId;

@property(nonatomic,readwrite,retain)NSString *type;

@property(nonatomic,readwrite,retain)NSString *open;

@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goLabel;
@property (weak, nonatomic) IBOutlet UIImageView *appLogoImage;
@property (weak, nonatomic) IBOutlet UIImageView *goImage;

@end
