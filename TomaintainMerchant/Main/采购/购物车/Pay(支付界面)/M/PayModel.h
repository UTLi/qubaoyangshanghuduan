//
//  PayModel.h
//  Tomaintain
//
//  Created by iOS on 15/8/5.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PayModel : NSObject
@property(nonatomic,retain)UIImage * iconImage;
@property(nonatomic,retain)NSString * bString;
@property(nonatomic,retain)NSString * sString;
@property(nonatomic,retain)UIImage * selectImage;
@property(nonatomic ,retain)UIImage *deselectImage;
@property(nonatomic,assign)BOOL didSelected;
-(instancetype)initWithIcon:(UIImage *)iconImage bString:(NSString *)bString sString:(NSString *)sString selectImage:(UIImage *)selectImage deselectImage:(UIImage *)deselectImage didSelected:(BOOL)didSelected;


@end
