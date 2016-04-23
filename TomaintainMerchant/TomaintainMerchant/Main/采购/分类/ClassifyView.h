//
//  ClassifyView.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/22.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClassifyViewDelegate <NSObject>

-(void)refreshTableViewWithCatolog:(NSString *)catolog;

@end

@interface ClassifyView : UIView

@property (nonatomic ,retain) id<ClassifyViewDelegate>delegate;


@end
