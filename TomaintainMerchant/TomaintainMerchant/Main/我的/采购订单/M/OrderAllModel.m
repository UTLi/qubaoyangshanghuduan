//
//  OrderAllModel.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/2.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "OrderAllModel.h"
#import "OrderProModel.h"
@implementation OrderAllModel



-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqual:@"product"]) {
        self.productArr = [NSMutableArray array];
        NSArray *proArr = value;
        for (int i = 0; i < proArr.count; i++) {
            NSDictionary *proDic = proArr[i];
            OrderProModel *proModel = [[OrderProModel alloc]init];
            [proModel setValuesForKeysWithDictionary:proDic];
            [self.productArr addObject:proModel];
        }
    }
}
@end
