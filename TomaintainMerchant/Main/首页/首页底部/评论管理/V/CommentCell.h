//
//  CommentCell.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/16.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentModel;
@interface CommentCell : UITableViewCell

@property (nonatomic ,retain) CommentModel *model;
@property (nonatomic ,retain) UILabel *commentLabel;
@property (nonatomic ,retain) UILabel *nameLabel;
@property (nonatomic ,retain) UILabel *dateLabel;
@end
