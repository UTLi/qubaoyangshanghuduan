//
//  serveTopView.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/18.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServeTopModel;
@interface serveTopView : UIView

@property (nonatomic ,retain) UIImageView * autoImgView;//车辆图标
@property (nonatomic ,retain) UILabel * autoBrandLabel;//品牌车系
@property (nonatomic ,retain) UILabel * autoModelLabel;//车型
@property (nonatomic ,retain) UILabel * licenseplateLabel;//车牌号
@property (nonatomic ,retain) UILabel * dateLabel;//日期
@property (nonatomic ,retain) UILabel * meterLabel;//日期
@property (nonatomic ,retain) ServeTopModel * model;//车牌号


@end
