//
//  MCOTextField.h
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/13.
//

#import <UIKit/UIKit.h>

@interface MCOTextField : UITextField

@property(nonatomic,readwrite,retain)NSString *imageName;

@property(nonatomic, strong) UIColor *placeholderColor;
@property(nonatomic, strong) UIFont  *placeholderFont;

@end
