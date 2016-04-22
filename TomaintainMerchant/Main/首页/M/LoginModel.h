//
//  LoginModel.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/1/27.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject


@property(nonatomic ,retain) NSDictionary* loginMsg;
@property(nonatomic ,retain) NSDictionary* station;

@property(nonatomic ,retain) NSString* msgbody;//登录结果说明信息token
@property(nonatomic ,retain) NSString* msgcode;//0：登录成功、1001：账号不存在、1002：用户名或密码错误、-1：服务器内部发生异常
@property(nonatomic ,retain) NSString* userType;

@property(nonatomic ,retain) NSString* VIP;//是否为会员 1：是 、0：否
@property(nonatomic ,retain) NSString* address;//场站地址
@property(nonatomic ,retain) NSString* stationId;//场站ID
@property(nonatomic ,retain) NSString* img;//logo
@property(nonatomic ,retain) NSString* stationName;//场站名
@property(nonatomic ,retain) NSString* workTime;//工作时间

@end
