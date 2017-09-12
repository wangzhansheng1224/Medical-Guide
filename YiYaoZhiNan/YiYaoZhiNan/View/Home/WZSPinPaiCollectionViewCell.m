//
//  WZSPinPaiCollectionViewCell.m
//  药品手册
//
//  Created by wzs on 16/6/20.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSPinPaiCollectionViewCell.h"

@implementation WZSPinPaiCollectionViewCell

- (void)awakeFromNib {
    self.imageV.frame = CGRectMake(10, 10, WIDTH/3-20,0.9*(WIDTH/3-20) );
    self.name.frame = CGRectMake(0, 0.9*(WIDTH/3-20)+10, WIDTH/3-1, 20);
    self.down.frame = CGRectMake(0, WIDTH/3-1, WIDTH/3, 1);
    self.right.frame = CGRectMake(WIDTH/3-1, 0, 1, WIDTH/3);
    // Initialization code
}

@end
