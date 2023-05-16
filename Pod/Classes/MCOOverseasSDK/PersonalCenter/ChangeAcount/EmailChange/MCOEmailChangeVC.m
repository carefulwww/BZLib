//
//  MCOEmailChangeVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/12/13.
//
#import "MCOEmailChangeVC.h"

static NSString *switchIden = @"Cell";

@implementation MCOEmailChangeVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    [self getEmailArr];
    [self initView];
}

-(void)getEmailArr{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([publicMath isBlankString:[NSString stringWithFormat:@"%@",[user objectForKey:@"emailAcount"]]]) {
        self.emailStr = [user objectForKey:@"emailAccount"];
    }
    NSMutableArray *saveArr = [NSMutableArray arrayWithArray:[user objectForKey:@"saveEmailArr"]];
    MCOLog(@"邮箱数组内容 %@",saveArr);
    
    if (saveArr.count > 0) {
        for (NSDictionary *dic in saveArr) {
            SwitchUserModel *model = [[SwitchUserModel alloc] initWithShowInfor:dic];
            [self.dataArr addObject:model];
        }
        [self.switchTableView reloadData];
    }

}

-(void)initView{
    self.bgView.frame = CGRectMake((ScreenWidth - 304)/2, (ScreenHeight - 241)/2, 304, 241);
    
    self.titleLabel.text = [publicMath getLocalString:@"emailChange"];
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-self.titleLabel.frame.size.width)/2, 17, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    
//    [self.closeBtn addTarget:self action:@selector(closePress) forControlEvents:UIControlEventTouchUpInside];
    [self.mcoBackBtn addTarget:self action:@selector(backPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.emailTF = [[MCOTextField alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-255)/2, 61, 255, 35)];
    self.emailTF.imageName = MCO_Email_Small_Image;
    self.emailTF.attributedPlaceholder = [[NSMutableAttributedString alloc]
                                     initWithString:[publicMath getLocalString:@"enterCorrectAccount"]
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    self.emailTF.keyboardType = UIKeyboardTypeDefault;
    [self.emailTF addTarget:self action:@selector(inputEmailDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIView *emailRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 35)];
    emailRightView.center = self.switchBtn.center;
    [emailRightView addSubview:self.switchBtn];
    self.emailTF.rightView = emailRightView;
    self.emailTF.rightViewMode = UITextFieldViewModeAlways;
    if ([publicMath isBlankString:self.emailStr]) {
        self.emailTF.text = self.emailStr;
    }
    
    self.passwordTF = [[MCOTextField alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-255)/2, (self.emailTF.frame.size.height+self.emailTF.frame.origin.y+12), 255, 35)];
    self.passwordTF.imageName = MCO_Password_Small_Image;
    self.passwordTF.secureTextEntry = YES;
    self.passwordTF.attributedPlaceholder = [[NSMutableAttributedString alloc]
                                        initWithString:[publicMath getLocalString:@"enterCorrectPassword"]
attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    self.passwordTF.keyboardType = UIKeyboardTypeDefault;
    [self.passwordTF addTarget:self action:@selector(inputPasswordDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 35)];
    UIButton *eyeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 18, 15)];
    [eyeBtn setImage:[UIImage imageNamed:MCO_Open_Eyes_Small_Image] forState:UIControlStateNormal];
    [rightView addSubview:eyeBtn];
    [eyeBtn addTarget:self action:@selector(eyePress:) forControlEvents:UIControlEventTouchUpInside];
    self.passwordTF.rightView = rightView;
    self.passwordTF.rightViewMode = UITextFieldViewModeAlways;
    
    self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-255)/2, (self.passwordTF.frame.size.height+self.passwordTF.frame.origin.y+13), 255,31);
    [self.publicBtn setBackgroundColor:[UIColor colorWithHexString:MCO_Btn_Gray]];
    [self.publicBtn setTitle:[publicMath getLocalString:@"sureChange"] forState:UIControlStateNormal];
    self.publicBtn.enabled = NO;
    [self.publicBtn addTarget:self action:@selector(sureBindPress) forControlEvents:UIControlEventTouchUpInside];
    
    //邮箱注册按钮
    UIButton *emailRegBtn = [[UIButton alloc] init];
    [emailRegBtn setTitle:[publicMath getLocalString:@"emailReg"] forState:UIControlStateNormal];
    [emailRegBtn setTitleColor:[UIColor colorWithHexString:MCO_Btn_Gray] forState:UIControlStateNormal];
    [emailRegBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [emailRegBtn addTarget:self action:@selector(emaiRegPress) forControlEvents:UIControlEventTouchUpInside];
    [emailRegBtn sizeToFit];
    emailRegBtn.frame = CGRectMake(26.5, (self.publicBtn.frame.size.height+self.publicBtn.frame.origin.y+7), emailRegBtn.frame.size.width, emailRegBtn.frame.size.height);
    
    //邮箱注册按钮
    UIButton *findPasswordBtn = [[UIButton alloc] init];
    [findPasswordBtn setTitle:[publicMath getLocalString:@"findPassword"] forState:UIControlStateNormal];
    [findPasswordBtn setTitleColor:[UIColor colorWithHexString:MCO_Btn_Gray] forState:UIControlStateNormal];
    [findPasswordBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [findPasswordBtn addTarget:self action:@selector(findPasswordPress) forControlEvents:UIControlEventTouchUpInside];
    [findPasswordBtn sizeToFit];
    findPasswordBtn.frame = CGRectMake((self.bgView.frame.size.width-findPasswordBtn.frame.size.width-28), (self.publicBtn.frame.size.height+self.publicBtn.frame.origin.y+7), findPasswordBtn.frame.size.width, findPasswordBtn.frame.size.height);
    
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.mcoBackBtn];
    [self.bgView addSubview:self.emailTF];
    [self.bgView addSubview:self.passwordTF];
    [self.bgView addSubview:self.publicBtn];
    [self.bgView addSubview:emailRegBtn];
    [self.bgView addSubview:findPasswordBtn];
    
    [self.view addSubview:self.bgView];
    
    //下拉框
    [self.bgView addSubview:self.switchTableView];
    self.switchTableView.hidden = YES;
    
    self.view.userInteractionEnabled = YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.emailTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
}

