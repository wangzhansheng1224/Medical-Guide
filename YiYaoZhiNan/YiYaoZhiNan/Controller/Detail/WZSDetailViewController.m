//
//  WZSDetailViewController.m
//  药品手册
//
//  Created by wzs on 16/6/19.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSDetailViewController.h"
#import "ZJScrollPageView.h"
#import "WZSShowViewController.h"

@interface WZSDetailViewController ()
@property (nonatomic,strong)ZJScrollPageView *multipage;
@property (nonatomic,strong)NSMutableArray *itemArr;
@end

@implementation WZSDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createtitleView];
    self.tabBarController.tabBar.hidden=YES;
    [self changeNavigationItem];
    [self loadData];
    [self createMutiPageManger];
    // Do any additional setup after loading the view.
}

- (void)createtitleView{
    UIView *titleview =[[UIView alloc]initWithFrame:CGRectMake(40, 0, WIDTH-80, 30)];
    titleview.backgroundColor = [UIColor whiteColor];
    titleview.layer.cornerRadius = 5;
    titleview.layer.masksToBounds = YES;
    self.navigationItem.titleView = titleview;
    //添加手势,点击跳转到搜索界面
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGR)];
    [titleview addGestureRecognizer:tapGR];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WIDTH-100, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.text=@"输入药品名或者疾病名";
    label.textColor = [UIColor grayColor];
    [titleview addSubview:label];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 7, 16, 16)];
    imageV.image = [UIImage imageNamed:@"homepage_search"];
    [titleview addSubview:imageV];
    

}

- (void)tapGR{
    WZSSearchViewController *vc = [[WZSSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)changeNavigationItem{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"common_scan"] style:UIBarButtonItemStylePlain target:self action:@selector(scan)];
}

-(void)scan{
    WZSScanViewController *vc=[[WZSScanViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadData{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"WZSClassifyitemList" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    self.itemArr = [dic objectForKey:self.name];
    
    
}

- (void)createMutiPageManger{
    self.automaticallyAdjustsScrollViewInsets=NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc]init];
    style.showLine = YES;
    style.showExtraButton = NO;
//    style.extraBtnBackgroundImageName = @"Arrow";
    //创建子控制器数组
    NSMutableArray *childVC = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.itemArr.count; i++) {
        WZSShowViewController *vc = [[WZSShowViewController alloc]init];
//        NSLog(@"%@",self.itemArr[i]);
//        [vc sendName:self.itemArr[i]];
        vc.name = self.itemArr[i];
        vc.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        vc.title =self.itemArr[i];
        [childVC addObject:vc];
    }
    
    //创建多页管理器
    _multipage = [[ZJScrollPageView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) segmentStyle:style childVcs:childVC parentViewController:self];
    [self.view addSubview:_multipage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)itemArr{
    ArrayLazyLoad(_itemArr);
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
