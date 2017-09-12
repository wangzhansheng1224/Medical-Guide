//
//  WZSDuiZhengViewController.m
//  药品手册
//
//  Created by wzs on 16/6/23.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSDuiZhengViewController.h"

@interface WZSDuiZhengViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableDictionary *dataDic;
@property (nonatomic,strong)NSArray *array;

@end

@implementation WZSDuiZhengViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createtitleView];
    [self createtableView];
    // Do any additional setup after loading the view.
}

- (void)loadData{
    NSString *path=[[NSBundle mainBundle]pathForResource:@"WZSDrugSearch" ofType:@"plist"];
    _dataDic=[[NSMutableDictionary alloc]initWithContentsOfFile:path];
    _array=@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"W",@"X",@"Y",@"Z"];
    
}

- (void)createtitleView{
    self.navigationItem.title=@"对症找药";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createtableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataDic[_array[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
//    NSArray *array=_dataDic[_array[indexPath.section]];
//    cell.name.text=array[indexPath.row];

    cell.textLabel.text=_dataDic[_array[indexPath.section]][indexPath.row];
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataDic.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"%@",_array[section]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str=_dataDic[_array[indexPath.section]][indexPath.row];
    WZSSearchDetailViewController *vc=[[WZSSearchDetailViewController alloc]init];
    vc.name=str;
    [self.navigationController pushViewController:vc animated:YES];
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _array;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