- (UIButton *)switchBtn{
    if (!_switchBtn) {
        self.switchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 18, 15)];
//        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 15)];
        self.switchBtn.imageView.frame = CGRectMake(0, 0, 18, 15);
        [self.switchBtn setImage:[UIImage imageNamed:MCO_Down] forState:UIControlStateNormal];
        self.switchBtn.tag = 1100;
        [self.switchBtn addTarget:self action:@selector(switchPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

-(void)switchPress:(UIButton *)btn{
    MCOLog(@"点击输入框按钮");
    if(btn.tag == 1100){
        [btn setImage:[UIImage imageNamed:MCO_Up] forState:UIControlStateNormal];
        btn.tag = 1200;
        if (self.dataArr.count >= 1) {
            if(self.dataArr.count < 3){
                self.switchTableView.frame = CGRectMake(self.emailTF.frame.origin.x, self.emailTF.frame.origin.y+self.emailTF.frame.size.height, self.emailTF.frame.size.width, 35*self.dataArr.count);
            }else{
                self.switchTableView.frame = CGRectMake(self.emailTF.frame.origin.x, self.emailTF.frame.origin.y+self.emailTF.frame.size.height, self.emailTF.frame.size.width, 35*3);
            }
            self.switchTableView.hidden = NO;
        }else{
            self.switchTableView.hidden = YES;
        }
    }else{
        btn.tag = 1100;
        [btn setImage:[UIImage imageNamed:MCO_Down] forState:UIControlStateNormal];
        self.switchTableView.hidden = YES;
    }
}

- (UITableView *)switchTableView{
    if (!_switchTableView) {
        self.switchTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.emailTF.frame.origin.x, (self.emailTF.frame.origin.y+self.emailTF.frame.size.height), 255, 35*3) style:UITableViewStylePlain];
        self.switchTableView.rowHeight = 35;
        self.switchTableView.delegate = self;
        self.switchTableView.dataSource = self;
        self.switchTableView.showsVerticalScrollIndicator = NO;
        self.switchTableView.showsHorizontalScrollIndicator = NO;
    }
    return _switchTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SwitchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:switchIden];
    if(!cell){
        cell = [[SwitchUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:switchIden];
    }
    if (self.dataArr.count > 0) {
        SwitchUserModel *userModel = self.dataArr[indexPath.row];
        cell.userNameLabel.text = userModel.emailStr;
        [cell.userNameLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.userNameLabel setTextColor:[UIColor colorWithHexString:@"#3E3E3E"]];
        cell.emailStr = userModel.emailStr;
        if ([publicMath isBlankString:self.emailStr]&&[userModel.emailStr isEqualToString:self.emailStr]) {
            //当前账号 打勾按钮
            [cell.deleteBtn setImage:[UIImage imageNamed:MCO_Hook] forState:UIControlStateNormal];
            [cell.deleteBtn addTarget:self action:@selector(choosePress:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            //删除按钮
            [cell.deleteBtn setImage:[UIImage imageNamed:MCO_Cell_Close] forState:UIControlStateNormal];
            [cell.deleteBtn addTarget:self action:@selector(deletePress:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}

-(void)choosePress:(UIButton *)btn{
    MCOLog(@"选中");
    self.switchBtn.tag = 1100;
    [self.switchBtn setImage:[UIImage imageNamed:MCO_Down] forState:UIControlStateNormal];
    self.switchTableView.hidden = YES;
    SwitchUserCell *cell = (SwitchUserCell *)[btn superview];
    NSIndexPath *indexPath = [self.switchTableView indexPathForCell:cell];
    SwitchUserModel *userModel = self.dataArr[indexPath.row];
    self.emailTF.text = userModel.emailStr;
}

/**
 删除信息
 */
-(void)deletePress:(UIButton *)btn{
    MCOLog(@"删除信息");
    if (self.dataArr.count > 1) {
        SwitchUserCell *cell = (SwitchUserCell *)[btn superview];
        NSIndexPath *indexPath = [self.switchTableView indexPathForCell:cell];
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSMutableArray *saveArr = [NSMutableArray arrayWithArray:[user objectForKey:@"saveEmailArr"]];
        [saveArr removeObjectAtIndex:indexPath.row];
        [self.dataArr removeObjectAtIndex:indexPath.row];
        NSArray *arr = saveArr;
        [user setObject:arr forKey:@"saveEmailArr"];
        [user synchronize];
        [self.switchTableView reloadData];
        
        if (self.dataArr.count >= 1) {
            if (self.dataArr.count < 3) {
                self.switchTableView.frame = CGRectMake(self.emailTF.frame.origin.x, self.emailTF.frame.origin.y, 255, 35*self.dataArr.count);
            }else{
                self.switchTableView.frame = CGRectMake(self.emailTF.frame.origin.x, self.emailTF.frame.origin.y, 255, 35*3);
            }
            self.switchTableView.hidden = NO;
        }else{
            self.switchTableView.hidden = YES;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.switchBtn.tag = 1100;
    [self.switchBtn setImage:[UIImage imageNamed:MCO_Down] forState:UIControlStateNormal];
    self.switchTableView.hidden = YES;
    SwitchUserModel *userModel = self.dataArr[indexPath.row];
    self.emailTF.text = userModel.emailStr;
}

//判断是否输入email
-(void)inputEmailDidChange:(id)sender{
    UITextField *field = (UITextField *)sender;
    if ([publicMath isValidateEmail:[field text]] && self.passwordTF.text.length > 5) {
        //不为空
        self.publicBtn.enabled = YES;
        self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Main_Theme_Color];
    }else{
        self.publicBtn.enabled = NO;
        self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Btn_Gray];
    }
}

-(void)inputPasswordDidChange:(id)sender{
    UITextField *field = (UITextField *)sender;
    if ([field text].length > 5 && [publicMath isValidateEmail:self.emailTF.text]) {
        //不为空
        self.publicBtn.enabled = YES;
        self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Main_Theme_Color];
    }else{
        self.publicBtn.enabled = NO;
        self.publicBtn.backgroundColor = [UIColor colorWithHexString:MCO_Btn_Gray];
    }
}


-(void)sureBindPress{
    MCOLog(@"确认邮箱登录");
    if (![publicMath isValidateEmail:[self.emailTF text]]) {
        [publicMath MCOHub:[publicMath getLocalString:@"inputCorrectEmail"] messageView:self.view];
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSDictionary *dic = @{
        @"type":@"6",//邮箱登录
        @"open_id":self.emailTF.text,
        @"password":[GetDeviceData md5String:self.passwordTF.text],
    };
    
    [MCOLoginManager reportThirdLogin:dic isChange:YES hud:[MBProgressHUD HUDForView:self.view]];

}

-(void)emaiRegPress{
    MCOLog(@"邮箱注册");
    MCOEmailGetCodeVC *getCode = [[MCOEmailGetCodeVC alloc] init];
    getCode.type = 2;
    getCode.titleStr = [publicMath getLocalString:@"emailChange"];
    getCode.btnStr = [publicMath getLocalString:@"sureChange"];
    [self.navigationController pushViewController:getCode animated:NO];
}

-(void)findPasswordPress{
    MCOLog(@"找回密码");
    //跳到输入验证码界面
    MCOEmailGetCodeVC *getCodeVC = [[MCOEmailGetCodeVC alloc] init];
    getCodeVC.titleStr = [publicMath getLocalString:@"findPassword"];
    getCodeVC.btnStr = [publicMath getLocalString:@"sureModify"];
    getCodeVC.type = 5;//切换用户忘记密码
    [self.navigationController pushViewController:getCodeVC animated:NO];
}

-(void)backPress{
    MCOLog(@"返回");
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)eyePress:(UIButton *)eyeBtn{
    if(self.passwordTF.isSecureTextEntry){
        MCOLog(@"密码变为可见");
        self.passwordTF.secureTextEntry = NO;
        [eyeBtn setImage:[UIImage imageNamed:MCO_Close_Eyes_Small_Image] forState:UIControlStateNormal];
    }else{
        MCOLog(@"密码变为不可见");
        self.passwordTF.secureTextEntry = YES;
        [eyeBtn setImage:[UIImage imageNamed:MCO_Open_Eyes_Small_Image] forState:UIControlStateNormal];
    }
}
@end
