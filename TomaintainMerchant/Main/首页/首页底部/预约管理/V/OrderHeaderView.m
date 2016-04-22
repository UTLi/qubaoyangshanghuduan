//
//  OrderHeaderView.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/15.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "OrderHeaderView.h"
#import "OrderModel.h"
@interface OrderHeaderView()
/** 内部的label */
@property (nonatomic, weak) UILabel *orderlabel;
@property (nonatomic, weak) UILabel *statuslabel;

@end
@implementation OrderHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = RGColor(224, 225, 226);
        
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
        
    }
    return self;
}

- (void)setModel:(OrderModel *)model{
    _model = model;
    self.orderlabel.text = [NSString stringWithFormat:@"订单编号：%@",_model.orderNum];
    if ([_model.status isEqualToString:@"1"]) {
        self.statuslabel.text = @"已完成";
    }else if([_model.status isEqualToString:@"0"]){
        self.statuslabel.text = @"未完成";
    }

}

@end
