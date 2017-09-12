//
//  WZSClassifyCollectionViewCell.h
//  药品手册
//
//  Created by wzs on 16/6/21.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSClassifyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *down;
@property (weak, nonatomic) IBOutlet UILabel *right;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
