//
//  WZSSqlite.m
//  药品手册
//
//  Created by wzs on 16/6/27.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSSqlite.h"
#import "WZSDrugInstructionModel.h"

@implementation WZSSqlite

+ (void)createFavoriteTable{
    WZSDBManager * manager=[WZSDBManager shareManager];
    NSString * sql=@"create table if not exists FAVORITE(_id text primary key,namecn text,refdrugcompanyname text,gongneng text,titleimg text,avgprice text)";
    BOOL result=[manager.dataBase executeUpdate:sql];
    if (result) {
        NSLog(@"创建收藏表成功");
    }else{
        NSLog(@"创建收藏表失败");
    }

}

+ (void)favoriteApps:(NSArray *)appArray{
    //如果表不存在,先建表
    [self createFavoriteTable];
    
    WZSDBManager * manager=[WZSDBManager shareManager];
    NSString * sql=@"insert into FAVORITE(_id,namecn,refdrugcompanyname,gongneng,titleimg,avgprice) values(?,?,?,?,?,?)";
  
    WZSDrugInstructionModel *model=appArray[0];
    
    
    BOOL result=[manager.dataBase executeUpdate:sql,[NSString stringWithFormat:@"%ld",model._id],model.namecn,model.refdrugcompanyname,model.gongneng,model.titleimg,[NSString stringWithFormat:@"%0.f",model.avgprice]];
    if (result) {
        NSLog(@"收藏成功");
    }else{
        NSLog(@"收藏失败");
    }
}

//是否存在
+ (BOOL)isFavorted:(NSString *)appId{
    WZSDBManager * manager=[WZSDBManager shareManager];
    NSString * sql=@"select * from FAVORITE where _id =?";
    FMResultSet * appSet=[manager.dataBase executeQuery:sql,appId];
    while ([appSet next]) {
        return YES;
    }
    return NO;
}

//移除收藏
+ (void)removeApp:(NSString *)appId{
    WZSDBManager * manager=[WZSDBManager shareManager];
    NSString * sql=@"delete from FAVORITE where _id = ?";
    BOOL result=[manager.dataBase executeUpdate:sql,appId];
    if (result) {
        NSLog(@"取消收藏成功");
    }else{
        NSLog(@"取消收藏失败");
    }
}

+ (NSMutableArray *)selectData{
    NSMutableArray *dataArr=[[NSMutableArray alloc]init];
    WZSDBManager * manager=[WZSDBManager shareManager];
    //    1.SQL语句
    NSString *sql = @"select * from FAVORITE";
    
    //    2.查询
    FMResultSet *resultSet = [manager.dataBase executeQuery:sql];
    
    //    resultSet 指向查询返回的数据结合的开始位置 包含了查到的所有数据
    
    //    3.遍历所有数据
    
    while ([resultSet next]) {
        NSString *namecn=[resultSet stringForColumn:@"namecn"];
        NSString *refdrugcompanyname=[resultSet stringForColumn:@"refdrugcompanyname"];
        NSString *gongneng=[resultSet stringForColumn:@"gongneng"];
        NSString *myid=[resultSet stringForColumn:@"_id"];
        NSString *titleimg=[resultSet stringForColumn:@"titleimg"];
        NSString *avgprice=[resultSet stringForColumn:@"avgprice"];
        WZSDrugInstructionModel *model=[[WZSDrugInstructionModel alloc]init];
        model._id=[myid integerValue];
        model.namecn=namecn;
        model.refdrugcompanyname=refdrugcompanyname;
        model.gongneng=gongneng;
        model.titleimg=titleimg;
        model.avgprice=[avgprice floatValue];
        [dataArr addObject:model];
    }
    return dataArr;
    
}



@end
