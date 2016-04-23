//
//  OrderConProCell.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/7.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "OrderConProCell.h"
#import "PurchaseCarModel.h"
#define ImgWidth SCREEN.width*0.3
#define GAP 5
#define ViewHeight SCREEN.width*0.3 + 20
@implementation OrderConProCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10 , 10, ImgWidth - 20,ImgWidth - 20)];
        image.backgroundColor = RGColor(92, 44 , 160);
        _image = image;
        [self.contentView addSubview:image];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + GAP, GAP, SCREEN.width - ImgWidth - 2*GAP - 40, (ViewHeight - 4 *GAP)/2)];
        nameLabel.textColor = CharacterColor1;
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        nameLabel.numberOfLines = 0;
        _nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + GAP, CGRectGetMaxY(_nameLabel.frame ) + GAP * 2 , 100, (ViewHeight - 4 * GAP)/4)];
        priceLabel.textAlignment = NSTextAlignmentLeft;
        priceLabel.font = [UIFont systemFontOfSize:15];
        priceLabel.textColor = [UIColor redColor];
        _priceLabel = priceLabel;
        [self.contentView addSubview:priceLabel];
        
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.width - GAP - 100 , CGRectGetMaxY(_nameLabel.frame ) + GAP * 2 , 100, (ViewHeight - 4 * GAP)/4)];
        numLabel.textAlignment = NSTextAlignmentLeft;
        numLabel.font = [UIFont systemFontOfSize:15];
        numLabel.textColor = CharacterColor2;
        _numLabel = numLabel;
        [self.contentView addSubview:numLabel];
        
        
        
        UILabel  *borderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN.width*0.3 + 19.5, SCREEN.width, 0.5)];
        borderLabel.backgroundColor = RGColor(245, 246, 246);
        [self addSubview:borderLabel];
        
    }
    return self;
}

- (void)setModel:(PurchaseCarModel *)model{
    
    _model = model;
    [_image sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:nil];
    _nameLabel.text = _model.productName;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_model.price];
    _numLabel.text = [NSString stringWithFormat:@"×%@",_model.total];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
