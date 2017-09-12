//
//  WZSDrugListModel.m
//  药品手册
//
//  Created by wzs on 16/6/19.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSDrugListModel.h"

@implementation WZSDrugListModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.myid=value;
    }
}
//- (NSString *)description{
//    return [NSString stringWithFormat:@"%@",self.NameCN];
//}
@end
