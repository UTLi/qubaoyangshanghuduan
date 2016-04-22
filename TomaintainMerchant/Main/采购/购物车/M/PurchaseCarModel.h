//
//  PurchaseCarModel.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/24.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchaseCarModel : NSObject

@property(nonatomic ,retain) NSString* cartId;//购物车ID
@property(nonatomic ,retain) NSString* productId;//商品ID
@property(nonatomic ,retain) NSString* img;//商品图片
@property(nonatomic ,retain) NSString* productName;//商品名
@property(nonatomic ,retain) NSString* price;//商品价格
@property(nonatomic ,retain) NSString* total;//商品数量
@property(nonatomic ,assign) BOOL ifSlect;//是否选中
//@property(nonatomic ,retain) NSString* vipPprice;//会员价

@end
