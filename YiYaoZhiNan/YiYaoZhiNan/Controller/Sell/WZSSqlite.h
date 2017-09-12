//
//  WZSSqlite.h
//  药品手册
//
//  Created by wzs on 16/6/27.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZSDBManager.h"
@interface WZSSqlite : NSObject
+ (void)createFavoriteTable;
//增
+ (void)favoriteApps:(NSArray *)appArray;
//是否已经收藏(查找)
+ (BOOL)isFavorted:(NSString *)appId;
//取消收藏(删除)
+ (void)removeApp:(NSString *)appId;
//查
+ (NSMutableArray *)selectData;
@end
