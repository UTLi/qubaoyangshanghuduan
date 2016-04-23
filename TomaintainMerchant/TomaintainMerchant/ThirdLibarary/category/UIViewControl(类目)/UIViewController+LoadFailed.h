//
//  UIViewController+LoadFailed.h
//  Tomaintain
//
//  Created by iOS on 15/9/5.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LoadFailed)
-(void)loadFailedWithImage;
-(void)removeFailesImage;
- (void)moveView:(UIView *)textField bottomView:(UIView*)btn leaveView:(BOOL)leave;
-(void)loadFailedWithImagesWithNavigationBar;
@end
