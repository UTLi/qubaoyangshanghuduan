//
//  OrderCell.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/15.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width/3, self.frame.size.height)];
        leftLabel.textColor = CharacterColor1;
        leftLabel.font = [UIFont systemFontOfSize:20];
        leftLabel.textAlignment = NSTextAlignmentRight;
        leftLabel.lineBreakMode = NSLineBreakByCharWrapping;
        leftLabel.numberOfLines = 0;
        _leftLabel = leftLabel;
        [self addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake( SCREEN.width/3, 0, SCREEN.width/3*2, self.frame.size.height)];
        rightLabel.textColor = CharacterColor2;
        rightLabel.font = [UIFont systemFontOfSize:16];
        rightLabel.textAlignment = NSTextAlignmentLeft;
        rightLabel.lineBreakMode = NSLineBreakByCharWrapping;
        rightLabel.numberOfLines = 0;
        _rightLabel = rightLabel;
        [self addSubview:rightLabel];

        
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
