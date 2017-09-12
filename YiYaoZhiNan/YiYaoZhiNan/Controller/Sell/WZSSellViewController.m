//
//  WZSSellViewController.m
//  药品手册
//
//  Created by wzs on 16/6/24.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSSellViewController.h"

#import "WZSInstructionTableViewCell.h"
#import "WZSCommentTableViewCell.h"
#import "WZSDrugInstructionModel.h"
#import "WZSCommentModel.h"
#import "WZSSqlite.h"
#import "UMSocial.h"

@interface WZSSellViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic)UILabel *companyname;
@property (nonatomic)UILabel *gongneng;
@property (nonatomic,assign)NSInteger currentview;
@property (nonatomic)UIView *btnview;
@property (nonatomic)UITableView *tableView;
@property (nonatomic)UIView *titleView;
@property (nonatomic)NSMutableArray *dataArr;
@property (nonatomic)NSMutableArray *commentArr;
@end

@implementation WZSSellViewController
- (void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tabBarController.tabBar.hidden=YES;
    _currentview=0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    [self loadInstructionData];
    [self loadCommentData];
    [self createNavigationView];
    [self createTitleView];
    [self createTableView];
    // Do any additional setup after loading the view.
}


- (void)loadInstructionData{
    NSString *url=[NSString stringWithFormat:DRUG_INSTRUCTION,[self.myid integerValue]];
    [WZSHDManager startLoadingString:@"加载中" MBProgressHUDMode:MBProgressHUDModeIndeterminate minShowTime:0.5];
    [WZSRequestHttp requestData:GET Url:url parameter:nil andHttpBlock:^(NSData *data, NSError *error) {
        if (!error) {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"%@",dic);
            NSDictionary *dict=dic[@"results"];
            WZSDrugInstructionModel *model=[[WZSDrugInstructionModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [self.dataArr addObject:model];
            [self changtitltViewUI];
            [WZSHDManager stopLoading];
            [_tableView reloadData];
        }else{
            [WZSHDManager stopLoading];
            NSLog(@"%@",error.localizedDescription);
            [WZSHDManager startLoadingString:error.localizedDescription MBProgressHUDMode:MBProgressHUDModeText minShowTime:0.5];
            [WZSHDManager stopLoading];
        }
    }];
}

- (void)loadCommentData{
    NSString *url=[NSString stringWithFormat:DRUG_COMMENT,[self.myid integerValue]];
    [WZSRequestHttp requestData:GET Url:url parameter:nil andHttpBlock:^(NSData *data, NSError *error) {
        if (!error) {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dict=dic[@"results"];
            NSArray *array=dict[@"List"];
            for (NSDictionary *dic in array) {
                WZSCommentModel *model=[[WZSCommentModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.commentArr addObject:model];
            }
            
        }
    }];
}

- (void)createNavigationView{
    self.navigationItem.title=@"药品详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btn setBackgroundImage:[UIImage imageNamed:@"details_collect_normal"] forState:UIControlStateNormal];
    if ([WZSSqlite isFavorted:self.myid]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"details_collect_selected"] forState:UIControlStateNormal];
    }
    [btn addTarget:self action:@selector(rightbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemright1=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *itemright2=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share_selected"] style:UIBarButtonItemStylePlain target:self action:@selector(rightbtn2Click)];
    self.navigationItem.rightBarButtonItems=@[itemright2,itemright1];}

- (void)rightbtnClick:(UIButton *)btn{
    if ([WZSSqlite isFavorted:self.myid]) {
        [WZSSqlite removeApp:self.myid];
        [btn setBackgroundImage:[UIImage imageNamed:@"details_collect_normal"] forState:UIControlStateNormal];
        [WZSHDManager startLoadingString:@"取消收藏" MBProgressHUDMode:MBProgressHUDModeText minShowTime:0.5];
        [WZSHDManager stopLoading];
    }else{
        [WZSSqlite favoriteApps:self.dataArr];
        [btn setBackgroundImage:[UIImage imageNamed:@"details_collect_selected"] forState:UIControlStateNormal];
        [WZSHDManager startLoadingString:@"收藏成功" MBProgressHUDMode:MBProgressHUDModeText minShowTime:0.5];
        [WZSHDManager stopLoading];
    }
    
    
    }
- (void)rightbtn2Click{
    [UMSocialData defaultData].extConfig.title = @"药品手册";
    //    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"";
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"57752f91e0f55afd83000f89"
                                      shareText:[NSString stringWithFormat:@"我用药品手册查询了[%@],能查到详细的说明书、价格",self.title1]
                                     shareImage:[UIImage imageNamed:@"placeholdimage"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone]
                                       delegate:nil];
}


- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTitleView{
    _titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 100)];
    _titleView.backgroundColor=[UIColor whiteColor];
    
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 90, 90)];
    imageV.backgroundColor=[UIColor redColor];
    [imageV sd_setImageWithURL:[NSURL URLWithString:self.imageurl] placeholderImage:[UIImage imageNamed:@"placeholdimage"]];
    [_titleView addSubview:imageV];
    
    UILabel *titlename=[[UILabel alloc]initWithFrame:CGRectMake(110, 0, WIDTH-110, 25)];
    titlename.text=self.title1;
    titlename.textColor=[UIColor colorWithRed:47/255.0 green:115/255.0 blue:250/255.0 alpha:1];
    titlename.font=[UIFont systemFontOfSize:17];
    [_titleView addSubview:titlename];
    
    _companyname=[[UILabel alloc]initWithFrame:CGRectMake(110, 25, WIDTH-110, 15)];
    _companyname.text=self.companynameStr;
    _companyname.textColor=[UIColor grayColor];
    _companyname.font=[UIFont systemFontOfSize:15];
    [_titleView addSubview:_companyname];
    
    _gongneng=[[UILabel alloc]initWithFrame:CGRectMake(110, 40, WIDTH-120, 40)];
    _gongneng.text=self.gongnengStr;
    _gongneng.textColor=[UIColor grayColor];
    _gongneng.font=[UIFont systemFontOfSize:13];
    _gongneng.numberOfLines=2;
    [_titleView addSubview:_gongneng];
    
}

