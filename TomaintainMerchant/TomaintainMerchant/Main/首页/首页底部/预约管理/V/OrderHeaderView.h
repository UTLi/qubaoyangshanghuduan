//
//  OrderHeaderView.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/15.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@interface OrderHeaderView : UITableViewHeaderFooterView

@property (nonatomic, retain) OrderModel *model;

@end
