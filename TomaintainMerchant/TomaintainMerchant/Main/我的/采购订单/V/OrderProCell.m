//
//  OrderProCell.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/2.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "OrderProCell.h"
#import "OrderProModel.h"
#define ImgWidth SCREEN.width*0.3
#define GAP 5
#define ViewHeight SCREEN.width*0.3 + 20
@implementation OrderProCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, ImgWidth - 20,ImgWidth - 20)];
        image.backgroundColor = RGColor(92, 44 , 160);
        _image = image;
        [self addSubview:image];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + GAP, GAP, SCREEN.width - ImgWidth - 2*GAP, (ViewHeight - 4 *GAP)/2)];
                nameLabel.textColor = CharacterColor1;
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        nameLabel.numberOfLines = 0;
        _nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + GAP, CGRectGetMaxY(nameLabel.frame ) + GAP * 3, 100, (ViewHeight - 4 * GAP)/4)];
        priceLabel.textAlignment = NSTextAlignmentLeft;
        priceLabel.font = [UIFont systemFontOfSize:15];
        priceLabel.textColor = CharacterColor1;
        _priceLabel = priceLabel;
        [self addSubview:priceLabel];

        
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.width - 120, ImgWidth - 35, 110, 35)];
        numLabel.textColor = CharacterColor1;
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.font = [UIFont systemFontOfSize:20];
        _numLabel = numLabel;
        [self addSubview:numLabel];
        
//        
//        UILabel  *borderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN.width*0.3 + 19.5, SCREEN.width, 0.5)];
//        borderLabel.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:borderLabel];
        
    }
    return self;
    
    
}

- (void)setModel:(OrderProModel *)model{
    _model = model;
    [_image sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:nil];
    _nameLabel.text = _model.name;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_model.price];
    _numLabel.text = [NSString stringWithFormat:@"×%@",_model.productCOunt];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
