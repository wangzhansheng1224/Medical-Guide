//
//  WZSClassifyViewController.m
//  药品手册
//
//  Created by wzs on 16/6/18.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSClassifyViewController.h"
#import "WZSClassifyCollectionViewCell.h"
#import "WZSDetailViewController.h"

@interface WZSClassifyViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collectionV;
@property (nonatomic,strong)NSArray *imageArr;
@property (nonatomic,strong)NSArray *titleArr;
@end

@implementation WZSClassifyViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    _imageArr = @[@"classify_jtyx",@"classify_gmyy",@"classify_wssg",@"classify_mxby",@"classify_fkyy",@"classify_nkyy",@"classify_etyy"];
    _titleArr = @[@"家庭药箱",@"感冒用药",@"维生素/钙",@"慢性病药",@"妇科用药",@"男科用药",@"儿童用药"];
    [self createCollectionV];
    [self createtitleView];
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
    
    //左侧图标
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"common_scan"] style:UIBarButtonItemStylePlain target:self action:@selector(scan)];
    
    //    UIImageView *leftimageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    //    leftimageV.backgroundColor = [UIColor redColor];
    //    leftimageV.contentMode=UIViewContentModeLeft;
    //    leftimageV.image=[UIImage imageNamed:@"navi_logo"];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftimageV];
    //
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navi_logo"] style:UIBarButtonItemStyleDone target:self action:nil];
    
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

- (void)createCollectionV{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing=0;
    flowLayout.minimumLineSpacing=0;
    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    _collectionV = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    _collectionV.delegate=self;
    _collectionV.dataSource=self;
    [_collectionV registerNib:[UINib nibWithNibName:@"WZSClassifyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    _collectionV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionV];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WZSClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageV.image =[UIImage imageNamed:_imageArr[indexPath.item]];
    cell.name.text = _titleArr[indexPath.item];
    //    cell.backgroundColor = [UIColor redColor];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(WIDTH/3, WIDTH/3);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WZSDetailViewController *vc = [[WZSDetailViewController alloc]init];
    vc.name=_titleArr[indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
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
