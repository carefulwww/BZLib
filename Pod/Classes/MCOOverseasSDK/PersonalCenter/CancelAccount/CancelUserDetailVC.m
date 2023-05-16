//
//  CancelUserDetailVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2022/1/12.
//

#import "CancelUserDetailVC.h"

static NSString *userIden = @"userCell";

@implementation CancelUserDetailVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    self.bgView.frame = CGRectMake((ScreenWidth-304)/2, (ScreenHeight-241)/2, 304, 241);
    self.titleLabel.text = [publicMath getLocalString:@"cancelAccountItem"];
    self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-200)/2, 16, 200, 25);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.closeBtn addTarget:self action:@selector(closePress) forControlEvents:UIControlEventTouchUpInside];
    
    self.tipLabel.frame = CGRectMake(0, 0, 240, 50);
    //提示
//    NSString *text = @"为确保您的账号安全，请提供您实名认证时的真实信息以供账号注销核验，该信息仅用于本次验证使用：";
    NSString *text = [publicMath getLocalString:@"roleNameAndTime"];
    self.tipLabel.font = [UIFont systemFontOfSize:12];
//    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.tipLabel setTextColor:[UIColor colorWithHexString:MCO_CheckTip_Gray]];
//    [self.tipLabel sizeToFit];
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setAlignment:NSTextAlignmentLeft];
    [paragraphStyle1 setLineSpacing:1];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
    [self.tipLabel setAttributedText:attributedString1];
    self.tipLabel.numberOfLines = 0;
    [self.tipLabel sizeToFit];

    self.tipLabel.frame = CGRectMake(32, 56, self.tipLabel.frame.size.width, self.tipLabel.frame.size.height);
    
    //详细展示
    [self.bgView addSubview:self.detailTableView];
    
    //确认按钮
    self.checkBoxBtn.frame = CGRectMake(20-11, self.detailTableView.frame.size.height+self.detailTableView.frame.origin.y+10, 22, 22);
    self.checkBoxBtn.tag = 1;
    [self.checkBoxBtn addTarget:self action:@selector(checkPress) forControlEvents:UIControlEventTouchUpInside];
    
    //二次确认文字
    UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 209,25)];
    NSString *text2 = [publicMath getLocalString:@"checkUserInfo"];
    [checkLabel setTextColor:[UIColor colorWithHexString:MCO_CheckTip_Gray]];
    [checkLabel setFont:[UIFont systemFontOfSize:11]];
    NSMutableAttributedString * attributedString2 = [[NSMutableAttributedString alloc] initWithString:text2];
    NSMutableParagraphStyle * paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle2 setAlignment:NSTextAlignmentLeft];
    [paragraphStyle2 setLineSpacing:1];
    [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text2 length])];
//    [checkLabel setAttributedTitle:attributedString1 forState:UIControlStateNormal];
    [checkLabel setAttributedText:attributedString2];
    checkLabel.numberOfLines = 0;
    [checkLabel sizeToFit];
    checkLabel.frame = CGRectMake(self.checkBoxBtn.frame.size.width+self.checkBoxBtn.frame.origin.x+4, self.checkBoxBtn.frame.origin.y-1, 209, checkLabel.frame.size.height);
    [self.bgView addSubview:checkLabel];
//    [checkLabel addTarget:self action:@selector(checkPress) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *labelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkPress)];
    [checkLabel addGestureRecognizer:labelTap];
    checkLabel.userInteractionEnabled = YES;
    
    [self.mcoCancelBtn setTitle:[publicMath getLocalString:@"cancel"] forState:UIControlStateNormal];
    self.mcoCancelBtn.frame = CGRectMake(38,200,107.5, 30.5);
    [self.mcoCancelBtn addTarget:self action:@selector(cancelPress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.sureBtn setTitle:[publicMath getLocalString:@"sure"] forState:UIControlStateNormal];
    self.sureBtn.frame = CGRectMake((self.mcoCancelBtn.frame.size.width+self.mcoCancelBtn.frame.origin.x+12), self.mcoCancelBtn.frame.origin.y, 107.5, 30.5);
    [self.sureBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Btn_Gray]];
    self.sureBtn.enabled = NO;
    [self.sureBtn addTarget:self action:@selector(surePress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.closeBtn];
    [self.bgView addSubview:self.tipLabel];
    [self.bgView addSubview:self.checkBoxBtn];
    [self.bgView addSubview:self.mcoCancelBtn];
    [self.bgView addSubview:self.sureBtn];
    
    [self.view addSubview:self.bgView];
}


- (UITableView *)detailTableView{
    if(!_detailTableView){
        self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-267)/2, 83, 267, 80) style:UITableViewStylePlain];
        self.detailTableView.rowHeight = 20;
        self.detailTableView.delegate = self;
        self.detailTableView.dataSource = self;
        self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.detailTableView.showsVerticalScrollIndicator = YES;
        self.detailTableView.showsHorizontalScrollIndicator = NO;
    }
    return _detailTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userDetailArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userIden];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:userIden];
    }
    
    if (self.userDetailArr.count > 0) {
        NSString *roleName = [self.userDetailArr[indexPath.row] objectForKey:@"role_name"];
        NSString *roleStr = @"";
        if ([roleName length]>10) {
            roleStr = [NSString stringWithFormat:@"【%@...】",[roleName substringWithRange:NSMakeRange(0, 10)]];
        }else{
            roleStr = [NSString stringWithFormat:@"【%@】",roleName];
        }
        cell.textLabel.text = roleStr;
        [cell.textLabel setFont:[UIFont systemFontOfSize:11]];
        cell.detailTextLabel.text = [self.userDetailArr[indexPath.row] objectForKey:@"create_time"];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:11]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return cell;
}

/**
 输入框禁止编辑
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

-(void)checkPress{
    MCOLog(@"check box");
    if (self.checkBoxBtn.tag == 1) {
        //未被选中==>被选中
        self.checkBoxBtn.tag = 2;
        [self.checkBoxBtn setImage:[UIImage imageNamed:MCO_Check_Btn_Image] forState:UIControlStateNormal];
        [self.sureBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Main_Theme_Color]];
        self.sureBtn.enabled = YES;
    }else{
        //被选中==>未被选中
        self.checkBoxBtn.tag = 1;
        [self.checkBoxBtn setImage:[UIImage imageNamed:MCO_UnCheck_Btn_Image] forState:UIControlStateNormal];
        [self.sureBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Btn_Gray]];
        self.sureBtn.enabled = NO;
    }
}

-(void)closePress{
    MCOLog(@"关闭");
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[CancelTreatyVC class]]) {
            
            NSNotification *notification =[NSNotification notificationWithName:@"cancelBack" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self.navigationController popToViewController:temp animated:NO];
        }
    }
}

-(void)cancelPress{
    MCOLog(@"取消");
    [self.navigationController popViewControllerAnimated:NO];
}



-(void)surePress{
    MCOLog(@"确认按钮");
    CancelTipVC *cancelTipVC = [[CancelTipVC alloc] init];
    [self.navigationController pushViewController:cancelTipVC animated:NO];
}

@end