- (void)changtitltViewUI{
    WZSDrugInstructionModel *model=self.dataArr[0];
    
    _gongneng.text=model.gongneng;
    
    _companyname.text=model.refdrugcompanyname;
    
    for (int i=0; i<5; i++) {
        UIImageView *imagestar=[[UIImageView alloc]initWithFrame:CGRectMake(110+16*i, 80, 16, 16)];
        imagestar.image=[UIImage imageNamed:@"star"];
        [_titleView addSubview:imagestar];
    }

    for (int i=0; i<model.score; i++) {
        UIImageView *imagestar=[[UIImageView alloc]initWithFrame:CGRectMake(110+16*i, 80, 16, 16)];
        imagestar.image=[UIImage imageNamed:@"star_highlighted"];
        [_titleView addSubview:imagestar];
    }
    UIImageView *ji=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-30, 80, 16,16)];
    [_titleView addSubview:ji];
    UIImageView *bao=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-50, 80, 16, 16)];
    [_titleView addSubview:bao];
    UIImageView *otc=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-75, 80, 20, 16)];
    [_titleView addSubview:otc];
    if (model.basemed==1) {
        ji.image=[UIImage imageNamed:@"drug_base"];
    }else{
        bao.center=CGPointMake(bao.center.x+20, bao.center.y);
        otc.center=CGPointMake(otc.center.x+20, otc.center.y);
    }
    if (model.medcare==1) {
        bao.image=[UIImage imageNamed:@"drug_medical_insurance"];
    }else{
        otc.center=CGPointMake(otc.center.x+20, otc.center.y);
    }
    if (model.newotc==1) {
        otc.image=[UIImage imageNamed:@"drug_otc_a"];
    }else if (model.newotc==2){
        otc.image=[UIImage imageNamed:@"drug_otc_b"];
    }else{
        otc.image=[UIImage imageNamed:@"drug_rx"];
    }

}


