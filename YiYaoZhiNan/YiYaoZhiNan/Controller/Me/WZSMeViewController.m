//
//  WZSMeViewController.m
//  药品手册
//
//  Created by wzs on 16/6/18.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSMeViewController.h"
#import "WZSCollectViewController.h"
#import "WZSZiXunViewController.h"

#import "WZSRemindViewController.h"
#import "UMSocial.h"

@interface WZSMeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *titleArr;
@property (nonatomic,strong)NSArray *imageArr;
@property (nonatomic,strong)UIView *titleView;
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,strong)UIView *blackView;
@property (nonatomic,strong)UIImageView *imageV;
@property (nonatomic,strong)UILabel *label1;
@property (nonatomic,strong)UILabel *label2;
@property (nonatomic,strong)UIButton *zhuxiaobtn;
@property (nonatomic,strong)UIButton *denglubtn;

@end

@implementation WZSMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationItem.title=@"我";
    _count=0;
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    _titleArr=@[@"我的收藏",@"我的咨询",@"服药提醒",@"清除缓存"];
    _imageArr=@[@"mine_collection@2x",@"mine_consultation@2x",@"mine_drug_remind",@"mine_comment"];
    [self createTitleView];
    [self createTableView];
    // Do any additional setup after loading the view.
}

- (void)createTitleView{
    _titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
    _titleView.backgroundColor=[UIColor colorWithRed:78/255.0 green:135/255.0 blue:250/255.0 alpha:1];
    _imageV=[[UIImageView alloc]initWithFrame:CGRectMake(30, 20, 60, 60)];
    _imageV.layer.cornerRadius=30;
    _imageV.layer.masksToBounds=YES;
    _imageV.image=[UIImage imageNamed:@"mine_default_header"];
    [_titleView addSubview:_imageV];
    
    _denglubtn=[[UIButton alloc]init];
    _denglubtn.frame=CGRectMake(100, 100, 100, 100);
    _denglubtn.center=CGPointMake(WIDTH/2, 50);
    [_denglubtn setTitle:@"登录" forState:UIControlStateNormal];
    [_denglubtn addTarget:self action:@selector(denglu:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_denglubtn];
    
    _zhuxiaobtn=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-100, 35, 80, 30)];
    [_zhuxiaobtn setTitle:@"注销" forState:UIControlStateNormal];
    [_zhuxiaobtn addTarget:self action:@selector(zhuxiao:) forControlEvents:UIControlEventTouchUpInside];
    _zhuxiaobtn.layer.borderWidth=1;
    _zhuxiaobtn.layer.borderColor=[UIColor whiteColor].CGColor;
    [_titleView addSubview:_zhuxiaobtn];
    _zhuxiaobtn.hidden=YES;
    
    //姓名
    _label1=[[UILabel alloc]initWithFrame:CGRectMake(120, 20, 200, 30)];
    _label1.textColor=[UIColor whiteColor];
    [_titleView addSubview:_label1];
    _label1.hidden=YES;
    
    //性别
    _label2=[[UILabel alloc]initWithFrame:CGRectMake(120, 50, 200, 30)];
    _label2.textColor=[UIColor whiteColor];
    [_titleView addSubview:_label2];
    _label2.hidden=YES;
}

- (void)zhuxiao:(UIButton *)btn{
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
//                NSLog(@"response is %@",response);
        _label1.hidden=YES;
        _label2.hidden=YES;
        
        _denglubtn.hidden=NO;
        _zhuxiaobtn.hidden=YES;
        _imageV.image=[UIImage imageNamed:@"mine_default_header"];
        
    }];
}


- (void)denglu:(UIButton *)btn{
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
  
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
        
//            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
//            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
//            NSLog(@"%@",response.thirdPlatformUserProfile);
           
            _label1.text=response.thirdPlatformUserProfile[@"nickname"];
            _label1.hidden=NO;
            
            _label2.text=response.thirdPlatformUserProfile[@"gender"];
            _label2.hidden=NO;
            
            _zhuxiaobtn.hidden=NO;
            _denglubtn.hidden=YES;
            
            [_imageV sd_setImageWithURL:[NSURL URLWithString:response.thirdPlatformUserProfile[@"figureurl_qq_2"]]];
            
           
        }
        
    });
}

- (void)createTableView{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView=_titleView;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.imageView.image=[UIImage imageNamed:_imageArr[indexPath.row]];
    cell.textLabel.text=_titleArr[indexPath.row];
    cell.textLabel.textColor=[UIColor grayColor];
//    if (indexPath.row==3) {
//        cell.accessoryType=UITableViewCellAccessoryNone;
//        UISwitch *sw=[[UISwitch alloc]initWithFrame:CGRectMake(WIDTH-50, 15, 20, 15)];
//        [sw addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
//        [cell.contentView addSubview:sw];
//    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    tableView.rowHeight=50;
    return cell;
}

- (void)change:(UISwitch *)sw{
    if (sw.isOn) {
//        AppDelegate *app = [UIApplication sharedApplication].delegate;
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        _blackView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _blackView.backgroundColor=[UIColor colorWithWhite:0 alpha:0.3];
        [window addSubview:_blackView];
        _blackView.userInteractionEnabled=NO;
    }else {
        [_blackView removeFromSuperview];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        WZSCollectViewController *vc=[[WZSCollectViewController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==1){
        WZSZiXunViewController *vc=[[WZSZiXunViewController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==2){
        WZSRemindViewController *vc=[[WZSRemindViewController alloc]init];
        vc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row==3){
        //清除缓存
        //得到缓存管理对象
        SDImageCache * cacheManager=[SDImageCache sharedImageCache];
        //得到缓存的数据大小,单位b K M
        NSInteger fileSize =[cacheManager getSize];
        //换算成M
        CGFloat sM=fileSize *1.0/1024/1000;
//        NSString * path=[NSString stringWithFormat:@"%@/Library/Caches/default",NSHomeDirectory()];
//        NSLog(@"%@",path);
//        NSLog(@"清除缓存的大小:%.2fM",sM);
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除缓存" message:[NSString stringWithFormat:@"确定要清除共%.2fM缓存么?",sM] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [cacheManager clearDisk];
        }];
        [alert addAction:action];
        
        UIAlertAction *action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action2];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
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
