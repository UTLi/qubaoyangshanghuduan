//
//  MessageDetailController.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/16.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailController : UIViewController


@property (nonatomic ,retain) NSString *messageID;//接收ID
@property (nonatomic ,retain) UILabel *detailLabel;
@property (nonatomic ,retain) UIScrollView *scrollView;
@end
