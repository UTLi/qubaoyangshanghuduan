//
//  UIAlertView+AlertSecond.m
//  Tomaintain
//
//  Created by iOS on 15/8/12.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import "UIAlertView+AlertSecond.h"

@implementation UIAlertView (AlertSecond)

#pragma mark - UIAlertView 显示登陆状态
+(void)pushAlertView:(NSString * )title message:(NSString * )message delegate:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}
@end
