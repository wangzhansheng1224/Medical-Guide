//
//  WZSZiXunViewController.m
//  药品手册
//
//  Created by wzs on 16/6/28.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSZiXunViewController.h"

@interface WZSZiXunViewController ()

@end

@implementation WZSZiXunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createNavigationController];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 70, 70)];
    imageV.center=CGPointMake(WIDTH/2, HEIGHT/2+40);
    imageV.image=[UIImage imageNamed:@"common_no_conent"];
    [self.view addSubview:imageV];
    
    // Do any additional setup after loading the view.
}

-(void)createNavigationController{
    self.navigationItem.title=@"我的咨询";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
