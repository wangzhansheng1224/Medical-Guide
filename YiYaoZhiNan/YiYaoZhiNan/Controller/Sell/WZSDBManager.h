//
//  WZSDBManager.h
//  药品手册
//
//  Created by wzs on 16/6/27.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface WZSDBManager : NSObject
@property(nonatomic,strong)FMDatabase * dataBase;

+ (WZSDBManager *)shareManager;
//关闭数据库
+ (void)closeDB;
@end
