//
//  UIViewController+LetfBarButton.m
//  Tomaintain
//
//  Created by iOS on 15/8/21.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import "UIViewController+LetfBarButton.h"

@implementation UIViewController (LetfBarButton)
-(void)addLetfBarAndPopToLastWithTarget
{
    UIBarButtonItem * left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回按钮"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addLetfBarAndDismissToLastWithTarget
{
    UIBarButtonItem * left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回按钮"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissBack)];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)dismissBack
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}





@end
