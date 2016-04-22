//
//  OrderConAdressCell.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/7.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressModel;

@interface OrderConAdressCell : UITableViewCell

@property(nonatomic ,retain) UILabel *nameLabel;
@property(nonatomic ,retain) UILabel *phoneLabel;
@property(nonatomic ,retain) UILabel *adressLabel;
@property(nonatomic ,strong) AddressModel *model;

@end
