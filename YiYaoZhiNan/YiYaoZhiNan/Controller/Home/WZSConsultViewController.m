//
//  WZSConsultViewController.m
//  药品手册
//
//  Created by wzs on 16/6/28.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSConsultViewController.h"

@interface WZSConsultViewController ()
{
    UIButton *menbtn;
    UIButton *wmenbtn;
}
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UITextField *tf;

@end

@implementation WZSConsultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationController];
    [self createUI];
}

-(void)createNavigationController{
    self.navigationItem.title=@"我要咨询";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI{
    menbtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 60, 70)];
    menbtn.tag=100;
    [menbtn setImage:[UIImage imageNamed:@"complete_info_boy_normal"] forState:UIControlStateNormal];
    [menbtn setImage:[UIImage imageNamed:@"complete_info_boy_selected"] forState:UIControlStateSelected];
    menbtn.layer.borderWidth=1;
    menbtn.layer.borderColor=[UIColor colorWithRed:195/255.0 green:195/255.0 blue:201/255.0 alpha:1].CGColor;
    menbtn.layer.cornerRadius=10;
    menbtn.layer.masksToBounds=YES;
    menbtn.center=CGPointMake(WIDTH/2-50, 140);
    [menbtn addTarget:self action:@selector(sexClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menbtn];
    
    wmenbtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 100, 60, 70)];
    wmenbtn.tag=101;
    [wmenbtn setImage:[UIImage imageNamed:@"complete_info_girl_normal"] forState:UIControlStateNormal];
    [wmenbtn setImage:[UIImage imageNamed:@"complete_info_girl_selected"] forState:UIControlStateSelected];
    wmenbtn.layer.borderWidth=1;
    wmenbtn.layer.borderColor=[UIColor colorWithRed:195/255.0 green:195/255.0 blue:201/255.0 alpha:1].CGColor;
    wmenbtn.layer.cornerRadius=10;
    wmenbtn.layer.masksToBounds=YES;
    wmenbtn.center=CGPointMake(WIDTH/2+50, 140);
    [wmenbtn addTarget:self action:@selector(sexClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wmenbtn];
    
    self.view.backgroundColor=[UIColor whiteColor];
    _tf=[[UITextField alloc]initWithFrame:CGRectMake(20, 200, WIDTH-40, 40)];
    _tf.placeholder=@"请输入年龄:";
    _tf.borderStyle=UITextBorderStyleRoundedRect;
    _tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_tf];
    
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(20, 290, WIDTH-40, 100)];
    _textView.font=[UIFont systemFontOfSize:15];
    _textView.textColor=[UIColor grayColor];
        _textView.layer.cornerRadius=5;
    _textView.layer.borderWidth=1;
    _textView.layer.borderColor=[UIColor colorWithRed:195/255.0 green:195/255.0 blue:201/255.0 alpha:1].CGColor;
    [self.view addSubview:_textView];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(20, 260, 300, 20)];
    lb.text = @"请输入咨询信息:";
    lb.enabled = NO;
    lb.textColor= [UIColor colorWithRed:195/255.0 green:195/255.0 blue:201/255.0 alpha:1];
    [self.view addSubview:lb];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(20, 450, WIDTH-40, 40)];
    btn.layer.cornerRadius=5;
    btn.layer.masksToBounds=YES;
    btn.layer.borderWidth=0.5;
    btn.layer.borderColor=[UIColor colorWithRed:47/255.0 green:115/255.0 blue:250/255.0 alpha:1].CGColor;
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:47/255.0 green:115/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_tf resignFirstResponder];
    [_textView resignFirstResponder];
}

- (void)sexClick:(UIButton *)btn{
    if (btn.tag==100) {
        menbtn.selected=YES;
        wmenbtn.selected=NO;
    }else{
        menbtn.selected=NO;
        wmenbtn.selected=YES;
    }
    
}

- (void)btnClick{
    if (menbtn.selected==NO&&wmenbtn.selected==NO) {
        [WZSHDManager startLoadingString:@"请输入性别" MBProgressHUDMode:MBProgressHUDModeText minShowTime:0.5];
        [WZSHDManager stopLoading];
        return;
    }
    if ([_tf.text isEqualToString:@""]) {
        [WZSHDManager startLoadingString:@"请输入年龄" MBProgressHUDMode:MBProgressHUDModeText minShowTime:0.5];
        [WZSHDManager stopLoading];
        return;
    }
    if (_textView.text.length<10) {
        [WZSHDManager startLoadingString:@"请输入至少10个字" MBProgressHUDMode:MBProgressHUDModeText minShowTime:0.5];
        [WZSHDManager stopLoading];
        return;
    }
    [WZSHDManager startLoadingString:@"发送成功" MBProgressHUDMode:MBProgressHUDModeText minShowTime:0.5];
    [WZSHDManager stopLoading];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
