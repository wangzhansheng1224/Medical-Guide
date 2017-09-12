//
//  WZSImageViewController.m
//  药品手册
//
//  Created by wzs on 16/6/23.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSImageViewController.h"

#import "WZSDrugListModel.h"

@interface WZSImageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collectionV;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSString *titleimage;

@end

@implementation WZSImageViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=NO;
//    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationController];
    self.view.backgroundColor=[UIColor redColor];
    [self loadData];
    [self createCollectionView];
    // Do any additional setup after loading the view.
}

-(void)createNavigationController{
    self.navigationItem.title=self.titlename;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
//    [WZSHDManager startLoading];
    [WZSRequestHttp requestData:GET Url:self.url parameter:nil andHttpBlock:^(NSData *data, NSError *error) {
        if (!error) {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dict=dic[@"list"];
            _titleimage = dict[@"banner_image_url"];
            NSArray *array=dict[@"drug_list"];
            for (NSDictionary *dic in array) {
                WZSDrugListModel *model=[[WZSDrugListModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:model];
            }
        }else{
            NSLog(@"解析失败");
        }
        [_collectionV reloadData];
//        [WZSHDManager stopLoading];
    }];
}

- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing=0;
    flowLayout.minimumLineSpacing=0;
    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    _collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) collectionViewLayout:flowLayout];
    _collectionV.delegate=self;
    _collectionV.dataSource=self;
    _collectionV.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_collectionV];
    [_collectionV registerNib:[UINib nibWithNibName:@"WZSHomeDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [_collectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WZSHomeDetailCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.dataArr.count!=0) {
        WZSDrugListModel *model=self.dataArr[indexPath.item];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.TitleImg] placeholderImage:[UIImage imageNamed:@"placeholdimage"]];
        cell.name.text=model.NameCN;
        cell.price.text = model.AvgPrice;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WZSSellViewController *vc=[[WZSSellViewController alloc]init];
    WZSDrugListModel *model=self.dataArr[indexPath.item];
    vc.myid=model.myid;
    vc.imageurl=model.TitleImg;
    vc.title1=model.NameCN;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
        UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.45*WIDTH)];
        imageV.backgroundColor=[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [header addSubview:imageV];
        [imageV sd_setImageWithURL:[NSURL URLWithString:self.titleimage]];
        return header;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(WIDTH/2, WIDTH/2);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(WIDTH, 0.45*WIDTH);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)dataArr{
    ArrayLazyLoad(_dataArr);
}
@end
