//
//  CollectionViewCell.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/23.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassifyProductModel;
@interface CollectionViewCell : UICollectionViewCell

@property(nonatomic ,strong)UIImageView *imgView;
@property(nonatomic ,strong)UILabel *text;
@property(nonatomic ,retain) ClassifyProductModel *model;

@end
