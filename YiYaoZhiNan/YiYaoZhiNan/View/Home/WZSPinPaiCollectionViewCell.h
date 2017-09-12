//
//  WZSPinPaiCollectionViewCell.h
//  药品手册
//
//  Created by wzs on 16/6/20.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSPinPaiCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *down;
@property (weak, nonatomic) IBOutlet UILabel *right;

@end
