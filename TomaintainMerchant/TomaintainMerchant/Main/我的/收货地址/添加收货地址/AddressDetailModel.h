//
//  AddressDetailModel.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/1.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressDetailModel : NSObject

@property(nonatomic ,retain) NSString* addressId;//地址ID
@property(nonatomic ,retain) NSString* userName;//姓名
@property(nonatomic ,retain) NSString* phone;//电话
@property(nonatomic ,retain) NSString* address;//地址信息
@property(nonatomic ,retain) NSString* isDefault;//是否为默认地址1：是、0：否
@property(nonatomic ,retain) NSString* code;//邮政编码
@property(nonatomic ,retain) NSString* province;//省
@property(nonatomic ,retain) NSString* city;//市
@property(nonatomic ,retain) NSString* region;//区
@property(nonatomic ,retain) NSString* provinceCode;//省编码
@property(nonatomic ,retain) NSString* cityCode;//市编码
@property(nonatomic ,retain) NSString* regionCode;//区编码
@end
