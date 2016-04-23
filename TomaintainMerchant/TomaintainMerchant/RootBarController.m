//
//  RootBarController.m
//  Tomaintain
//
//  Created by 李沛 on 15/8/5.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import "RootBarController.h"
#import "HomeViewController.h"
#import "PurchaseController.h"
#import "ReportFormsController.h"
#import "MyController.h"

@interface RootBarController ()

@end

@implementation RootBarController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIBarButtonItem * item=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:nil];

#pragma mark--首页
    HomeViewController * homeVC=[[HomeViewController alloc]init];
    UINavigationController * homeNC=[[UINavigationController alloc]initWithRootViewController:homeVC];
    homeNC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"首页"] selectedImage:[UIImage imageNamed:@"首页选中"]];

#pragma mark--采购
    PurchaseController * PurchaseVC=[[PurchaseController alloc]init
                                     ];
    UINavigationController * PurchaseNC=[[UINavigationController alloc]initWithRootViewController:PurchaseVC];
    PurchaseNC.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"采购" image:[UIImage imageNamed:@"采购"] selectedImage:[UIImage imageNamed:@"采购选中"]];
#pragma mark--报表
    ReportFormsController *ReportFormsVC = [[ReportFormsController alloc]init];
    UINavigationController * ReportFormsNC=[[UINavigationController alloc]initWithRootViewController:ReportFormsVC];
    ReportFormsNC.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"报表" image:[UIImage imageNamed:@"报表"] selectedImage:[UIImage imageNamed:@"报表选中"]];
#pragma mark--我的
    MyController * MyVC=[[MyController alloc]init];
        UINavigationController * MyNC=[[UINavigationController alloc]initWithRootViewController:MyVC];
    MyNC.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"我的" image: [UIImage imageNamed:@"我的"] selectedImage: [UIImage imageNamed:@"我的选中"]];

#pragma mark --viewControllers
    //    设置viewControllers属性
    self.viewControllers = @[homeNC,PurchaseNC,ReportFormsNC,MyNC];
    //    设置导航背景颜色
    [[UINavigationBar appearance] setBarTintColor:RGColor(95, 38, 163)];
    //    设置tabBar背景颜色
//    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    //    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    self.tabBar.tintColor = RGColor(95, 38, 163);
//    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
