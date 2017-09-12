//
//  WZSBannerReusableView.m
//  药品手册
//
//  Created by wzs on 16/6/20.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSBannerReusableView.h"


@interface WZSBannerReusableView ()
{
    void(^_saomaBlock)();
    void(^_zixunBlock)();
    void(^_tixingBlock)();
    void(^_duizhengBlock)();
}
@property (nonatomic,strong)UIView *view1;


@end
@implementation WZSBannerReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [self createUI];
        self.userInteractionEnabled=YES;
    }
    return self;
}

- (void)createUI{
    _scrollView=[[XTADScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH/2)];
    _scrollView.infiniteLoop=YES;
    _scrollView.pageControlPositionType=pageControlPositionTypeRight;
    _scrollView.needPageControl=YES;
    [self addSubview:_scrollView];
    [self createBtn];
    [self createBtn2];
    [self createBtn3];
}
-(void)createBtn{
    NSArray *titleArr=@[@"扫码找药",@"咨询医生",@"服药提醒",@"对症找药"];
    NSArray *imageArr=@[@"homepage_menu_scan",@"homepage_menu_askdoctor",@"homepage_menu_remind",@"homepage_menu_finddrug"];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, WIDTH/2, WIDTH, WIDTH/4-5)];
    [self addSubview:view1];
    view1.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i<4; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20+i*WIDTH/4, WIDTH/2+5, WIDTH/4-40, WIDTH/4-40)];
        [btn setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10+i*WIDTH/4, (WIDTH/4-40)+WIDTH/2+5, WIDTH/4-20, 30)];
//        label.backgroundColor=[UIColor redColor];
        label.text=titleArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
    }

}

- (void)btnClick:(UIButton *)btn{
    if (btn.tag==100) {
        _saomaBlock();
    }else if (btn.tag==101){
        _zixunBlock();
    }else if (btn.tag==102){
        _tixingBlock();
    }else if (btn.tag==103){
        _duizhengBlock();
    }
}


-(void)sendBlock:(void (^)())block{
    _saomaBlock=block;
}

- (void)sendBlock2:(void (^)())block{
    _zixunBlock=block;
}

- (void)sendBlock3:(void (^)())block{
    _tixingBlock=block;
}

- (void)sendBlock4:(void (^)())block{
    _duizhengBlock=block;
}
- (void)createBtn2{
    _leftimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, WIDTH/4+WIDTH/2, WIDTH/2-1, 95)];
    _leftimage.userInteractionEnabled=YES;
    _leftimage.backgroundColor = [UIColor whiteColor];
    [self addSubview:_leftimage];
    _rightimage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2, WIDTH/4+WIDTH/2, WIDTH/2, 95)];
    _rightimage.userInteractionEnabled=YES;
    _rightimage.backgroundColor = [UIColor whiteColor];
    [self addSubview:_rightimage];
    
}

-(void)sendtap1target:(id)target sel:(SEL)sel{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:target action:sel];
    [_leftimage addGestureRecognizer:tap];
}

-(void)sendtap2target:(id)target sel:(SEL)sel{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:target action:sel];
    [_rightimage addGestureRecognizer:tap];
}

- (void)createBtn3{
    _view1 = [[UIView alloc]initWithFrame:CGRectMake(0, WIDTH/2+WIDTH/4+100, WIDTH, 29)];
    _view1.backgroundColor = [UIColor whiteColor];
    [self addSubview:_view1];
    
    UILabel *labeltitle = [[UILabel alloc]initWithFrame:CGRectMake(5, WIDTH/2+WIDTH/4+100, 70, 30)];
    labeltitle.text=@"感冒用药";
    labeltitle.font = [UIFont systemFontOfSize:15];
    [self addSubview:labeltitle];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-20, WIDTH/2+WIDTH/4+100+10, 10, 10)];
    imageV.image = [UIImage imageNamed:@"homepage_area_more.png"];
    [self addSubview:imageV];
}

-(void)sendtap3target:(id)target sel:(SEL)sel{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:target action:sel];
    [_view1 addGestureRecognizer:tap];
}



@end
