//
//  SetingCell.m
//  Tomaintain
//
//  Created by iOS on 15/8/6.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import "SetingCell.h"

@implementation SetingCell

- (void)awakeFromNib {
    self.selectionStyle= UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
