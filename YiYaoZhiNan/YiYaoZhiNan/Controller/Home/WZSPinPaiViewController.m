//
//  WZSPinPaiViewController.m
//  药品手册
//
//  Created by wzs on 16/6/23.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSPinPaiViewController.h"
#import "WZSSearchDetailViewController.h"

#import "WZSPinPaiCollectionViewCell.h"
#import "WZSPinPaiModel.h"

@interface WZSPinPaiViewController ()<UICollectionViewDataSource,UIBarPositioningDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UICollectionView *collectionV;

@end

@implementation WZSPinPaiViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tabBarController.tabBar.hidden=YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createNavigationController];
    [self createCollectionView];
    // Do any additional setup after loading the view.
}

-(void)createNavigationController{
    self.navigationItem.title=@"品牌";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing=0;
    flowLayout.minimumLineSpacing=0;
    _collectionV=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) collectionViewLayout:flowLayout];
    _collectionV.delegate=self;
    _collectionV.dataSource=self;
    _collectionV.backgroundColor=[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_collectionV];
    [_collectionV registerNib:[UINib nibWithNibName:@"WZSPinPaiCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WZSPinPaiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    WZSPinPaiModel *model = self.dataArr[indexPath.item];
    cell.name.text=model.namecn;
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.titleimg]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(WIDTH/3, WIDTH/3);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WZSSearchDetailViewController *vc=[[WZSSearchDetailViewController alloc]init];
    WZSPinPaiModel *model = self.dataArr[indexPath.item];
    vc.name=model.namecn;
    [self.navigationController pushViewController:vc animated:YES];
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
