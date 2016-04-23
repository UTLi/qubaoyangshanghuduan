//
//  AdressCell.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/27.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressModel;
@protocol AdressCellDelegate <NSObject>

- (void)setIfDefaultWithAddressId:(NSString*)addressId;//设为默认

- (void)EditAddressWithAddressId:(NSString*)addressId AndisDefault:(NSString*)isDefault;//编辑

- (void)DeletAddressWithAddressId:(NSString*)addressId;//删除
@end
@interface AdressCell : UITableViewCell

@property(nonatomic ,retain) UILabel *nameLabel;
@property(nonatomic ,retain) UILabel *phoneLabel;
@property(nonatomic ,retain) UILabel *adressLabel;
@property(nonatomic ,retain) UILabel *isDefaultLabel;//是否选中
@property(nonatomic ,retain) UIImageView *circleImage;//选中对号
@property(nonatomic ,strong) AddressModel *model;
@property(nonatomic ,retain) id<AdressCellDelegate>delegate;
@end
