//
//  OrderModel.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/15.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject


@property(nonatomic ,retain) NSString* orderId;//订单ID
@property(nonatomic ,retain) NSString* orderNum;//订单号
@property(nonatomic ,retain) NSString* userName;//用户名
@property(nonatomic ,retain) NSString* mobile;//电话
@property(nonatomic ,retain) NSString* orderDate;//预约时间 第三方订单为空
@property(nonatomic ,retain) NSString* serviceItems;//服务项目 第三方订单为空
@property(nonatomic ,retain) NSString* source;//订单来源 0、去保养 1、第三方订单
@property(nonatomic ,retain) NSString* status;//订单状态 完成状态 0：未完成 1：已完成

@end
