//
//  AddAddressController.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/29.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddAddressControllerDelegate <NSObject>

- (void)refreshVC;//刷新页面用

@end

@interface AddAddressController : UIViewController



@property (nonatomic ,retain) NSString *titleStr;
@property (nonatomic ,retain) NSString *addressId;
@property (nonatomic ,retain) NSString *isDefault;//是为默认        
@property (nonatomic ,retain) id<AddAddressControllerDelegate>delegate;

@end
