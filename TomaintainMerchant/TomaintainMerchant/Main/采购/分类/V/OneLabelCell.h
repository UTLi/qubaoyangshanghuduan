//
//  OneLabelCell.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/22.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassifyProductModel;
@interface OneLabelCell : UITableViewCell

@property(nonatomic ,retain) UILabel *label;
@property(nonatomic ,retain) ClassifyProductModel *model;
@end
