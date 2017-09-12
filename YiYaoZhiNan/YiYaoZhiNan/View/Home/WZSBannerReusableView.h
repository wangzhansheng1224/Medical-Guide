//
//  WZSBannerReusableView.h
//  药品手册
//
//  Created by wzs on 16/6/20.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTADScrollView.h"
@interface WZSBannerReusableView : UICollectionReusableView
@property (nonatomic,strong)XTADScrollView *scrollView;
@property (nonatomic,strong)UIImageView *leftimage;
@property (nonatomic,strong)UIImageView *rightimage;

- (void)sendBlock:(void(^)())block;
- (void)sendBlock2:(void (^)())block;
- (void)sendBlock3:(void (^)())block;
- (void)sendBlock4:(void (^)())block;
- (void)sendtap1target:(id)target sel:(SEL)sel;
- (void)sendtap2target:(id)target sel:(SEL)sel;
- (void)sendtap3target:(id)target sel:(SEL)sel;
@end
