//
//  ServeDetailController.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/19.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServeTopModel;
@interface ServeDetailController : UIViewController

@property (nonatomic ,retain) NSString *detailId;
@property (nonatomic ,retain) ServeTopModel *topModel;

@end
