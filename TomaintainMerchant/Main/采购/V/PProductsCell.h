//
//  PProductsCell.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/22.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductModel;
@protocol PProductsCellDelegate <NSObject>

-(void)addToPurchasCarWithProductId:(NSString*)productId;

@end
@interface PProductsCell : UITableViewCell

@property(nonatomic ,retain) ProductModel *model;
@property(nonatomic ,retain) UIImageView *image;
@property(nonatomic ,retain) UILabel *nameLabel;
@property(nonatomic ,retain) UILabel *priceLabel;
//@property(nonatomic ,retain) UILabel *memberPriceLabel;
@property(nonatomic ,retain) UILabel *buyLabel;

@property (nonatomic ,retain) id<PProductsCellDelegate>delegate;

@end
