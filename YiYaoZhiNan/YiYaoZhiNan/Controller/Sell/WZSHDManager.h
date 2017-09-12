//
//  WZSHDManager.h
//  药品手册
//
//  Created by wzs on 16/6/27.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface WZSHDManager : NSObject
+ (void)startLoadingString:(NSString *)str MBProgressHUDMode:(MBProgressHUDMode)type minShowTime:(float)time;

//数据加载完毕,让加载指示器隐藏
+ (void)stopLoading;
@end
