//
//  CollectionViewCell.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/23.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "CollectionViewCell.h"
#import "ClassifyProductModel.h"
@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame) )];
        [self addSubview:self.imgView];
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame), CGRectGetWidth(self.frame), 20)];
        self.text.textColor = CharacterColor2;
        self.text.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.text];

    }
    return self;
}


- (void)setModel:(ClassifyProductModel *)model{

    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:[UIImage imageNamed:@"占位"]];
    _text.text = _model.name;


}

@end
