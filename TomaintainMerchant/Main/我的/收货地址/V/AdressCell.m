//
//  AdressCell.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/27.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "AdressCell.h"
#import "AddressModel.h"
#define GAP 10
@implementation AdressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(GAP, GAP, 80, 20)];
        nameLabel.textColor = CharacterColor1;
        nameLabel.font = [UIFont systemFontOfSize:18];
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
        
        UILabel  *borderLabel = [[UILabel alloc]initWithFrame:CGRectMake(GAP, CGRectGetMaxY(adressLabel.frame) + GAP, SCREEN.width - GAP, 0.5)];
        borderLabel.backgroundColor = RGColor(237, 237, 237);
        [self addSubview:borderLabel];
        
        UIImageView *circleImage = [[UIImageView alloc]initWithFrame:CGRectMake(GAP,CGRectGetMaxY(borderLabel.frame) + GAP, 20, 20)];
        circleImage.userInteractionEnabled = YES;
        [circleImage.layer setMasksToBounds:YES];
        [circleImage.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBtnClick)];//点击的次数
        aTapGR.numberOfTapsRequired = 1;
        [circleImage setUserInteractionEnabled:YES];
        //给self.view添加一个手势监测；
        [circleImage addGestureRecognizer:aTapGR];
        _circleImage = circleImage;
        [self.contentView addSubview:circleImage];
        
        UILabel *isDefaultLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(circleImage.frame) + GAP,CGRectGetMaxY(borderLabel.frame) + GAP, 100, 20)];
        isDefaultLabel.textColor = CharacterColor2;
        isDefaultLabel.font = [UIFont systemFontOfSize:13];
        isDefaultLabel.textAlignment = NSTextAlignmentLeft;
        _isDefaultLabel = isDefaultLabel;
        [self.contentView addSubview:isDefaultLabel];
        
        UIImageView *editImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN.width - 20 * 2 - GAP * 4 - 40 * 2, CGRectGetMaxY(borderLabel.frame) + GAP, 20, 20)];
        [editImage setImage:[UIImage imageNamed:@"编辑"]];
        [self.contentView addSubview:editImage];
        
        UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(editImage.frame) + GAP, CGRectGetMaxY(borderLabel.frame) + GAP , 40, 20)];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:CharacterColor2 forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:editBtn];
        
        UIImageView *deletImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(editBtn.frame) + GAP, CGRectGetMaxY(borderLabel.frame) + GAP, 20, 20)];
        [deletImage setImage:[UIImage imageNamed:@"删除"]];
        [self.contentView addSubview:deletImage];
        
        UIButton *deletBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(deletImage.frame) + GAP, CGRectGetMaxY(borderLabel.frame) + GAP, 40, 20)];
        [deletBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deletBtn setTitleColor:CharacterColor2 forState:UIControlStateNormal];
        [deletBtn addTarget:self action:@selector(deletClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deletBtn];
        

        
    }
    return self;
}

- (void)setModel:(AddressModel *)model{
    _model = model;
    _nameLabel.text = model.userName;
    _phoneLabel.text = model.phone;
    _adressLabel.text = model.address;
    if ([model.isDefault isEqualToString:@"1"]) {
        //是默认的
        _isDefaultLabel.text = @"设为默认";
        [_circleImage setImage:[UIImage imageNamed:@"圆圈"]];
    }else{
        _isDefaultLabel.text = @"默认地址";
        [_circleImage setImage:[UIImage imageNamed:@"红色对号"]];
    
    }

}

#pragma mark-- 点击设为默认

- (void)selectBtnClick{

    [self.delegate setIfDefaultWithAddressId:_model.addressId];

}


#pragma mark--点击编辑
- (void)editClick{
//    NSString *isdefault = _model.isDefault;
    [self.delegate EditAddressWithAddressId:_model.addressId AndisDefault:_model.isDefault];

}
#pragma mark--点击删除
- (void)deletClick{

    [self.delegate DeletAddressWithAddressId:_model.addressId];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
