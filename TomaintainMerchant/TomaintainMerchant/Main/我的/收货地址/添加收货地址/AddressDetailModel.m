//
//  AddressDetailModel.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/1.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "AddressDetailModel.h"

@implementation AddressDetailModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    
    if ([key isEqual:@"id"]) {
        self.addressId = value;
    }
}

@end
