//
//  WZSVicinityViewController.m
//  药品手册
//
//  Created by wzs on 16/7/4.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSVicinityViewController.h"
//高德地图库
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
//系统地图库
#import <MapKit/MapKit.h>
//语音库
#import <AVFoundation/AVFoundation.h>

#import "WZSHDManager.h"
#import "WZSMapModel.h"
#import "WZSMapTableViewCell.h"
@interface WZSVicinityViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)MAMapView *mapView;
@property (nonatomic,strong)AMapSearchAPI *search;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,assign)NSInteger flag;
@property (nonatomic)CLLocationCoordinate2D coords1;
//定位语音
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@end

@implementation WZSVicinityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.flag=0;
    [self createTitleView];
    [self createUIView];
}

- (void)createTitleView{
    self.navigationItem.title=@"附近";
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btn setImage:[UIImage imageNamed:@"map_near_map"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"map_near_list"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem=item;
}

-(void)createUIView{
    //<1>创建父视图
    UIView * superView = [[UIView alloc]initWithFrame:CGRectMake(0,64,WIDTH,HEIGHT-49-64)];
    superView.backgroundColor = [UIColor whiteColor];
    superView.tag = 100;
    [self.view addSubview:superView];
    
    //<2>创建子视图
    UITableView *tableView=[self createTableView];
    [superView addSubview:tableView];
    
    MAMapView *mapView=[self createMapView];
    [superView addSubview:mapView];
}

-(void)pressBtn:(UIButton *)btn{
    //<1>获取父视图
    UIView * backView = [self.view viewWithTag:100];
    //<3>获取两个子视图的索引
    NSArray * array = [backView subviews];
    int index1 = (int)[array indexOfObject:_mapView];
    int index2 = (int)[array indexOfObject:_tableV];
    //<4>交换索引值
    [backView exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
    //<5>添加动画效果
    //第一个参数是向UIView协议方法传递的内容 一般的时候传递的是参与动画的UIView的tag值
    //1、开启动画效果
    [UIView beginAnimations:@"helloworld" context:nil];
    //2、设置动画的持续时间
    [UIView setAnimationDuration:1];
    //3、设置动画的路线
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //4、设置点击不同按钮出现不同的动画效果
    /*
     UIViewAnimationTransitionFlipFromLeft,
     UIViewAnimationTransitionFlipFromRight,
     UIViewAnimationTransitionCurlUp,
     UIViewAnimationTransitionCurlDown,
     */
    if(btn.selected)
    {
        //动画效果分配给父视图
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:backView cache:YES];
    }else{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:backView cache:YES];
    }
    //5、关闭动画
    [UIView commitAnimations];
    
    btn.selected=!btn.selected;
}

- (MAMapView *)createMapView{
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0,0, WIDTH,HEIGHT-64-49)];
    _mapView.delegate = self;
    _mapView.mapType = MAMapTypeStandard;
    _mapView.showsUserLocation = YES;
    
    [WZSHDManager startLoadingString:@"正在为您搜索附近药店请稍后..." MBProgressHUDMode:MBProgressHUDModeText minShowTime:1.5];
    [WZSHDManager stopLoading];
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
            
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        [WZSHDManager startLoadingString:@"获取不到您当前的位置,请检查您是否允许开启.." MBProgressHUDMode:MBProgressHUDModeText minShowTime:1];
        [WZSHDManager stopLoading];
    }
   
    return _mapView;
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        self.coords1=CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        //取出当前位置的坐标
//        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        [_mapView setZoomLevel:15 animated:YES];
        [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        if (self.flag==0) {
            [self createSearchRequest:userLocation];
            [self voiceAnnouncementsText:@"定位成功"];
            self.flag=1;
        }
    }
}

