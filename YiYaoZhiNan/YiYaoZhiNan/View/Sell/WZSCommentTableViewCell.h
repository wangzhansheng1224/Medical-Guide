//
//  WZSCommentTableViewCell.h
//  药品手册
//
//  Created by wzs on 16/6/25.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSCommentTableViewCell : UITableViewCell
@property (nonatomic)UILabel *label1;
@property (nonatomic)UILabel *goodcount;
@property(nonatomic,assign)float cellHeight;

-(void)setContent:(NSString *)content;
@end
