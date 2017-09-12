//
//  WZSInstructionTableViewCell.h
//  药品手册
//
//  Created by wzs on 16/6/24.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZSInstructionTableViewCell : UITableViewCell
@property (nonatomic)UILabel *label1;
@property (nonatomic)UILabel *label2;
@property(nonatomic,assign)float cellHeight;

-(void)setContent:(NSString *)content;
@end
