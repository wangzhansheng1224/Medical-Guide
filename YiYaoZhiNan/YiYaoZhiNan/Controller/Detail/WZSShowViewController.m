//
//  WZSShowViewController.m
//  药品手册
//
//  Created by wzs on 16/6/21.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSShowViewController.h"
#import "WZSHomeDetailCollectionViewCell.h"
#import "WZSDetailModel.h"
@interface WZSShowViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collection;
@property (nonatomic,strong)UIActivityIndicatorView *actIV;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)MJRefreshAutoNormalFooter *footer;
@end

@implementation WZSShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page=0;
    [self loadData];
    [self createCollectionView];
    [self createActivityIndicatorView];

   
    // Do any additional setup after loading the view.
}

- (void)createActivityIndicatorView{
    _actIV = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(100, 100, 20, 20)];
    [_actIV startAnimating];
    _actIV.color = [UIColor grayColor];
    _actIV.center = CGPointMake(self.view.center.x, self.view.center.y-80);
    [self.view addSubview:_actIV];
}
- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    NSString * url = [NSString stringWithFormat:FENLEI,self.name,(long)self.page];
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
    NSString * url = [NSString stringWithFormat:SOUSOU_DETAIL_MORE,self.name,(long)self.page];
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
        }else{
            NSLog(@"解析错误");
            [_footer setTitle:@"没有更多药品信息了" forState:MJRefreshStateIdle];
        }
    }];
}


- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing=0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, self.view.frame.size.height-64-40) collectionViewLayout:flowLayout];
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
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.titleimg]placeholderImage:[UIImage imageNamed:@"placeholdimage"]];
    cell.name.text = model.namecn;
    if (model.avgprice == 0) {
        cell.price.text = @"暂无报价";
    }else{
        cell.price.text = [NSString stringWithFormat:@"¥ %.2f",model.avgprice];
    }
    [cell changtubiaoOTC:[NSString stringWithFormat:@"%ld",(long)model.newotc] MedCare:[NSString stringWithFormat:@"%ld",model.medcare] BaseMed:[NSString stringWithFormat:@"%d",model.basemed]];
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
