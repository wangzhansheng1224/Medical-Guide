//
//  WZSCommentTableViewCell.m
//  药品手册
//
//  Created by wzs on 16/6/25.
//  Copyright © 2016年 WZS. All rights reserved.
//

#import "WZSCommentTableViewCell.h"

@interface WZSCommentTableViewCell ()
@property (nonatomic)UILabel *label2;
@end

@implementation WZSCommentTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    _label1=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, WIDTH, 15)];
    _label1.textColor=[UIColor colorWithRed:47/255.0 green:115/255.0 blue:250/255.0 alpha:1];
    _label1.font=[UIFont systemFontOfSize:14];
    [self addSubview:_label1];
    
    UIImageView *imagev=[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-30, 8, 15, 15)];
    imagev.image=[UIImage imageNamed:@"details_praise_normal"];
    [self addSubview:imagev];
    
    _goodcount=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH-100, 10, 65, 15)];
    _goodcount.font=[UIFont systemFontOfSize:14];
    _goodcount.textColor=[UIColor colorWithRed:47/255.0 green:115/255.0 blue:250/255.0 alpha:1];
    _goodcount.textAlignment=NSTextAlignmentRight;
    [self.contentView addSubview:_goodcount];
    
    _label2=[[UILabel alloc]init];
    _label2.font=[UIFont systemFontOfSize:13];
    _label2.textColor=[UIColor grayColor];
    [self addSubview:_label2];
}

-(void)setContent:(NSString *)content
{
    //将传入的数据 放大label
    _label2.text =content;
    _label2.numberOfLines = 0;
    _label2.lineBreakMode = NSLineBreakByWordWrapping;
    [_label2 sizeToFit];
    
    //高度 根据字符串的长度 进行设置
    //第一个参数 设置宽度一定 长度999
    //content 写到一个 宽度为一定的（self.frame.size.width）长度不确定高度的 label上面 并且 这个字符串字体大小是 15号字
    //返回值 就是 按上面 设置 写出来的 label的矩形大小
    CGRect rect = [content boundingRectWithSize:CGSizeMake(self.frame.size.width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    _label2.frame = CGRectMake(15, 30, WIDTH-40, rect.size.height);
    //    _label2.backgroundColor=[UIColor redColor];
    
    self.cellHeight = rect.size.height+35;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
