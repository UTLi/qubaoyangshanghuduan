//
//  CommentModel.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/16.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqual:@"id"]) {
        self.commentId = value;
    }
}


@end
