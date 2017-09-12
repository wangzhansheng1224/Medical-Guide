//
//  WZSSearchDetailViewController.m
//  药品手册
//
//  Created by wzs on 16/6/22.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSSearchDetailViewController.h"
#import "WZSHomeDetailCollectionViewCell.h"
#import "WZSDetailModel.h"

@interface WZSSearchDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collection;
@property (nonatomic,strong)UIActivityIndicatorView *actIV;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)MJRefreshAutoNormalFooter* footer;
@end

@implementation WZSSearchDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createtitleView];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor yellowColor];
    self.page=0;
    [self loadData];
    [self createCollectionView];
    [self createActivityIndicatorView];
    
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
    label.text=self.name;
    label.textColor = [UIColor grayColor];
    [titleview addSubview:label];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 7, 16, 16)];
    imageV.image = [UIImage imageNamed:@"homepage_search"];
    [titleview addSubview:imageV];
    
    //右侧图标
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"common_scan"] style:UIBarButtonItemStylePlain target:self action:@selector(scan)];
    
    //
    //左边图标
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    
}

- (void)scan{
    WZSScanViewController *vc=[[WZSScanViewController alloc]init];
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapGR{
    WZSSearchViewController *vc = [[WZSSearchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}



- (void)createActivityIndicatorView{
    _actIV = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(100, 100, 20, 20)];
    [_actIV startAnimating];
    _actIV.color = [UIColor grayColor];
    _actIV.center = CGPointMake(self.view.center.x, self.view.center.y);
    [self.view addSubview:_actIV];
}
- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    NSString * url = [NSString stringWithFormat:SOUSUO_DETAIL,self.page,self.name];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [WZSRequestHttp requestData:GET Url:url parameter:nil andHttpBlock:^(NSData *data, NSError *error) {
        if (!error) {
            [self.dataArr removeAllObjects];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dict = dic[@"results"];
            NSArray *array = dict[@"List"];
            //            NSLog(@"%@",array);
            for (NSDictionary *dic in array) {
                WZSDetailModel *model = [[WZSDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:model];
            }
            [_actIV stopAnimating];
            [self stopLoadData];
            [_collection reloadData];
        }
    }];
}

- (void)loadMoreData{
    NSString * url = [NSString stringWithFormat:SOUSOU_DETAIL_MORE,self.name,self.page];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [WZSRequestHttp requestData:GET Url:url parameter:nil andHttpBlock:^(NSData *data, NSError *error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dict = dic[@"results"];
            NSArray *array = dict[@"List"];
            if (array.count==0) {
                [_footer setTitle:@"没有更多药品信息了" forState:MJRefreshStateIdle];
            }
            //            NSLog(@"%@",array);
            for (NSDictionary *dic in array) {
                WZSDetailModel *model = [[WZSDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:model];
            }
            [_actIV stopAnimating];
            [self stopLoadData];
            [_collection reloadData];
        }
    }];
}


- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing=0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, self.view.frame.size.height-64) collectionViewLayout:flowLayout];
    _collection.delegate=self;
    //    _collection.bounces = NO;
    _collection.dataSource=self;
    [_collection registerNib:[UINib nibWithNibName:@"WZSHomeDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:_collection];
    _collection.backgroundColor= [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _collection.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    //添加上拉加载更多数据
    _footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self MoreData];
    }];
    _collection.footer=_footer;
}

- (void)refreshData{
    self.page=0;
    [self loadData];
}

- (void)MoreData{
    self.page=self.page+20;
    [self loadMoreData];
}

- (void)stopLoadData{
    [self.collection.header endRefreshing];
    [self.collection.footer endRefreshing];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WZSHomeDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell fuyuan];
    WZSDetailModel *model = self.dataArr[indexPath.item];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.titleimg] placeholderImage:[UIImage imageNamed:@"placeholdimage"]];
    cell.name.text = model.namecn;
    if (model.avgprice == 0) {
        cell.price.text = @"暂无报价";
    }else{
        cell.price.text = [NSString stringWithFormat:@"¥ %.2f",model.avgprice];
    }
    [cell changtubiaoOTC:[NSString stringWithFormat:@"%ld",model.newotc] MedCare:[NSString stringWithFormat:@"%ld",model.medcare] BaseMed:[NSString stringWithFormat:@"%d",model.basemed]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WZSSellViewController *vc=[[WZSSellViewController alloc]init];
    WZSDetailModel *model=self.dataArr[indexPath.item];
    vc.myid=model._id;
    vc.imageurl=model.titleimg;
    vc.title1=model.namecn;
    vc.gongnengStr=model.gongneng;
    vc.companynameStr=model.refdrugcompanyname;
    [self.navigationController pushViewController:vc animated:YES];

    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(WIDTH/2, WIDTH/2);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataArr{
    ArrayLazyLoad(_dataArr);
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
