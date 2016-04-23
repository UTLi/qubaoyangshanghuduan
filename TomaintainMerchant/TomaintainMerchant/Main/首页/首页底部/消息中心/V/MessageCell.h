//
//  MessageCell.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/16.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageModel;
@interface MessageCell : UITableViewCell

//@property(nonatomic ,retain) ProductModel *model;
@property(nonatomic ,retain) UILabel *imageLbel;//公告图
@property(nonatomic ,retain) UILabel *titleLabel;//标题
@property(nonatomic ,retain) UILabel *detailLabel;//详情
@property(nonatomic ,retain) UILabel *redSpot;//红点
@property(nonatomic ,retain) MessageModel *model;


@end