- (void)createSearchRequest:(MAUserLocation *)userLocation{
    //初始化检索对象
    _search=[[AMapSearchAPI alloc]init];
    _search.delegate=self;
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    request.keywords = @"药店";
    request.sortrule = 0;
    request.requireExtension = YES;
    request.radius=2000;
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    //通过 AMapPOISearchResponse 对象处理搜索结果
//    NSString *strCount = [NSString stringWithFormat:@"count: %ld",response.count];
//    NSLog(@"%@",strCount);
//    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
//    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        WZSMapModel *model=[[WZSMapModel alloc]init];
        model.uid=p.uid;
        model.name=p.name;
        model.location=p.location;
        model.address=p.address;
        model.tel=p.tel;
        model.distance=p.distance;
        [self addPoint:p.location andTitlie:p.name anduid:p.address];
        [self.dataArr addObject:model];
    }
    
    [_tableV reloadData];
//    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
//    NSLog(@"Place: %@", result);
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    //如果是大头针的覆盖物 执行以下代码 如果不是 返回nil
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        //大头针复用
        
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        //从复用池中找是否有可复用的MAPinAnnotationView  如果没有 创建
        
        //补充：MAPinAnnotationView 继承于MAAnnotationView（标注类 大头针）pin使用的是系统设置的样式
        
        //如果不使用系统的样式 自定义一个继承于MAAnnotationView的类
        
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = NO;        //设置标注动画显示，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        //默认样式下 大头针的颜色 红 绿 紫
        //        annotationView.pinColor = MAPinAnnotationColorPurple;
        
       
        
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
//        annotationView.centerOffset = CGPointMake(0, -18);
        
        //返回
        return annotationView;
    }
    return nil;
}

- (void)addPoint:(AMapGeoPoint *)location andTitlie:(NSString *)name anduid:(NSString *)uid{
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude);
    
    pointAnnotation.title = name;
    pointAnnotation.subtitle = uid;
    
    [_mapView addAnnotation:pointAnnotation];
    
}

- (UITableView *)createTableView{
    _tableV=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-49-64)];
    _tableV.delegate=self;
    _tableV.dataSource=self;
//    [_tableV registerNib:[UINib nibWithNibName:@"WZSMapTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    return _tableV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    WZSMapTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    WZSMapTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"WZSMapTableViewCell" owner:nil options:nil]lastObject];
    }
//    for (UIView *view in cell.subviews) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            [view removeFromSuperview];
//        }
//    }
    WZSMapModel *model=self.dataArr[indexPath.row];
    cell.name.text=model.name;
    cell.dizhi.text=model.address;
    cell.juli.text=[NSString stringWithFormat:@"%ld",(long)model.distance];
    if ([model.tel isEqualToString:@""]) {
        tableView.rowHeight=75;
        cell.phone.text=@"";
    }else{
        cell.phone.text=model.tel;
        tableView.rowHeight=95;
        UIButton *call=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-70, 0, 70, 95)];
        [call setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
        [call addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [call setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        call.tag=indexPath.row;
        [cell.contentView addSubview:call];
    }
//    cell.selected=!cell.selected;
    return cell;
}

- (void)btnClick:(UIButton *)btn{
//    btn.backgroundColor=[UIColor redColor];
    WZSMapModel *model=self.dataArr[btn.tag];
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:model.tel message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",model.tel]]];
    }];
    [alert addAction:action];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取当前位置
    WZSMapModel *model=self.dataArr[indexPath.row];
    
//    MKMapItem *mylocation = [MKMapItem mapItemForCurrentLocation];
//    
//    //当前经维度
//    float currentLatitude=mylocation.placemark.location.coordinate.latitude;
//    float currentLongitude=mylocation.placemark.location.coordinate.longitude;
//    
//    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(currentLatitude,currentLongitude);
    
    CLLocationCoordinate2D coords2 =CLLocationCoordinate2DMake(model.location.latitude,model.location.longitude);

    //起点
    MKMapItem *current = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.coords1 addressDictionary:nil]];
    //目的地的位置
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coords2 addressDictionary:nil]];
    current.name=@"起点";
    toLocation.name = model.name;

    
    NSArray *items = [NSArray arrayWithObjects:current, toLocation, nil];
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];

}

//定位成功语音
- (void)voiceAnnouncementsText:(NSString *)text
{
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    [self.synthesizer speakUtterance:utterance];
}

-  (AVSpeechSynthesizer *)synthesizer
{
    if (!_synthesizer) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
    }
    return _synthesizer;
}

- (NSMutableArray *)dataArr{
    ArrayLazyLoad(_dataArr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
