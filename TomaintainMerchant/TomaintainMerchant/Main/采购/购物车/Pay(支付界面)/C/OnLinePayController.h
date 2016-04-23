//
//  OnLinePayController.h
//  Tomaintain
//
//  Created by 李沛 on 15/10/7.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OnLinePayControllerDelegate <NSObject>
@optional
-(void)refresh;
-(void)faildFresh;
@end
@interface OnLinePayController : UIViewController
@property(nonatomic, retain) NSString * orderNum;//订单号
@property(nonatomic, retain) NSString * paysum;//支付金额String型
@property(nonatomic, retain) NSDictionary * ProMessage;//商品信息
@property(nonatomic, assign) float finalPrice;//最终价格float型
@property(nonatomic , retain)id<OnLinePayControllerDelegate>delegate;
@end
