//
//  CommentModel.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/16.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property(nonatomic ,retain) NSString* commentId;//评论ID
@property(nonatomic ,retain) NSString* userName;//用户名
@property(nonatomic ,retain) NSString* date;//评价时间
@property(nonatomic ,retain) NSString* content;//评价内容

@end
