//
//  WZSHomeViewController.m
//  药品手册
//
//  Created by wzs on 16/6/20.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSHomeViewController.h"
#import "WZSImageViewController.h"
#import "WZSDetailViewController.h"
#import "WZSPinPaiViewController.h"
#import "WZSDuiZhengViewController.h"
#import "WZSConsultViewController.h"
#import "WZSRemindViewController.h"

#import "WZSHeadCollectionReusableView.h"
#import "WZSBannerReusableView.h"

#import "WZSDrugListModel.h"
#import "WZSPinPaiModel.h"


@interface WZSHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collectionV;
@property (nonatomic,strong)NSMutableArray *drugListArr;
@property (nonatomic,strong)NSMutableArray *drugListArr2;
@property (nonatomic,strong)NSMutableArray *pinPaiArr;
@property (nonatomic,strong)NSMutableArray *bannerArr;
@property (nonatomic,strong)NSMutableArray *btnArr;

@end

@implementation WZSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self createtitleView];
    [self createCollectionView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden=NO;
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
    
    //右侧图标
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"common_scan"] style:UIBarButtonItemStylePlain target:self action:@selector(scan)];
    
//    UIImageView *leftimageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
//    leftimageV.backgroundColor = [UIColor redColor];
//    leftimageV.contentMode=UIViewContentModeLeft;
//    leftimageV.image=[UIImage imageNamed:@"navi_logo"];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftimageV];
//
    //左边图标
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

