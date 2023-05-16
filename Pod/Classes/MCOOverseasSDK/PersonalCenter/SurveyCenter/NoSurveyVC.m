//
//  NoSurveyVC.m
//  MCOOverseasProject
//
//  Created by 王都都 on 2021/11/16.
//

#import <Foundation/Foundation.h>

@implementation NoSurveyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    
    self.navigationItem.leftBarButtonItem = self.navBackBtn;
    self.navigationItem.title = [publicMath getLocalString:@"surveyItem"];
    
    self.bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.bgView.backgroundColor = [UIColor colorWithHexString:MCO_Background_Color];
    
    UIView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bgView.frame.size.width-142)/2, 66, 142, 210)];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MCO_NO_Survey_Image]];
    [imageView addSubview:image];
    [self.bgView addSubview:imageView];
    
    UITextView *tipView = [[UITextView alloc] init];
//    [tipView setText:[publicMath getLocalString:@"surveyItem"]];
    [tipView setText:[publicMath getLocalString:@"historySurveyTips"]];
    [tipView setFont:[UIFont systemFontOfSize:12]];
    tipView.backgroundColor = [UIColor clearColor];
    [tipView sizeToFit];
    tipView.frame = CGRectMake((self.bgView.frame.size.width-tipView.frame.size.width)/2, (imageView.frame.size.height+22+imageView.frame.origin.y), tipView.frame.size.width, tipView.frame.size.height);
    [self.bgView addSubview:tipView];
    
    [self.view addSubview:self.bgView];
    
}

-(UIBarButtonItem *)navBackBtn{
    if (!_navBackBtn) {
        self.navBackBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:MCO_Back] style:UIBarButtonItemStylePlain target:self action:@selector(backPress)];
    }
    return _navBackBtn;
}

-(void)backPress{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
