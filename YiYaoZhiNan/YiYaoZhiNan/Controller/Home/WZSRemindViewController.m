//
//  WZSRemindViewController.m
//  药品手册
//
//  Created by wzs on 16/6/29.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSRemindViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface WZSRemindViewController ()
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic)UIDatePicker *datePicker;
@property (nonatomic)UILabel *timeLabel;
@end

@implementation WZSRemindViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createNavigationController];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createNavigationController{
    self.navigationItem.title=@"服药提醒";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI{
    UILabel *tixinglabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 80, WIDTH-100, 30)];
    tixinglabel.text=@"请选择提醒时间";
    tixinglabel.textAlignment=NSTextAlignmentCenter;
    tixinglabel.textColor=[UIColor colorWithRed:47/255.0 green:115/255.0 blue:250/255.0 alpha:1];
    [self.view addSubview:tixinglabel];
    
    _datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(50, 110, WIDTH-100, 190)];
    [self.view addSubview:_datePicker];
    
    self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 300, WIDTH-100, 100)];
    self.timeLabel.numberOfLines=2;
    _timeLabel.textAlignment=NSTextAlignmentCenter;
    self.timeLabel.text = @"暂无提醒内容";
    _timeLabel.textColor=[UIColor grayColor];
    [self.view addSubview:_timeLabel];
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 400, 100, 40)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.center=CGPointMake(WIDTH/2-70, 450);
    btn.layer.borderWidth=1;
    btn.layer.borderColor=[UIColor colorWithRed:47/255.0 green:115/255.0 blue:250/255.0 alpha:1].CGColor;
    btn.layer.cornerRadius=5;
    btn.layer.masksToBounds=YES;
    [btn setTitleColor:[UIColor colorWithRed:47/255.0 green:115/255.0 blue:250/255.0 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2=[[UIButton alloc]initWithFrame:CGRectMake(200, 500, 100, 40)];
    [btn2 setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    btn2.center=CGPointMake(WIDTH/2+70, 450);
    btn2.layer.borderWidth=1;
    btn2.layer.borderColor=[UIColor redColor].CGColor;
    btn2.layer.cornerRadius=5;
    btn2.layer.masksToBounds=YES;
    [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnClick2) forControlEvents:UIControlEventTouchUpInside];
}

//确定点击事件
- (void)btnClick{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //时区
    [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    NSString *dateTimeString = [dateFormatter stringFromDate:self.datePicker.date];
    self.timeLabel.text = [NSString stringWithFormat:@"下次服药时间:\n%@",dateTimeString];
    
    // 点击确定 设置好时间之后添加本地提醒  用UILocalNotification来实现。
    [self scheduleLocalNotificationWithDate:self.datePicker.date];
    [self remindController:@"闹钟提醒添加成功"];
    
    [self voiceAnnouncementsText:@"闹钟提醒添加成功"];
}

//取消点击事件
- (void)btnClick2{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self remindController:@"闹钟提醒已经取消"];
    
    [self voiceAnnouncementsText:@"闹钟提醒已经取消"];
    
}

//通知
- (void)scheduleLocalNotificationWithDate:(NSDate *)fireDate
{
    //0.创建推送
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //1.设置推送类型
    UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    //2.设置setting
    UIUserNotificationSettings *setting  = [UIUserNotificationSettings settingsForTypes:type categories:nil];
    //3.主动授权
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    //4.设置推送时间
    [localNotification setFireDate:fireDate];
    //5.设置时区
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //6.推送内容
    [localNotification setAlertBody:@"亲,吃药时间到了!"];
    //7.推送声音
    [localNotification setSoundName:@"Thunder Song.m4r"];
    //8.添加推送到UIApplication
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

//提示框
- (void)remindController:(NSString *)remindText
{
    //提示页面（8.0出现）
    /**
     *  1.创建UIAlertController的对象
     2.创建UIAlertController的方法
     3.控制器添加action
     4.用presentViewController模态视图控制器
     */
    UIAlertController *alart = [UIAlertController alertControllerWithTitle:@"提示" message:remindText preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alart animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alart dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

//语音提示
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
