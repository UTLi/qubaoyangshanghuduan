//
//  AddressModel.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/29.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

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
