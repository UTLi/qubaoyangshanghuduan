//
//  OrderConProCell.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/7.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PurchaseCarModel;
@interface OrderConProCell : UITableViewCell


@property(nonatomic ,retain) UIImageView *image;
@property(nonatomic ,retain) UILabel *nameLabel;
@property(nonatomic ,retain) UILabel *priceLabel;
@property(nonatomic ,retain) UILabel *numLabel;
@property(nonatomic ,retain) PurchaseCarModel *model;
@end
