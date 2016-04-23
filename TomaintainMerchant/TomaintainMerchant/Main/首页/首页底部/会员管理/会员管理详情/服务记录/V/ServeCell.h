//
//  ServeCell.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/19.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class serveNoteModel;
@interface ServeCell : UITableViewCell

@property (nonatomic ,retain) serveNoteModel* model;
@property (nonatomic ,retain) UILabel* dateLabel;
@property (nonatomic ,retain) UILabel* metersLabel;


@end
