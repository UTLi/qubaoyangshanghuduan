//
//  MessageDetailModel.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/16.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageDetailModel : NSObject
@property(nonatomic ,retain) NSString* MessageId;//消息ID
@property(nonatomic ,retain) NSString* title;//标题
@property(nonatomic ,retain) NSString* content;//内容
@property(nonatomic ,retain) NSString* createDate;//发布时间
@end
