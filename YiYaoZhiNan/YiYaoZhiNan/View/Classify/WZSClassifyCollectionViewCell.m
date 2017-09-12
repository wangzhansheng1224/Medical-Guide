//
//  WZSClassifyCollectionViewCell.m
//  药品手册
//
//  Created by wzs on 16/6/21.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSClassifyCollectionViewCell.h"

@implementation WZSClassifyCollectionViewCell

- (void)awakeFromNib {
    self.down.frame = CGRectMake(0, WIDTH/3-1, WIDTH/3, 1);
    self.right.frame = CGRectMake(WIDTH/3-1, 0, 1, WIDTH/3);
    self.imageV.frame = CGRectMake(WIDTH/9, WIDTH/9-10, WIDTH/9, WIDTH/9);
    self.name.frame = CGRectMake(20, 2*WIDTH/9-10, WIDTH/3-40, 20);
    // Initialization code
}

@end
