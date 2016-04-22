//
//  OneLabelCell.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/22.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "OneLabelCell.h"
#import "ClassifyProductModel.h"
@implementation OneLabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, self.frame.size.width - 20, 30)];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        label.highlightedTextColor = MainPurpleColor;
        _label = label;
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellBackView"]];
        self.backgroundColor = RGColor(239, 240, 241);
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 59.5, self.frame.size.width, 0.5)];
        line.backgroundColor = RGColor(229, 230, 230);
        [self addSubview:line];
    }
    return self;
}

- (void)setModel:(ClassifyProductModel *)model{
    _model = model;
    _label.text = _model.name;
 
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
