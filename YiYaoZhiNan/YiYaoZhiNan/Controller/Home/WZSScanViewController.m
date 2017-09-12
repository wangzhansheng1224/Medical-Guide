//
//  WZSScanViewController.m
//  相机功能Demo
//
//  Created by wzs on 16/6/29.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSScanViewController.h"

#import <AVFoundation/AVFoundation.h>
//音频的播放或者录制
#import <AudioToolbox/AudioToolbox.h>
//音频的播放或者录制 （振动）
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
@interface WZSScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
//捕获二维码回调的协议
@property (strong,nonatomic)AVCaptureDevice *device;
//获取相机的相关属性 采集的设备
@property (strong,nonatomic)AVCaptureDeviceInput *input;
//设备的输入
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
//输出
@property (strong,nonatomic)AVCaptureSession *session;
//音频、视频采集
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;
//摄像头捕获的原始数据
@property (strong,nonatomic)AVCaptureVideoDataOutput *videoOutput;
//视频输出，为了手电筒自动亮

@property (nonatomic,strong)UIButton *lightBtn;

@end

@implementation WZSScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationController];
    [self prepareScanView];
    [self setUpCamera];
    // Do any additional setup after loading the view.
}

-(void)createNavigationController{
    self.navigationItem.title=@"条码扫描";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(goToBack)];
}

- (void)goToBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.session startRunning];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //界面跳转,扫面关闭
    [self.session stopRunning];
}

- (void)prepareScanView {
    //背景
    UIImageView *readerBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scan5_bg.png"]];
    
    readerBg.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H) ;
    
    readerBg.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:readerBg];
    
    
    //开启相机闪光灯按钮
    _lightBtn = [[UIButton alloc]initWithFrame: CGRectMake(0, 0, 30, 30)];
    
    _lightBtn.backgroundColor = [UIColor clearColor];
    
    _lightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [_lightBtn setBackgroundImage:[UIImage imageNamed:@"saomiao_button_01.png"] forState:UIControlStateNormal];
    
    [_lightBtn setBackgroundImage:[UIImage imageNamed:@"saomiao_button_02.png"] forState:UIControlStateSelected];
    
    [_lightBtn addTarget:self action:@selector(openCameraFlashlight:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_lightBtn];
    
    //如果设置手电筒自动开启，按钮初始状态需要改变
    if ([self.device hasTorch]) {
        if (self.device.torchMode == AVCaptureTorchModeAuto){
            
            //如果手电筒亮度为0，表示关闭
            if (self.device.torchLevel==0) {
                //更改btn的状态
                [_lightBtn setSelected:NO];
//                _lightBtn.selected=NO;
                
            }
            else{
//                _lightBtn.selected=YES;
                [_lightBtn setSelected:YES];
            }
            
        }
    }
    
    [self.view addSubview:_lightBtn];
    
    
    //扫描线
    UIImageView *scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 190, SCREEN_W, 29)];
    
    scanLine.image = [UIImage imageNamed:@"scan_line"];
    
    scanLine.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:scanLine];
    
    CABasicAnimation *theAnimation;
    theAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    //动画的路径 y轴
    
    theAnimation.duration = 2.0f;
    //动画持续的时间
    
    theAnimation.repeatCount=FLT_MAX;
    //重复的次数
    
    theAnimation.autoreverses = NO;
    //结束一次是否原路返回执行动画
    
    
    theAnimation.removedOnCompletion = NO;
    //动画结束是否移除
    
    
    CGRect rect = scanLine.frame;
    rect.origin.y += 35;
    scanLine.frame = rect;
    
    theAnimation.toValue=[NSNumber numberWithFloat:210];
    //toValue结束值 byValue开始值
    
    [scanLine.layer addAnimation:theAnimation forKey:@"animateLayer"];
}

