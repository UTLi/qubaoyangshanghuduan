//
//  OrderAllModel.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/2.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderProModel;
@interface OrderAllModel : UITableViewHeaderFooterView

@property(nonatomic ,retain) NSString* orderNum;//订单号
@property(nonatomic ,retain) NSString* amount;//订单总金额
@property(nonatomic ,retain) NSString* status;//订单状态（0：未支付、1：已支付、2：已发货）
@property(nonatomic ,retain) NSString* total;//总商品数
//@property(nonatomic ,retain) NSArray* product;//商品
@property(nonatomic ,retain) NSMutableArray* productArr;//商品模型
@property(nonatomic ,retain) OrderProModel *orderProModel;
@end
