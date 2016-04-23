//
//  AddressPickView.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/1.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddressPickViewDelegate<NSObject>

- (void)slectDoneWithRegionStr:(NSString *)regionStr andProvinceCode:(NSString*)provinceCode andCityCode:(NSString*)cityCode andAreaCode:(NSString*)areaCode;

@end
@interface AddressPickView : UIView

@property (nonatomic ,retain) id <AddressPickViewDelegate>delegate;

- (void)show;

@end
