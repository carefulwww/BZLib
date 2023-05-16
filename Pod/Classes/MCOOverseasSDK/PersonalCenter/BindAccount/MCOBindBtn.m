//
//  MCOBindBtn.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/10.
//

#import "MCOBindBtn.h"

@implementation MCOBindBtn

@synthesize appName;
@synthesize appId;
@synthesize type;

-(void)layoutSubviews{

    [super layoutSubviews];

    [self setBackgroundImage:[UIImage imageNamed:MCO_Bind_Btn_Background] forState:UIControlStateNormal];

    /**
     appLoginName
     */
    [self.appNameLabel setFont:[UIFont systemFontOfSize:12]];
    [self.appNameLabel setTextColor:[UIColor colorNamed:MCO_Text_Gray]];
    [self.appNameLabel setBackgroundColor:[UIColor clearColor]];

    /**
     查看账户、去绑定、绑定
     */
    [self.goLabel setFont:[UIFont systemFontOfSize:12]];
    [self.goLabel setTextColor:[UIColor colorNamed:MCO_Text_Gray]];
    [self.goLabel setBackgroundColor:[UIColor clearColor]];

    /**
    按钮
     */
    [self.goImage setImage:[UIImage imageNamed:MCO_GO_Black]];
    self.goImage.frame = CGRectMake((self.frame.size.width-12-8), (self.frame.size.height-12)/2, 8, 12);
}

@end
