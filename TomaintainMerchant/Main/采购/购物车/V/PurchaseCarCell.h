//
//  PurchaseCarCell.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/23.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PKYStepper;
@class PurchaseCarModel;
@protocol PurchaseCarCellDelegate <NSObject>

- (void)ChangeMoneyAndAmount;

- (void)ChangeSubBtnState;//改变全选Btn的状态
@end
@interface PurchaseCarCell : UITableViewCell

@property(nonatomic ,retain) UIButton *selectBtn;
@property(nonatomic ,retain) UIImageView *circleImage;
@property(nonatomic ,retain) UIImageView *image;
@property(nonatomic ,retain) UILabel *nameLabel;
@property(nonatomic ,retain) UILabel *priceLabel;
@property(nonatomic ,retain) UILabel *numLabel;
@property(nonatomic ,assign) BOOL ifSlected;//是否选中

@property(nonatomic, strong) PKYStepper *plainStepper;
@property(nonatomic, strong) PurchaseCarModel *model;
@property(nonatomic ,retain) id<PurchaseCarCellDelegate>delegate;

@end