#pragma mark -- 开启/关闭 手电筒
- (void)openCameraFlashlight:(id)sender{
    
    
    if (![self.device hasTorch]) {
        return;
    }
    
    if (self.device.torchMode == AVCaptureTorchModeOff) {
        
        [self.device lockForConfiguration:nil];
        self.device.torchMode = AVCaptureTorchModeOn;//开启
        [self.device unlockForConfiguration];
        [_lightBtn setSelected:YES];
        
    }
    else if (self.device.torchMode == AVCaptureTorchModeOn) {
        
        [self.device lockForConfiguration:nil];
        self.device.torchMode = AVCaptureTorchModeOff;//关闭
        [self.device unlockForConfiguration];
        [_lightBtn setSelected:NO];
        
    }
    else if (self.device.torchMode == AVCaptureTorchModeAuto){
        
        //如果手电筒亮度为0，表示关闭
        if (self.device.torchLevel==0) {
            
            [self.device lockForConfiguration:nil];
            self.device.torchMode = AVCaptureTorchModeOn;//开启
            [self.device unlockForConfiguration];
            [_lightBtn setSelected:YES];
        }
        else{
            
            [self.device lockForConfiguration:nil];
            self.device.torchMode = AVCaptureTorchModeOff;//关闭
            [self.device unlockForConfiguration];
            [_lightBtn setSelected:NO];
        }
        
    }
    
}

- (void)setUpCamera{
    
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        NSLog(@"相机权限受限");
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"未获得授权使用摄像头" message:@"请在iOS\"设置\"-\"隐私\"-\"相机\"中打开" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action=[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return;
        
    }
    
    // 实例化设备
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
//    [self.device lockForConfiguration:nil];
//
//    if ([self.device hasTorch]) {
//        
//        if ([self.device isTorchModeSupported:AVCaptureTorchModeAuto]) {
//            
//            self.device.torchMode  = AVCaptureTorchModeAuto;
//            
//        }
//        else{
//            
//            self.device.torchMode  = AVCaptureTorchModeOff;
//        }
//        
//    }else{
//
//    }
////
//    [self.device unlockForConfiguration];
    
    //Session
    _session = [[AVCaptureSession alloc]init];
    
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 设备输入
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    if ([self.session canAddInput:self.input])
    {
        
        [self.session addInput:self.input];
        
    }
    
    
    // 设备输出
    _output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    if ([self.session canAddOutput:self.output]){
        
        [self.session addOutput:self.output];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
     _output.metadataObjectTypes =@[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode];
    
    
    //视频输出
    _videoOutput  = [[AVCaptureVideoDataOutput alloc]init] ;
    
    if ([self.session canAddOutput:_videoOutput]){
        
        [self.session addOutput:_videoOutput];
        
    }
    
    
    
    
    
//    @try {
//        
//        // 条码类型 AVMetadataObjectTypeQRCode
//        self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
//        
//    }
//    @catch (NSException *exception) {
//        
//        
//        NSArray * titlesArr = @[@"取消"];
//        
//        ELNAlertView * alertView = [[ELNAlertView alloc]initWithTitle:@"提示" message:@"请在设备的 设置-隐私-相机 中允许访问相机。" delegate:self cancelButtonTitle:@"设置" otherButtonTitles:titlesArr];
//        
//        [self.view addSubview:alertView];
//        
//    }
    
    
    //Preview
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.preview.frame = CGRectMake(0,0,SCREEN_W,SCREEN_H);
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    //开始扫描
    [self.session startRunning];
    
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //得到解析到的结果
    NSString *stringValue;
    
    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
//        [self playScanSound];
        //停止扫描
        [_session stopRunning];
        
        if ([stringValue hasPrefix:@"http"]) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"可能存在风险,是否打开此链接:\n%@",stringValue] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringValue]];
                [self.session startRunning];
            }];
            [alert addAction:action];
            UIAlertAction *action2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.session startRunning];
            }];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"已识别内容为:%@",stringValue] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [self.session startRunning];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
           
        }

    }
    
    
}

- (void)playScanSound{
    
    //系统音频ID，用来注册我们将要播放的声音
    SystemSoundID scanSoundID;
    //音乐文件路径
    CFURLRef thesoundURL = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"caf"]];
    //变量SoundID与URL对应
    AudioServicesCreateSystemSoundID(thesoundURL, &scanSoundID);
    //播放SoundID声音
    AudioServicesPlaySystemSound(scanSoundID);
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
