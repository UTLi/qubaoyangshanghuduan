//
//  OrderProFooterView.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/2.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderAllModel;
@interface OrderProFooterView : UITableViewHeaderFooterView

@property (nonatomic ,retain) UILabel *label;
@property (nonatomic ,retain) OrderAllModel *model;

@end