- (void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView=_titleView;
    _tableView.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    [_tableView registerClass:[WZSInstructionTableViewCell class] forCellReuseIdentifier:@"123"];
    [_tableView registerClass:[WZSCommentTableViewCell class] forCellReuseIdentifier:@"456"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_currentview==0) {
        if (self.dataArr.count!=0) {
            return 17;
        }
        return self.dataArr.count;
    }else{
        return self.commentArr.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentview==0) {
        _tableView.separatorColor=[UIColor clearColor];
        WZSInstructionTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"123" forIndexPath:indexPath];
        WZSDrugInstructionModel *model=self.dataArr[0];
        if (indexPath.item==0) {
            cell.label1.text=@"【药品名称】";
            [cell setContent:[NSString stringWithFormat:@"通用名称:%@",model.namecn]];
        }else if (indexPath.item==1){
            cell.label1.text=@"【成分】";
            [cell setContent:model.composition];
        }else if (indexPath.item==2){
            cell.label1.text=@"【性状】";
            [cell setContent:model.drugattribute];
        }else if (indexPath.item==3){
            cell.label1.text=@"【适应症】";
            [cell setContent:model.gongneng];
        }else if (indexPath.item==4){
            cell.label1.text=@"【规格】";
            [cell setContent:model.unit];
        }else if (indexPath.item==5){
            cell.label1.text=@"【用法用量】";
            [cell setContent:model.usage];
        }else if (indexPath.item==6){
            cell.label1.text=@"【不良反应】";
            [cell setContent:model.adr];
        }else if (indexPath.item==7){
            cell.label1.text=@"【禁忌】";
            [cell setContent:model.contraindication];
        }else if (indexPath.item==8){
            cell.label1.text=@"【注意事项】";
            [cell setContent:model.note];
        }else if (indexPath.item==9){
            cell.label1.text=@"【药物相互作用】";
            [cell setContent:model.interaction];
        }else if (indexPath.item==10){
            cell.label1.text=@"【药理作用】";
            [cell setContent:model.pharmacology];
        }else if (indexPath.item==11){
            cell.label1.text=@"【贮藏】";
            [cell setContent:model.storage];
        }else if (indexPath.item==12){
            cell.label1.text=@"【有效期】";
            [cell setContent:model.shelflife];
        }else if (indexPath.item==13){
            cell.label1.text=@"【批准文号】";
            [cell setContent:model.codename];
        }else if (indexPath.item==14){
            cell.label1.text=@"【执行标准】";
            [cell setContent:model.standard];
        }else if (indexPath.item==15){
            cell.label1.text=@"【说明书修订日期】";
            [cell setContent:model.specificationdate];
        }else if (indexPath.item==16){
            cell.label1.text=@"【生产企业】";
            [cell setContent:model.refdrugcompanyname];
        }
        tableView.rowHeight=cell.cellHeight;
        cell.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
        return cell;
    }else{
        _tableView.separatorColor=[UIColor grayColor];
        WZSCommentTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"456" forIndexPath:indexPath];
        WZSCommentModel *model=self.commentArr[indexPath.item];
        if ([model.username isEqualToString:@""]) {
            cell.label1.text=@"匿名用户";
        }else{
            cell.label1.text=model.username;
        }
        cell.goodcount.text=[NSString stringWithFormat:@"%ld",model.useful];
        [cell setContent:model.content];
        _tableView.rowHeight=cell.cellHeight;
        cell.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
        return cell;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _btnview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    
    UIImageView *upline=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
    upline.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [_btnview addSubview:upline];
    
    UIImageView *downline=[[UIImageView alloc]initWithFrame:CGRectMake(0, 39, WIDTH, 1)];
    downline.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];;
    [_btnview addSubview:downline];
    
    NSArray *btnItem=@[@"说明书",@"用药点评"];
    for (int i=0; i<2; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(i*WIDTH/2, 0, WIDTH/2, 38)];
        [_btnview addSubview:btn];
        [btn setTitle:btnItem[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag=1000+i;
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        if (btn.tag==1000) {
//            btn.selected=YES;
//        }
        UILabel *lineV=[[UILabel alloc]initWithFrame:CGRectMake(i*WIDTH/2, 38, WIDTH/2, 2)];
        lineV.backgroundColor=[UIColor clearColor];
        [_btnview addSubview:lineV];
        lineV.tag=1100+i;
        if (lineV.tag==_currentview+1100) {
            lineV.backgroundColor=[UIColor blueColor];
        }
    }
    _btnview.backgroundColor=[UIColor whiteColor];
    return _btnview;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)btnClick:(UIButton *)btn{
//    for (UIView *view in _btnview.subviews) {
//        if ([view isKindOfClass:[UIButton class]]) {
//            UIButton *item=(UIButton *)view;
//            if (item==btn) {
//                item.selected=YES;
//            }else{
//                item.selected=NO;
//            }
//        }
//        if ([view isKindOfClass:[UILabel class]]) {
//            UILabel *line=(UILabel *)view;
//            if (line.tag==btn.tag+100) {
//                line.backgroundColor=[UIColor blueColor];
//                _currentview=btn.tag-1000;
//            }else{
//                line.backgroundColor=[UIColor clearColor];
//            }
//        }
//    }
    _currentview=btn.tag-1000;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataArr{
    ArrayLazyLoad(_dataArr);
}

- (NSMutableArray *)commentArr{
    ArrayLazyLoad(_commentArr);
}

@end
