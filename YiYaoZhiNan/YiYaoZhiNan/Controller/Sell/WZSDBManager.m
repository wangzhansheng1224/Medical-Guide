//
//  WZSDBManager.m
//  药品手册
//
//  Created by wzs on 16/6/27.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSDBManager.h"
@implementation WZSDBManager
+ (WZSDBManager *)shareManager{
    static WZSDBManager * manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (!manager) {
            manager=[[WZSDBManager alloc]init];
            //创建数据库
            NSString * dbpath=[NSString stringWithFormat:@"%@/Documents/dataBase.sqlite",NSHomeDirectory()];
//            NSLog(@"%@",dbpath);
            //创建并打开数据库文件,文件不存在时才创建,否则直接打开
            manager.dataBase=[[FMDatabase alloc]initWithPath:dbpath];
        }
    });
    if(manager.dataBase.open==NO){
        //打开数据库
        [manager.dataBase open];
    }
    return manager;
}

+ (void)closeDB{
    WZSDBManager *manager=[self shareManager];
    if (manager.dataBase.open) {
        [manager.dataBase close];
    }
}

@end
