//
//  WZSCollectViewController.m
//  药品手册
//
//  Created by wzs on 16/6/27.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSCollectViewController.h"
#import "WZSCollectTableViewCell.h"
#import "WZSSqlite.h"
#import "WZSDrugInstructionModel.h"

@interface WZSCollectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic)NSMutableArray *dataArr;
@property (nonatomic)UITableView *tableView;
@end

@implementation WZSCollectViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.automaticallyAdjustsScrollViewInsets=NO;
    [self createNavigationController];
    [self loadData];
    [self createTableView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)createNavigationController{
    self.navigationItem.title=@"我的收藏";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    self.dataArr=[WZSSqlite selectData];
}

- (void)createTableView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"WZSCollectTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WZSCollectTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    WZSDrugInstructionModel *model=self.dataArr[indexPath.row];
    cell.name.text=model.namecn;
    cell.company.text=model.refdrugcompanyname;
    cell.gongneng.text=model.gongneng;
    cell.price.text=[NSString stringWithFormat:@"¥%0.2f",model.avgprice];
    _tableView.rowHeight=90;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WZSDrugInstructionModel *model=self.dataArr[indexPath.row];
    WZSSellViewController *vc=[[WZSSellViewController alloc]init];
    vc.myid=[NSString stringWithFormat:@"%ld",(long)model._id];
    vc.imageurl=model.titleimg;
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
