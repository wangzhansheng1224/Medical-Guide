//
//  UIImage+WZSRenderImage.m
//  YiYao
//
//  Created by wzs on 16/6/17.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "UIImage+WZSRenderImage.h"

@implementation UIImage (WZSRenderImage)
+ (UIImage *)loadImageByName:(NSString *)path{
    UIImage *image = [UIImage imageNamed:path];
//    if ([UIDevice currentDevice].systemVersion.floatValue >=(7)) {
//        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    }
    return image;
}
@end
