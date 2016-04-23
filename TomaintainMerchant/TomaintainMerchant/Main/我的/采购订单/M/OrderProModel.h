//
//  OrderProModel.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/2.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderProModel : NSObject

@property(nonatomic ,retain) NSString* productId;//商品ID
@property(nonatomic ,retain) NSString* img;//商品图片
@property(nonatomic ,retain) NSString* name;//商品名
@property(nonatomic ,retain) NSString* price;//商品价格
@property(nonatomic ,retain) NSString* productCOunt;//商品数量

@end
