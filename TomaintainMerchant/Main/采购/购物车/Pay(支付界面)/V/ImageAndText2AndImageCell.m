//
//  ImageAndText2AndImageCell.m
//  Tomaintain
//
//  Created by iOS on 15/8/5.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import "ImageAndText2AndImageCell.h"

@implementation ImageAndText2AndImageCell

- (void)awakeFromNib {
    // Initialization code
    self.selectImageView.userInteractionEnabled=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
