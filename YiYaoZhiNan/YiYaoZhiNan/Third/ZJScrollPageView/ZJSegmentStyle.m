//
//  ZJSegmentStyle.m
//  ZJScrollPageView
//
//  Created by jasnig on 16/5/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJSegmentStyle.h"

@implementation ZJSegmentStyle

- (instancetype)init {
    if(self = [super init]) {
        self.showCover = NO;
        self.showLine = NO;
        self.scaleTitle = NO;
        self.scrollTitle = YES;
        self.segmentViewBounces = YES;
        self.gradualChangeTitleColor = NO;
        self.showExtraButton = NO;
        self.scrollContentView = YES;
        self.adjustCoverOrLineWidth = NO;
        self.extraBtnBackgroundImageName = nil;
        self.scrollLineHeight = 2.0;
        self.scrollLineColor = [UIColor blueColor];
        self.coverBackgroundColor = [UIColor lightGrayColor];
        self.coverCornerRadius = 15.0;
        self.coverHeight = 28.0;
        self.titleMargin = 20.0;
        self.titleFont = [UIFont systemFontOfSize:16.0];
        self.titleBigScale = 1.3;
        self.normalTitleColor = [UIColor grayColor];
        
        self.selectedTitleColor = [UIColor grayColor];
        
        self.segmentHeight = 40.0;

    }
    return self;
}


@end
