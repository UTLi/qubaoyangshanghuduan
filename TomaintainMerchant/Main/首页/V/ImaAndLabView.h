//
//  ImaAndLabView.h
//  TomaintainMerchant
//
//  Created by 李沛 on 16/1/26.
//  Copyright © 2016年 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImaAndLabView;
//注意:这里最好传一个参数,而且这个参数最好是当前按钮自身,这样可以将按钮的所有属性都传出去
typedef void (^myBlock)(ImaAndLabView *imaAndLabView);
@interface ImaAndLabView : UIView

@property (nonatomic,copy) myBlock tempBlock;

- (id)initWithFrame:(CGRect)frame andImageName:(NSString *)imageName andlabelTex:(NSString *)labelTex andBlock:(myBlock)tapBlock;

@end
