//
//  ProductsCell.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/1.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "ProductsCell.h"
#import "ProductModel.h"
#define ImgWidth SCREEN.width*0.3
#define GAP 5
#define ViewHeight SCREEN.width/3
@implementation ProductsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
    
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, ImgWidth - 20,ImgWidth - 20)];
        image.backgroundColor = RGColor(92, 44 , 160);
        _image = image;
        [self addSubview:image];
    
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + GAP, GAP, SCREEN.width - ImgWidth - 2*GAP, (ViewHeight - 4 *GAP)/2)];
        nameLabel.textColor = CharacterColor2;
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        nameLabel.numberOfLines = 0;
        _nameLabel = nameLabel;
        [self addSubview:nameLabel];
    
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + GAP, CGRectGetMaxY(nameLabel.frame ) + GAP, 100, (ViewHeight - 4 * GAP)/4)];
        priceLabel.textAlignment = NSTextAlignmentLeft;
        priceLabel.font = [UIFont systemFontOfSize:15];
        _priceLabel = priceLabel;
        [self addSubview:priceLabel];
    
        UILabel *memberPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + GAP, CGRectGetMaxY(nameLabel.frame ) + GAP, 150, (ViewHeight - 4 * GAP)/4)];
        memberPriceLabel.textColor = [UIColor redColor];
        memberPriceLabel.textAlignment = NSTextAlignmentLeft;
        memberPriceLabel.font = [UIFont systemFontOfSize:15];
        _memberPriceLabel = memberPriceLabel;
        [self addSubview:memberPriceLabel];
    
        UILabel *buyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.width - 120, CGRectGetMaxY(_memberPriceLabel.frame), 110, 35)];
        buyLabel.text = @"加入购物车";
        buyLabel.textColor = RGColor(92, 44 , 160);
        buyLabel.layer.borderWidth  = 1.0f;
        buyLabel.layer.borderColor  = RGColor(92, 44 , 160).CGColor;
        buyLabel.layer.cornerRadius = 5.0f;
        buyLabel.textAlignment = NSTextAlignmentCenter;
        buyLabel.font = [UIFont systemFontOfSize:20];
        _buyLabel = buyLabel;
        [self addSubview:buyLabel];
            //给 iconView添加手势]
            UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction)];    //点击的次数
            aTapGR.numberOfTapsRequired = 1;
            [_buyLabel setUserInteractionEnabled:YES];
            //给self.view添加一个手势监测；
            [_buyLabel addGestureRecognizer:aTapGR];

            
         UILabel  *borderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN.width*0.3 + 19.5, SCREEN.width, 0.5)];
            borderLabel.backgroundColor = [UIColor lightGrayColor];
         [self addSubview:borderLabel];
            
        }
        return self;


}

- (void)setModel:(ProductModel *)model{
    _model = model;
    [_image sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:nil];
    _nameLabel.text = _model.name;
//    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_model.price];
    _memberPriceLabel.text = [NSString stringWithFormat:@"会员价：¥%@",_model.vipPrice];

}
#pragma mark--点击加入购物车
-(void)tapGRAction{
    NSString *productId = _model.ProId;
    [self.delegate addToPurchasCarWithProductId:productId];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
