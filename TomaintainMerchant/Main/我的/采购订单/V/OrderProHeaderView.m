//
//  OrderProHeaderView.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/2.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "OrderProHeaderView.h"
#import "OrderAllModel.h"
@implementation OrderProHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20,  20)];
        [image setImage:[UIImage imageNamed:@"订单"]];
        [self.contentView addSubview:image];
        
        //订单编号
        UILabel *orderlabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREEN.width - 110,40)];
        orderlabel.textColor = CharacterColor1;
        orderlabel.font = [UIFont systemFontOfSize:18];
        orderlabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:orderlabel];
        self.orderlabel = orderlabel;
        //订单状态
        UILabel *statuslabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN.width - 60 , 0, 50, 40)];
        statuslabel.textColor = [UIColor redColor];
        statuslabel.font = [UIFont systemFontOfSize:16];
        statuslabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:statuslabel];
        self.statuslabel = statuslabel;
        
        UILabel  *borderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40 - 0.5, SCREEN.width, 0.5)];
        borderLabel.backgroundColor = RGColor(235, 235, 235);
        [self addSubview:borderLabel];

        
    }
    return self;
}

- (void)setModel:(OrderAllModel *)model{
    _model = model;
    self.orderlabel.text = [NSString stringWithFormat:@"订单编号：%@",_model.orderNum];
    if ([_model.status isEqualToString:@"0"]) {
        self.statuslabel.text = @"未支付";
    }else if([_model.status isEqualToString:@"1"]){
        self.statuslabel.text = @"已支付";
    }else if([_model.status isEqualToString:@"2"]){
        self.statuslabel.text = @"已发货";
    }else{
        self.statuslabel.text = @"";
    }
    
}

@end
