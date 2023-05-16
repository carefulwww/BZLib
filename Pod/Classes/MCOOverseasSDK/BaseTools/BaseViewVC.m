//
//  BaseViewVC.m
//  MCOOverseasProject
//

#import "BaseViewVC.h"

@implementation BaseViewVC

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(UIView *)bgView{
    if (!_bgView) {
        self.bgView = [[UIView alloc]init];
        self.bgView.backgroundColor = UIColor.whiteColor;
        self.bgView.layer.cornerRadius = 10;
        self.bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeBtn.frame = CGRectMake((self.bgView.frame.size.width-12-15.6), 12, 15.6, 15.6);
        [self.closeBtn setImage:[UIImage imageNamed:MCO_Close] forState:UIControlStateNormal];
//        [self.closeBtn addTarget:self action:@selector(closePress) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UIButton *)appleBtn{
    
    if (!_appleBtn) {
        self.appleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.appleBtn.frame = CGRectMake(0, 0, 32, 32);
        [self.appleBtn setImage:[UIImage imageNamed:MCO_APPLE_ICON] forState:UIControlStateNormal];
    }
    
    return _appleBtn;
}

-(UIButton *)googleBtn{
    
    if (!_googleBtn) {
        self.googleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.googleBtn.frame = CGRectMake(0, 0, 32, 32);
        [self.googleBtn setImage:[UIImage imageNamed:MCO_GOOGLE_ICON] forState:UIControlStateNormal];
    }
    
    return _googleBtn;
}

-(UIButton *)facebookBtn{
    
    if (!_facebookBtn) {
        self.facebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.facebookBtn.frame = CGRectMake(0, 0, 32, 32);
        [self.facebookBtn setImage:[UIImage imageNamed:MCO_FACEBOOK_ICON] forState:UIControlStateNormal];
    }
    
    return _facebookBtn;
}

-(UIButton *)publicBtn{
    
    if (!_publicBtn) {
        self.publicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.publicBtn.layer.cornerRadius = 8;
        self.publicBtn.layer.masksToBounds = YES;
        [self.publicBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Main_Theme_Color]];
        [self.publicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.publicBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return _publicBtn;
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

-(UILabel *)tipLabel{

    if (!_tipLabel) {
        self.tipLabel = [[UILabel alloc] init];
        self.tipLabel.font = [UIFont systemFontOfSize:14];
        self.tipLabel.textColor = [UIColor colorWithHexString:MCO_Grey_Color];
        self.tipLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _tipLabel;
    
}

-(UIButton *)mcoBackBtn{
    if (!_mcoBackBtn) {
        self.mcoBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mcoBackBtn.frame = CGRectMake(24.5, 12, 30, 30);
        [self.mcoBackBtn setImageEdgeInsets: UIEdgeInsetsMake((30-8.5)/4, (30-14)/4, (30-8.5)/4, (30-14)/4)];
        [self.mcoBackBtn setImage:[UIImage imageNamed:MCO_Black_Back] forState:UIControlStateNormal];
    }
    return _mcoBackBtn;
}


-(UIButton *)mcoCancelBtn{
    if (!_mcoCancelBtn) {
        self.mcoCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mcoCancelBtn.frame = CGRectMake(0, 0, 108, 31);
        self.mcoCancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [self.mcoCancelBtn setFont:[UIFont systemFontOfSize:13]];
        [self.mcoBackBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [self.mcoCancelBtn setTitleColor:[UIColor colorWithHexString:MCO_Btn_Text_Gray] forState:UIControlStateNormal];
        [self.mcoCancelBtn setBackgroundImage:[UIImage imageNamed:MCO_Cancel_Btn_Image] forState:UIControlStateNormal];
    }
    return _mcoCancelBtn;
}

-(UIButton *)checkBoxBtn{
    if (!_checkBoxBtn) {
        self.checkBoxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.checkBoxBtn.frame = CGRectMake(0, 0, 22, 22);
        [self.checkBoxBtn setImage:[UIImage imageNamed:MCO_UnCheck_Btn_Image] forState:UIControlStateNormal];
        [self.checkBoxBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 11, 11, 0)];
    }
    return _checkBoxBtn;
}

-(UIButton *)sureBtn{
    if(!_sureBtn){
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureBtn.frame= CGRectMake(0, 0, 108, 31);
        self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [self.sureBtn setFont:[UIFont systemFontOfSize:13]];
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.sureBtn setBackgroundImage:[UIImage imageNamed:MCO_Sure_Red_Btn_Image] forState:UIControlStateNormal];
        self.sureBtn.layer.cornerRadius = 4;
        self.sureBtn.layer.masksToBounds = YES;
        [self.sureBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Main_Theme_Color]];
    }
    return _sureBtn;
}

@end
