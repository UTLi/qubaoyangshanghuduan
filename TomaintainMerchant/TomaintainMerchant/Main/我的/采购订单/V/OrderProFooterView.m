//
//  OrderProFooterView.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/2.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "OrderProFooterView.h"
#import "OrderAllModel.h"
@implementation OrderProFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        UILabel  *topBorderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, 0.5)];
        topBorderLabel.backgroundColor = RGColor(218, 218, 218);
        [self addSubview:topBorderLabel];
        //商品总计，合计金额
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.5, SCREEN.width ,39.5)];
        label.textColor = CharacterColor2;
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _label = label;
        
        UILabel  *borderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50 - 10, SCREEN.width, 10)];
        borderLabel.backgroundColor = RGColor(218, 218, 218);
        [self addSubview:borderLabel];
    }
    return self;
}

- (void)setModel:(OrderAllModel *)model{
    _model = model;
    _label.text = [NSString stringWithFormat:@"共计%@件商品    合计：%@",_model.total,_model.amount];

}


@end
