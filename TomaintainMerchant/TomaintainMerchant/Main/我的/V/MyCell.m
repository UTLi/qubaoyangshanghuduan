//
//  MyCell.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/27.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *image= [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 18, 24)];
        [self.contentView addSubview:image];
        self.image = image;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+ 10, 10, 100, 24)];
        label.textColor = CharacterColor1;
        label.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:label];
        self.label = label;
        
        UILabel  *borderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(image.frame)- 0.5 + 10 , SCREEN.width, 0.5)];
        borderLabel.backgroundColor = RGColor(244, 245, 245);
        [self.contentView addSubview:borderLabel];
    }
    return self;

}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
