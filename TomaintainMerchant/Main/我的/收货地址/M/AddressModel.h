//
//  AddressModel.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/29.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property(nonatomic ,retain) NSString* addressId;//地址ID
@property(nonatomic ,retain) NSString* userName;//姓名
@property(nonatomic ,retain) NSString* phone;//电话
@property(nonatomic ,retain) NSString* address;//地址信息
@property(nonatomic ,retain) NSString* isDefault;//是否为默认地址1：是、0：否

@end
