//
//  WZSMapModel.h
//  药品手册
//
//  Created by wzs on 16/7/5.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface WZSMapModel : NSObject
// 基础信息
@property (nonatomic, copy)   NSString     *uid; //!< POI全局唯一ID
@property (nonatomic, copy)   NSString     *name; //!< 名称
@property (nonatomic, copy)   NSString     *type; //!< 兴趣点类型
@property (nonatomic, copy)   AMapGeoPoint *location; //!< 经纬度
@property (nonatomic, copy)   NSString     *address;  //!< 地址
@property (nonatomic, copy)   NSString     *tel;  //!< 电话
@property (nonatomic, assign) NSInteger     distance; //!< 距中心点距离，仅在周边搜索时有效
@end
