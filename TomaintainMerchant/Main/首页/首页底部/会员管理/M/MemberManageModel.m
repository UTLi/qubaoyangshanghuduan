//
//  MemberManageModel.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/17.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "MemberManageModel.h"

@implementation MemberManageModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqual:@"id"]) {
        self.userId = value;
    }
}


@end
