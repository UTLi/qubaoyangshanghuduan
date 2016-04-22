//
//  CommentCell.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/16.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"
#define GAP 10
#define Font [UIFont systemFontOfSize:18]

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        UILabel *imageLabel = [[UILabel alloc]initWithFrame:CGRectMake(GAP, GAP, 60, 60)];
//        imageLabel.backgroundColor = MainPurpleColor;
//        imageLabel.text = @"头像";
//        imageLabel.layer.masksToBounds = YES;
//        imageLabel.layer.cornerRadius=30.0f;
//        imageLabel.textAlignment = NSTextAlignmentCenter;
//        imageLabel.textColor = [UIColor whiteColor];
//        imageLabel.font = [UIFont systemFontOfSize:25];
//        [self addSubview:imageLabel];
//        
        UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(GAP, GAP, 60, 60)];
        [iconImage setImage:[UIImage imageNamed:@"user_icon"]];
        [self addSubview:iconImage];
                              

        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImage.frame) + GAP, GAP, (SCREEN.width - 3 * GAP - 60) / 27 * 12  , (80 - 3 * GAP)/2)];
        nameLabel.textColor = CharacterColor1;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:nameLabel];
        _nameLabel = nameLabel;
        
        UILabel *dateLabel = [[UILabel alloc ]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), GAP,(SCREEN.width - 3 * GAP - 60) / 27 * 15, (80 - 3 * GAP)/2)];
        dateLabel.textColor = CharacterColor2;
        dateLabel.textAlignment = NSTextAlignmentRight;
        dateLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:dateLabel];
        _dateLabel = dateLabel;

        UILabel *commentLabel = [[UILabel alloc]init];
        //设置自动行数与字符换行
        [commentLabel setNumberOfLines:0];
        commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        commentLabel.textColor = CharacterColor2;
        commentLabel.font = Font;
        [self addSubview:commentLabel];
        _commentLabel = commentLabel;
        
        //底部横线
        UILabel *line = [[UILabel alloc ]initWithFrame:CGRectMake(0, CGRectGetMaxY(commentLabel.frame), SCREEN.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
   
        
        
    }
    return self;
}

- (void)setModel:(CommentModel *)model{

    _model = model;
//    _nameLabel.text = _model.userName;
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@",model.userName];
    [str replaceCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    _nameLabel.text = str;

    NSString *date = _model.date;
    NSString *date2 = [date substringToIndex:16];
    _dateLabel.text = date2;
    _commentLabel.text = _model.content;
    //计算尺寸
    NSString *s = _model.content;
    //设置一个行高上限
    CGSize size = CGSizeMake(SCREEN.width - 3 * GAP - 60,MAXFLOAT);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [self sizeWithText:s font:Font maxSize:size];
    [_commentLabel setFrame:CGRectMake(80, 45, labelsize.width, labelsize.height)];
    _commentLabel.text = _model.content;


}


//算尺寸方法
- (CGSize)sizeWithText:(NSString*)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return  [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
