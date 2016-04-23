//
//  OrderBuyController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/2.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "OrderBuyController.h"
#import "SCNavTabBarController.h"
#import "AllOrderController.h"
#import "WaitOrderController.h"
#import "GoingOnOrderController.h"
@interface OrderBuyController ()

@end

@implementation OrderBuyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLetfBarAndDismissToLastWithTarget];
    self.navigationItem.title=@"采购订单";
    
    
    AllOrderController *allVC = [[AllOrderController alloc]init];
    allVC.title = @"全部";
    WaitOrderController *waitVC = [[WaitOrderController alloc]init];
    waitVC.title = @"待付款";
    GoingOnOrderController * goingVC = [[GoingOnOrderController alloc]init];
    goingVC.title = @"处理中";
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.num= 3;
    navTabBarController.subViewControllers = @[allVC,waitVC,goingVC];
    navTabBarController.navTabBarColor = [UIColor whiteColor];
    
    [navTabBarController addParentController:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