- (void)loadData{
    [WZSRequestHttp requestData:GET Url:HOMEPAGE parameter:nil andHttpBlock:^(NSData *data, NSError *error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dic1 = dic[@"list"];
            NSArray *array1 = dic1[@"banner"];
            
            //轮播视图数组
            [self.bannerArr addObject:[array1[0] objectForKey:@"image_url"]];
            [self.bannerArr addObject:[array1[1] objectForKey:@"image_url"]];
            [self.bannerArr addObject:[array1[4] objectForKey:@"image_url"]];
            
            //btn数组
            [self.btnArr addObject:[array1[2] objectForKey:@"image_url"]];
            [self.btnArr addObject:[array1[3] objectForKey:@"image_url"]];
        
            //感冒用药数组
            NSArray *array2 = dic1[@"types"];
            NSDictionary *section1dic = array2[0];
            NSDictionary *section2dic = array2[1];
            NSArray *section1Arr = section1dic[@"drug_list"];
            NSArray *section2Arr = section2dic[@"drug_list"];
            for (NSDictionary *dic in section1Arr) {
                WZSDrugListModel *model = [[WZSDrugListModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                
                [self.drugListArr addObject:model];
            }
            //慢性病药数组
            for (NSDictionary *dic in section2Arr) {
                WZSDrugListModel *model = [[WZSDrugListModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.drugListArr2 addObject:model];
            }

        }else{
            NSLog(@"解析错误");
        }
        [_collectionV reloadData];
    }];
    
    //品牌合作数组
    [WZSRequestHttp requestData:GET Url:PINPAI parameter:nil andHttpBlock:^(NSData *data, NSError *error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *array=dic[@"results"];
            for (NSDictionary *dic in array) {
                WZSPinPaiModel *model = [[WZSPinPaiModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.pinPaiArr addObject:model];
            }
        }else{
            [WZSHDManager startLoadingString:error.localizedDescription MBProgressHUDMode:MBProgressHUDModeText minShowTime:0.5];
        }
//        NSLog(@"%ld",self.pinPaiArr.count);
        [_collectionV reloadData];
    }];
}

- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing=0;
    flowLayout.minimumLineSpacing=0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionV = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    _collectionV.delegate=self;
    _collectionV.dataSource=self;
//    _collectionV.bounces=NO;
    [self.view addSubview:_collectionV];
    _collectionV.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_collectionV registerNib:[UINib nibWithNibName:@"WZSHomeDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"123"];
    [_collectionV registerNib:[UINib nibWithNibName:@"WZSPinPaiCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"456"];
    //注册头标
    [_collectionV registerClass:[WZSBannerReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header1"];
    [_collectionV registerClass:[WZSHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header2"];
    
    //注册脚标
    [_collectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==2) {
        return 6;
    }
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2) {
        WZSPinPaiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"456" forIndexPath:indexPath];
        if (self.pinPaiArr.count!=0) {
            WZSPinPaiModel *model=self.pinPaiArr[indexPath.item];
            cell.name.text = model.namecn;
            [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.titleimg]];
        }
        return cell;
    }
    WZSHomeDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"123" forIndexPath:indexPath];
    [cell fuyuan];
    cell.backgroundColor = [UIColor whiteColor];
    if (self.drugListArr.count!=0) {
        WZSDrugListModel *model = [[WZSDrugListModel alloc]init];
        if (indexPath.section==0) {
            model=self.drugListArr[indexPath.item];
        }else{
            model=self.drugListArr2[indexPath.item];
        }
        [cell changtubiaoOTC:model.NewOTC MedCare:model.MedCare BaseMed:model.BaseMed];
        cell.name.text = model.NameCN;
        cell.price.text = [NSString stringWithFormat:@"¥%@",model.AvgPrice];
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.TitleImg]];
    }
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (indexPath.section==0) {
            WZSBannerReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header1" forIndexPath:indexPath];
            header.userInteractionEnabled=YES;
            
            //扫码btn跳转block
            [header sendBlock:^{
                WZSScanViewController *vc = [[WZSScanViewController alloc]init];
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            //咨询跳转block
            [header sendBlock2:^{
                WZSConsultViewController *vc=[[WZSConsultViewController alloc]init];
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            //服药提醒
            [header sendBlock3:^{
                WZSRemindViewController *vc=[[WZSRemindViewController alloc]init];
                vc.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            //对症找药跳转block
            [header sendBlock4:^{
                WZSDuiZhengViewController *vc=[[WZSDuiZhengViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            //imageview跳转block
            [header sendtap1target:self sel:@selector(tiaozhuan1)];
            [header sendtap2target:self sel:@selector(tiaozhuan2)];
            [header sendtap3target:self sel:@selector(tiaozhuan3)];
            
            //btnimage下载
            if (self.btnArr.count !=0) {
                [header.leftimage sd_setImageWithURL:[NSURL URLWithString:self.btnArr[0]]];
                [header.rightimage sd_setImageWithURL:[NSURL URLWithString:self.btnArr[1]]];
            }

            //轮播图片下载
            header.scrollView.imageURLArray = self.bannerArr;
            return header;
        }
        WZSHeadCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header2" forIndexPath:indexPath];
        if (indexPath.section==1) {
            header.labeltitle.text = @"慢性病药";
            [header addTap:self SEL:@selector(tap1)];
        }else{
            header.labeltitle.text = @"合作品牌";
            [header addTap:self SEL:@selector(tap2)];
        }
        return header;
    }
    //脚标
    else
    {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Footer" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        return footerView;
    }

    return nil;
}

- (void)tiaozhuan1{
    WZSImageViewController *vc=[[WZSImageViewController alloc]init];
    vc.url=LEFTIMAGE;
    vc.titlename=@"家庭药箱";
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tiaozhuan2{
    WZSImageViewController *vc=[[WZSImageViewController alloc]init];
    vc.url=RIGHTMAGE;
    vc.titlename=@"维生素/钙";
    vc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tiaozhuan3{
    WZSDetailViewController *vc=[[WZSDetailViewController alloc]init];
    vc.name=@"感冒用药";
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tap1{
    WZSDetailViewController *vc=[[WZSDetailViewController alloc]init];
    vc.name = @"慢性病药";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tap2{
    WZSPinPaiViewController *vc=[[WZSPinPaiViewController alloc]init];
    vc.dataArr = [[NSArray alloc]initWithArray:self.pinPaiArr];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%@",indexPath);
    if (indexPath.section==2) {
        WZSSearchDetailViewController *vc= [[WZSSearchDetailViewController alloc]init];
        if (self.pinPaiArr.count<=indexPath.row) {
            return;
        }
        WZSPinPaiModel *model = self.pinPaiArr[indexPath.item];
        vc.name=model.namecn;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        WZSSellViewController *vc=[[WZSSellViewController alloc]init];
        if (self.drugListArr.count==0) {
            return;
        }
        if (indexPath.section==0) {
            WZSDrugListModel *model=self.drugListArr[indexPath.item];
            vc.myid=model.myid;
            vc.imageurl=model.TitleImg;
            vc.title1=model.NameCN;
        }else{
            WZSDrugListModel *model=self.drugListArr2[indexPath.item];
            vc.myid=model.myid;
            vc.imageurl=model.TitleImg;
            vc.title1=model.NameCN;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return CGSizeMake(WIDTH, WIDTH/2+WIDTH/4+130);
    }
    return CGSizeMake(WIDTH, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(WIDTH, 5);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return CGSizeMake(WIDTH/3, WIDTH/3);
    }
    
    return CGSizeMake(WIDTH/2, WIDTH/2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)drugListArr{
    ArrayLazyLoad(_drugListArr);
}
- (NSMutableArray *)drugListArr2{
    ArrayLazyLoad(_drugListArr2);
}

- (NSMutableArray *)pinPaiArr{
    ArrayLazyLoad(_pinPaiArr);
}

- (NSMutableArray *)bannerArr{
    ArrayLazyLoad(_bannerArr);
}

- (NSMutableArray *)btnArr{
    ArrayLazyLoad(_btnArr);
}

@end
