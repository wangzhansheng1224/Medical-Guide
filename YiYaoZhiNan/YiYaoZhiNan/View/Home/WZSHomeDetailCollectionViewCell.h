//
//  WZSHomeDetailCollectionViewCell.h
//  药品手册
//
//  Created by wzs on 16/6/19.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSHomeDetailCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *down;
@property (weak, nonatomic) IBOutlet UIImageView *otc;
@property (weak, nonatomic) IBOutlet UILabel *right;
@property (weak, nonatomic) IBOutlet UIImageView *bao;
@property (weak, nonatomic) IBOutlet UIImageView *ji;
- (void)fuyuan;
- (void)changtubiaoOTC:(NSString *)OtcNum MedCare:baoNum BaseMed:(NSString *)jiNum;
@end
