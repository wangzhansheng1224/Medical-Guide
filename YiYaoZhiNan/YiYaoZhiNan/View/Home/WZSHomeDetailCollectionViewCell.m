//
//  WZSHomeDetailCollectionViewCell.m
//  药品手册
//
//  Created by wzs on 16/6/19.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSHomeDetailCollectionViewCell.h"

@implementation WZSHomeDetailCollectionViewCell

- (void)awakeFromNib {
    
    self.imageV.frame = CGRectMake(10, 10, WIDTH/2-20, 0.75*(WIDTH/2-20));
    self.name.frame = CGRectMake(0, 0.75*WIDTH/2-5, WIDTH/2, 0.125*WIDTH/2);
    self.price.frame = CGRectMake(10, 0.875*WIDTH/2-5, 100, 0.125*WIDTH/2);
    
    self.ji.frame=CGRectMake(WIDTH/2-30, 0.875*WIDTH/2, 16, 16);
    self.bao.frame=CGRectMake(WIDTH/2-50,0.875*WIDTH/2, 16, 16);
    self.otc.frame=CGRectMake(WIDTH/2-75,0.875*WIDTH/2, 20, 16);
    
    self.down.frame = CGRectMake(0, WIDTH/2-1, WIDTH/2, 1);
    self.right.frame  = CGRectMake(WIDTH/2-1, 0, 1, WIDTH/2);

}

- (void)fuyuan{
    self.ji.frame=CGRectMake(WIDTH/2-30, 0.875*WIDTH/2, 16, 16);
    self.ji.image=[UIImage new];
    
    self.bao.frame=CGRectMake(WIDTH/2-50,0.875*WIDTH/2, 16, 16);
    self.bao.image=[UIImage new];
    
    self.otc.frame=CGRectMake(WIDTH/2-75,0.875*WIDTH/2, 20, 16);
    self.otc.image=[UIImage new];
}

- (void)changtubiaoOTC:(NSString *)OtcNum MedCare:baoNum BaseMed:(NSString *)jiNum{
    if ([jiNum isEqualToString:@"1"]) {
        self.ji.image=[UIImage imageNamed:@"drug_base"];
    }else{
        
        self.bao.center=CGPointMake(self.bao.center.x+20, self.bao.center.y);
        self.otc.center=CGPointMake(self.otc.center.x+20, self.otc.center.y);
    }
    if ([baoNum isEqualToString:@"1"]) {
        self.bao.image=[UIImage imageNamed:@"drug_medical_insurance"];
    }else{
        self.otc.center=CGPointMake(self.otc.center.x+20, self.otc.center.y);
    }
    if ([OtcNum isEqualToString:@"1"]) {
        self.otc.image=[UIImage imageNamed:@"drug_otc_a"];
    }else if ([OtcNum isEqualToString:@"2"]){
        self.otc.image=[UIImage imageNamed:@"drug_otc_b"];
    }else{
        self.otc.image=[UIImage imageNamed:@"drug_rx"];
    }
}

@end
