//
//  SwitchUserCell.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/20.
//

#import "SwitchUserCell.h"

@implementation SwitchUserCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.backgroundColor = [UIColor colorWithHexString:MCInputColor];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
        self.layer.borderColor = [UIColor colorWithHexString:MCO_Gray_Bounds].CGColor;
        [self.contentView addSubview:self.deleteBtn];
        [self.contentView addSubview:self.userNameLabel];
    }
    return self;
}

-(UIButton *)deleteBtn{
    if (!_deleteBtn) {
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.frame = CGRectMake(255-18-12, 0, 35, 35);
//        [self.deleteBtn setImage:[UIImage imageNamed:] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

//userLabel
-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
        self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(12,0, 180, 36)];
        self.userNameLabel.textColor = [UIColor colorWithHexString:@"#3E3E3E"];
        self.userNameLabel.numberOfLines = 0;
    }
    return _userNameLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//-(void)setFrame:(CGRect)frame{
//    CGRect cellFrame = frame;
//    cellFrame.size.height = cellFrame.size.height - 2;
//    cellFrame.origin.y = cellFrame.origin.y + 2;
//    frame = cellFrame;
//    [super setFrame:frame];
//}

@end
