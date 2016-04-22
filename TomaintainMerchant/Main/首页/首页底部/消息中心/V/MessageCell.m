//
//  MessageCell.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/16.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "MessageCell.h"
#import "MessageModel.h"
@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *imageLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 60, 60)];
        imageLabel.backgroundColor = MainPurpleColor;
        imageLabel.text = @"公告";
        imageLabel.textAlignment = NSTextAlignmentCenter;
        imageLabel.textColor = [UIColor whiteColor];
        imageLabel.font = [UIFont systemFontOfSize:25];
        [self addSubview:imageLabel];
        UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageLabel.frame) + 5, 20, 10, 10)];
        redLabel.backgroundColor = [UIColor redColor];
        redLabel.layer.masksToBounds = YES;
        redLabel.layer.cornerRadius=5.0f;
        _redSpot = redLabel;
        _redSpot.hidden = YES;
        [self addSubview:redLabel];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(redLabel.frame) + 5, 10, SCREEN.width - 90 - 10, 25)];
        titleLabel.textColor = CharacterColor1;
        titleLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
        UILabel *detailLabel = [[UILabel alloc ]initWithFrame:CGRectMake(CGRectGetMaxX(imageLabel.frame)+ 5, 45, SCREEN.width - 80 - 10, 25)];
        detailLabel.textColor = CharacterColor2;
        detailLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:detailLabel];
        _detailLabel = detailLabel;
        
        //底部横线
        UILabel *line = [[UILabel alloc ]initWithFrame:CGRectMake(0, 79.5, SCREEN.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        
    }
    return self;
}

- (void) setModel:(MessageModel *)model{

    _model = model;
    if ([_model.status isEqualToString:@"1"]) {
        _redSpot.hidden = NO;
    }
    _titleLabel.text = _model.title;
    _detailLabel.text = _model.content;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
