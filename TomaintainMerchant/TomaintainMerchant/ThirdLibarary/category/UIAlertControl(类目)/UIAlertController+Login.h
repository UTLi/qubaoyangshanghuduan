//
//  UIAlertController+Login.h
//  Tomaintain
//
//  Created by iOS on 15/8/13.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Login)
+(void)deloginAndShow:(UIViewController *)VC;
+(void)alerShowWith:(NSString *)title Message:(NSString *)message adnOneBtn:(NSString *)one andTwoBtn:(NSString *)btn andOKBlock:(void (^)(void)) OKBlock  andCancleBlock:(void(^)(void)) cacleBlock andRootVC:(id)vc;
+(void)showWithTitle:(NSString *)title AfterDismissWithTime:(float)time RootVC:(UIViewController *)vc;

+(void)showWithTitle:(NSString *)title AfterDismissWithTime:(float)time andAfterDoSomethingWithBlock:(void (^)(void))OKBlock RootVC:(UIViewController *)vc;
@end
