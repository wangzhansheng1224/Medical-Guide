//
//  WZSSearchViewController.m
//  药品手册
//
//  Created by wzs on 16/6/22.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSSearchViewController.h"
#import "WZSSearchModel.h"
#import "WZSSearchTableViewCell.h"

#import "WZSSearchDetailViewController.h"

@interface WZSSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UITextField *tf;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)UITableView *tableV;
@end

@implementation WZSSearchViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createtitleView];
    [self loadData];
    [self createtableView];
    // Do any additional setup after loading the view.
}

- (void)createtableView{
    _tableV = [[UITableView alloc]initWithFrame:self.view.frame];
    _tableV.delegate=self;
    _tableV.dataSource=self;
    _tableV.tableFooterView = [[UIView alloc]init];
    _tableV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableV];
    [_tableV registerNib:[UINib nibWithNibName:@"WZSSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_tf resignFirstResponder];
}

- (void)createtitleView{
    _tf = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, WIDTH-80, 30)];
    self.navigationItem.titleView = _tf;
    _tf.tintColor=[UIColor blueColor];
    _tf.backgroundColor = [UIColor whiteColor];
    _tf.placeholder = @"输入药品名或者疾病名";
    _tf.layer.cornerRadius = 5;
    _tf.borderStyle=UITextBorderStyleRoundedRect;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [_tf addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    _tf.layer.masksToBounds = YES;
    _tf.delegate=self;
    _tf.returnKeyType = UIReturnKeySearch;
    _tf.font = [UIFont systemFontOfSize:15];
    _tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_tf becomeFirstResponder];
    
    //左侧搜索图标
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, 30, 14)];
    imageV.contentMode = UIViewContentModeScaleAspectFit;

    imageV.image = [UIImage imageNamed:@"homepage_search"];
    _tf.leftView = imageV;
    _tf.leftViewMode = UITextFieldViewModeAlways;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"common_scan"] style:UIBarButtonItemStylePlain target:self action:@selector(scan)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    WZSSearchDetailViewController *vc = [[WZSSearchDetailViewController alloc]init];
    vc.name = _tf.text;
    [self.navigationController pushViewController:vc animated:YES
     ];
    return YES;
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scan{
    WZSScanViewController *vc=[[WZSScanViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES
    ;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)textFieldDidChange {
    NSLog(@"%@",_tf.text);
    [self loadData];
}

- (void)loadData{
    NSString * url = [NSString stringWithFormat:SOUSUO,_tf.text];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [WZSRequestHttp requestData:GET Url:url parameter:nil andHttpBlock:^(NSData *data, NSError *error) {
        if (!error) {
            [self.dataArr removeAllObjects];

            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *array = dic[@"results"];
            for (NSDictionary *dic in array) {
                WZSSearchModel *model = [[WZSSearchModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:model];
            }
            [_tableV reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WZSSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    WZSSearchModel *model = self.dataArr[indexPath.row];
    cell.name.text = model.showname;
    cell.number.text = [NSString stringWithFormat:@"%ld",(long)model.recordcount];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WZSSearchDetailViewController *vc= [[WZSSearchDetailViewController alloc]init];
    WZSSearchModel *model = self.dataArr[indexPath.row];
    vc.name =model.showname;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)dataArr{
    ArrayLazyLoad(_dataArr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
