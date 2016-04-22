//
//  MemberManageCell.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/17.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MemberManageModel;
@interface MemberManageCell : UITableViewCell

@property (nonatomic ,retain) MemberManageModel *model;
@property (nonatomic ,retain) UIImageView *image;
@property (nonatomic ,retain) UILabel *nameLabel;
@property (nonatomic ,retain) UILabel *mobileLabel;


@end
