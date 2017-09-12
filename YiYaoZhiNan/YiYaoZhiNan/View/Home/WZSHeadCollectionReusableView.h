//
//  WZSHeadCollectionReusableView.h
//  药品手册
//
//  Created by wzs on 16/6/20.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSHeadCollectionReusableView : UICollectionReusableView
@property (nonatomic,strong)UILabel *labeltitle;
@property (nonatomic) SEL sel;
-(void)addTap:(id)target123 SEL:(SEL)fangfa;

@end
