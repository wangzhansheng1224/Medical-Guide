//
//  WZSDetailModel.h
//  药品手册
//
//  Created by wzs on 16/6/22.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZSDetailModel : NSObject
PROPERTY(namecn);
PROPERTY(titleimg);
PROPERTY(refdrugcompanyname);
PROPERTY(_id);
PROPERTY(gongneng);
@property (nonatomic,assign)NSInteger newotc;
@property (nonatomic,assign)NSInteger medcare;
@property (nonatomic,assign)BOOL basemed;
@property (nonatomic,assign)float avgprice;
@end
