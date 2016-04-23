//
//  TwoLabelView.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/1/26.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoLabelView : UIView

@property (nonatomic ,retain) UILabel *label;
- (id)initWithFrame:(CGRect)frame andLabOneColor :(UIColor*)labOneColor andLabTwo:(NSString*)labTwo;

@end
