//
//  OrderPayQuitFooterView.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/2.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>


@class OrderAllModel;

@protocol OrderPayQuitFooterViewDelegate <NSObject>

- (void)payClick;

- (void)quitClickWithOrderNum:(NSString*)orderNum;

@end

@interface OrderPayQuitFooterView : UITableViewHeaderFooterView

@property (nonatomic ,retain) UILabel *label;//显示商品信息Label
@property (nonatomic ,retain) UILabel *buyLabel;//支付Label
@property (nonatomic ,retain) UILabel *quitLabel;//取消订单
@property (nonatomic ,retain) OrderAllModel *model;
@property (nonatomic ,retain) id<OrderPayQuitFooterViewDelegate>delegate;
@end
