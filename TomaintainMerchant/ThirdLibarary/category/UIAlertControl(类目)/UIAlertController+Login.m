//
//  UIAlertController+Login.m
//  Tomaintain
//
//  Created by iOS on 15/8/13.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import "UIAlertController+Login.h"

@implementation UIAlertController (Login)
+(void)deloginAndShow:(UIViewController *)VC
{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"您现在未登录,是否登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //获取loginStoryboard
        UIStoryboard * loginStory = [UIStoryboard storyboardWithName:@"LoadStoryBoard" bundle:nil];
        UINavigationController * loginNC = [loginStory instantiateInitialViewController];
        //instantiateInitial实例初始Controller
        //将loginNC模态出来
        [VC presentViewController:loginNC
                           animated:YES completion:^{
                               
                           }];
        
    }];
    UIAlertAction * cancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        return ;
        
    }];
    [alert addAction:action];
    [alert addAction:cancle];
    [VC presentViewController:alert animated:YES completion:nil];
}

+(void)alerShowWith:(NSString *)title Message:(NSString *)message adnOneBtn:(NSString *)one andTwoBtn:(NSString *)btn andOKBlock:(void (^)(void)) OKBlock  andCancleBlock:(void(^)(void)) cancleBlock andRootVC:(id)vc
{
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action=[UIAlertAction actionWithTitle:one style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        OKBlock();
        
    }];
    UIAlertAction * cancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
        
        cancleBlock();
        
    }];
    [alert addAction:action];
    [alert addAction:cancle];
    [vc presentViewController:alert animated:YES completion:nil];
    
}
+(void)showWithTitle:(NSString *)title AfterDismissWithTime:(float)time RootVC:(UIViewController *)vc
{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    [vc presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

+(void)showWithTitle:(NSString *)title AfterDismissWithTime:(float)time andAfterDoSomethingWithBlock:(void (^)(void))OKBlock RootVC:(UIViewController *)vc
{
      UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    [vc presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [alert dismissViewControllerAnimated:YES completion:nil];
            OKBlock();
            
            
        });
    }];
}

@end
