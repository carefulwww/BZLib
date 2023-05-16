//
//  MCOSuspendVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/11/17.
//

#import "MCOSuspendVC.h"

@implementation MCOSuspendVC

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    [self.titleLabel setText:[publicMath getLocalString:@"suspendTitle"]];
    self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-self.titleLabel.frame.size.width)/2, 24, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    
    if (ScreenWidth > ScreenHeight) {
        //水平布局
        self.bgView.frame = CGRectMake((ScreenWidth-346)/2, (ScreenHeight-246)/2, 346, 246);
        self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-200)/2, 24, 200, 25);
        self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-280)/2, 63, 280, 20);
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        
    }else{
        //竖直布局
        self.bgView.frame = CGRectMake((self.view.frame.size.width-346)/2, (self.view.frame.size.height-246)/2, 346, 246);
        self.tipLabel.frame = CGRectMake((self.bgView.frame.size.width-250)/2, 55, 250, 40);
        self.titleLabel.frame = CGRectMake((self.bgView.frame.size.width-200)/2, 24, 200, 25);
        
    }
    
    UITextView *reasonTextView = [[UITextView alloc] init];
    reasonTextView.textColor = [UIColor blackColor];
    [reasonTextView setFont:[UIFont systemFontOfSize:12]];
    reasonTextView.text = [NSString stringWithFormat:@"%@%@",[publicMath getLocalString:@"suspendReason"],self.reason];
    [reasonTextView sizeToFit];
    reasonTextView.frame = CGRectMake(24, self.titleLabel.frame.size.height+self.titleLabel.frame.origin.y+5, reasonTextView.frame.size.width, 30);
    [self.bgView addSubview:reasonTextView];
    
    UITextView *accountTextView = [[UITextView alloc] init];
    accountTextView.textColor = [UIColor blackColor];
    [accountTextView setFont:[UIFont systemFontOfSize:12]];
    accountTextView.text = [NSString stringWithFormat:@"%@%@",[publicMath getLocalString:@"suspendAccount"],self.userId];
    [accountTextView sizeToFit];
    accountTextView.frame = CGRectMake(24,reasonTextView.frame.origin.y+reasonTextView.frame.size.height, accountTextView.frame.size.width, 30);
    [self.bgView addSubview:accountTextView];
    
    
    UITextView *timeTextView = [[UITextView alloc] init];
    timeTextView.textColor = [UIColor blackColor];
    [timeTextView setFont:[UIFont systemFontOfSize:12]];
    timeTextView.text = [NSString stringWithFormat:@"%@%@",[publicMath getLocalString:@"suspendTime"],self.suspendTime];
    [timeTextView sizeToFit];
    timeTextView.frame = CGRectMake(24,accountTextView.frame.origin.y+accountTextView.frame.size.height, timeTextView.frame.size.width, 30);
    [self.bgView addSubview:timeTextView];
    
    
    UITextView *noteTextView = [[UITextView alloc] init];
    noteTextView.textColor = [UIColor blackColor];
    [noteTextView setFont:[UIFont systemFontOfSize:12]];
    noteTextView.text = [NSString stringWithFormat:@"%@%@",[publicMath getLocalString:@"suspendNote"],self.note];
    [noteTextView sizeToFit];
    noteTextView.frame = CGRectMake(24,timeTextView.frame.origin.y+timeTextView.frame.size.height, noteTextView.frame.size.width, 30);
    [self.bgView addSubview:noteTextView];
    
    
    self.publicBtn.frame = CGRectMake((self.bgView.frame.size.width-118)/2, 179, 118, 30);
    [self.publicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.publicBtn setTitle:[publicMath getLocalString:@"sure"] forState:UIControlStateNormal];
    [self.publicBtn addTarget:self action:@selector(surePress) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.publicBtn];
    
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.tipLabel];
    
    [self.view addSubview:self.bgView];
}

-(void)surePress{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.5f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.height / 2, window.bounds.size.width, 0.5);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

@end
