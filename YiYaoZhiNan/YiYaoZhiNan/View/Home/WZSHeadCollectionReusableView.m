//
//  WZSHeadCollectionReusableView.m
//  药品手册
//
//  Created by wzs on 16/6/20.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSHeadCollectionReusableView.h"

@implementation WZSHeadCollectionReusableView
{
    void (^_callbackblock)();
    UIImageView *_imageV;
    UIImageView *imageView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _labeltitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 70, 30)];
        _labeltitle.textAlignment=NSTextAlignmentCenter;
        _labeltitle.font=[UIFont systemFontOfSize:15];
        [self addSubview:_labeltitle];
        
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-20, 10, 10, 10)];
        _imageV.image = [UIImage imageNamed:@"homepage_area_more.png"];
        _imageV.userInteractionEnabled=YES;
        [self addSubview:_imageV];
        
        //添加灰线
        UILabel *labeltitle2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 29, WIDTH, 1)];
        labeltitle2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [self addSubview:labeltitle2];
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
- (void)addTap:(id)target SEL:(SEL)sel{
    //添加手势进行跳转
    self.sel=sel;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:self.sel];
    [self addGestureRecognizer:tap];
}

@end
