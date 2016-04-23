//
//  OrderConAdressCell.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/7.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "OrderConAdressCell.h"
#import "AddressModel.h"

#define GAP 10

@implementation OrderConAdressCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = RGColor(254, 246, 245);
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(GAP, GAP, 50, 20)];
        nameLabel.textColor = CharacterColor1;
        nameLabel.font = [UIFont systemFontOfSize:20];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + GAP , GAP, 120, 20)];
        phoneLabel.textColor = CharacterColor1;
        phoneLabel.font = [UIFont systemFontOfSize:16];
        phoneLabel.textAlignment = NSTextAlignmentLeft;
        _phoneLabel = phoneLabel;
        [self.contentView addSubview:phoneLabel];
        
        UILabel *adressLabel = [[UILabel alloc]initWithFrame:CGRectMake(GAP,CGRectGetMaxY(nameLabel.frame) + GAP, SCREEN.width - 20, 40)];
        adressLabel.textColor = CharacterColor2;
        adressLabel.font = [UIFont systemFontOfSize:13];
        adressLabel.lineBreakMode = NSLineBreakByCharWrapping;
        adressLabel.numberOfLines = 0;
        adressLabel.textAlignment = NSTextAlignmentLeft;
        _adressLabel = adressLabel;
        [self.contentView addSubview:adressLabel];
        
        UIImageView *rowImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN.width - 30, 35, 10, 20)];
        [rowImage setImage:[UIImage imageNamed:@"purpleRow"]];
        [self.contentView addSubview:rowImage];
        
        
        UILabel  *borderLabel = [[UILabel alloc]initWithFrame:CGRectMake(GAP, CGRectGetMaxY(adressLabel.frame) + GAP, SCREEN.width - GAP, 0.5)];
        borderLabel.backgroundColor = RGColor(237, 237, 237);
        [self.contentView addSubview:borderLabel];
        

        
        
    }
    return self;
}

- (void)setModel:(AddressModel *)model{
    _model = model;
    _nameLabel.text = model.userName;
    _phoneLabel.text = model.phone;
    _adressLabel.text = model.address;

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
