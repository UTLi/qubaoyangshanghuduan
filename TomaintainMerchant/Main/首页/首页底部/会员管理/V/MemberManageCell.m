//
//  MemberManageCell.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/17.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "MemberManageCell.h"
#import "MemberManageModel.h"
#define GAP 10
#define Font [UIFont systemFontOfSize:18]
@implementation MemberManageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(2 *GAP, GAP, 40, 40)];
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius=20.0f;
        [self.contentView addSubview:image];
        _image = image;

        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + GAP, GAP,SCREEN.width - 3 * GAP,(60 - 3 * GAP) / 2 )];
        nameLabel.textColor = CharacterColor1;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:nameLabel];
        _nameLabel = nameLabel;
        
        UILabel *mobileLabel = [[UILabel alloc ]initWithFrame:CGRectMake( CGRectGetMaxX(image.frame) + GAP, 35,SCREEN.width - 3 * GAP, (60 - 3 * GAP) / 2)];
        mobileLabel.textColor = CharacterColor2;
        mobileLabel.textAlignment = NSTextAlignmentLeft;
        mobileLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:mobileLabel];
        _mobileLabel = mobileLabel;
        
        //底部横线
        UILabel *line = [[UILabel alloc ]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + GAP, 59.5, SCREEN.width - 2 * GAP - 40, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:line];
        
        
    }
    return self;
}

- (void)setModel:(MemberManageModel *)model{
    
    _model = model;
    [_image sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"车"]];
    _nameLabel.text = _model.userName;
    _mobileLabel.text = _model.autoBrand;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
