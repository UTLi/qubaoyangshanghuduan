//
//  OrderPayQuitFooterView.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/2.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "OrderPayQuitFooterView.h"
#import "OrderAllModel.h"
@implementation OrderPayQuitFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        UILabel  *topBorderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, 0.5)];
        topBorderLabel.backgroundColor = RGColor(218, 218, 218);
        [self addSubview:topBorderLabel];
        
        //商品总计，合计金额
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.5, SCREEN.width ,39)];
        label.textColor = CharacterColor2;
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _label = label;
        
        UILabel  *borderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 39.5, SCREEN.width, 0.5)];
        borderLabel.backgroundColor = RGColor(218, 218, 218);
        [self addSubview:borderLabel];
        
        UILabel *buyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.width - 180, 45, 80, 30)];
        buyLabel.text = @"去支付";
        buyLabel.textColor = RGColor(92, 44 , 160);
        buyLabel.layer.borderWidth  = 1.0f;
        buyLabel.layer.borderColor  = RGColor(92, 44 , 160).CGColor;
        buyLabel.layer.cornerRadius = 5.0f;
        buyLabel.textAlignment = NSTextAlignmentCenter;
        buyLabel.font = [UIFont systemFontOfSize:18];
        _buyLabel = buyLabel;
        [self addSubview:buyLabel];
        //给 iconView添加手势]
        UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction)];    //点击的次数
        aTapGR.numberOfTapsRequired = 1;
        [_buyLabel setUserInteractionEnabled:YES];
        //给self.view添加一个手势监测；
        [_buyLabel addGestureRecognizer:aTapGR];
        
        UILabel *quitLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.width - 90, 45, 80, 30)];
        quitLabel.text = @"取消订单";
        quitLabel.textColor = RGColor(92, 44 , 160);
        quitLabel.layer.borderWidth  = 1.0f;
        quitLabel.layer.borderColor  = RGColor(92, 44 , 160).CGColor;
        quitLabel.layer.cornerRadius = 5.0f;
        quitLabel.textAlignment = NSTextAlignmentCenter;
        quitLabel.font = [UIFont systemFontOfSize:18];
        _quitLabel = quitLabel;
        [self addSubview:quitLabel];
        //给 iconView添加手势]
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(quitClick)];    //点击的次数
        tapGR.numberOfTapsRequired = 1;
        [_quitLabel setUserInteractionEnabled:YES];
        //给self.view添加一个手势监测；
        [_quitLabel addGestureRecognizer:tapGR];
        
        UILabel  *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 80, SCREEN.width, 10)];
        bottomLabel.backgroundColor = RGColor(218, 218, 218);
        [self addSubview:bottomLabel];

    }
    return self;
}
#pragma mark--点击去支付
- (void)tapGRAction{

    [self.delegate payClick];

}

#pragma mark--点击取消订单
- (void)quitClick{

    [self.delegate quitClickWithOrderNum:_model.orderNum];

}

- (void)setModel:(OrderAllModel *)model{
    _model = model;
    _label.text = [NSString stringWithFormat:@"共计%@件商品    合计：%@",_model.total,_model.amount];
    
}


@end
