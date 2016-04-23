//
//  OrderProHeaderView.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/2.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderAllModel;
@interface OrderProHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) UILabel *orderlabel;
@property (nonatomic, weak) UILabel *statuslabel;
@property (nonatomic ,retain) OrderAllModel *model;
@end
