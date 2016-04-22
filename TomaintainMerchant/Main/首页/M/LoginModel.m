//
//  LoginModel.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/1/27.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqual:@"loginMsg"]) {
        self.msgbody = [value objectForKey:@"msgbody"];
        self.msgcode = [value objectForKey:@"msgcode"];
        self.userType = [value objectForKey:@"userType"];
    }
    
    if ([key isEqual:@"station"]) {
        self.VIP = [value objectForKey:@"VIP"];
        self.address = [value objectForKey:@"address"];
        self.stationId = [value objectForKey:@"id"];
        self.img = [value objectForKey:@"img"];
        self.stationName = [value objectForKey:@"stationName" ];
        self.workTime = [value objectForKey:@"workTime"];
    }
    

}



@end
