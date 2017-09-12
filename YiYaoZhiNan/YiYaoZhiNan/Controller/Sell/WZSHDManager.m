//
//  WZSHDManager.m
//  药品手册
//
//  Created by wzs on 16/6/27.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSHDManager.h"


@implementation WZSHDManager
+ (MBProgressHUD *)shareHDView{
    static MBProgressHUD * hdView=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!hdView) {
            //获取程序的主窗口
            UIWindow * window=[UIApplication sharedApplication].keyWindow;
            hdView=[[MBProgressHUD alloc]initWithWindow:window];
//            hdView.labelText=@"加载中...";
        }
    });
    return hdView;
}
//开始加载
+ (void)startLoadingString:(NSString *)str MBProgressHUDMode:(MBProgressHUDMode)type minShowTime:(float)time{
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    MBProgressHUD * hd=[self shareHDView];
    hd.labelText=str;
    hd.minShowTime=time;
    hd.mode=type;
    [window addSubview:hd];
    [hd show:YES];
    
   
}
//结束加载
+ (void)stopLoading{
    MBProgressHUD * hd=[self shareHDView];
    [hd hide:YES];
}

@end
