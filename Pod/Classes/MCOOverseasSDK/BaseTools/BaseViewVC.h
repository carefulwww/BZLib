//
//  BaseViewVC.h
//  MCOOverseasProject
//

#import <UIKit/UIKit.h>

@interface BaseViewVC : UIViewController

//总弹窗
@property(nonatomic,strong)UIView *bgView;

//关闭按钮
@property(nonatomic,strong)UIButton *closeBtn;

//apple
@property(nonatomic,strong)UIButton *appleBtn;

//google
@property(nonatomic,strong)UIButton *googleBtn;

//facebook
@property(nonatomic,strong)UIButton *facebookBtn;

//title
@property(nonatomic,strong)UILabel *titleLabel;

//tip
@property(nonatomic,strong)UILabel *tipLabel;

//
@property(nonatomic,strong)UIButton *publicBtn;

//返回按钮
@property(nonatomic,strong)UIButton *mcoBackBtn;

//取消按钮
@property(nonatomic,strong)UIButton *mcoCancelBtn;

//checkBox按钮
@property(nonatomic,strong)UIButton *checkBoxBtn;

//确认按钮
@property(nonatomic,strong)UIButton *sureBtn;

@end
