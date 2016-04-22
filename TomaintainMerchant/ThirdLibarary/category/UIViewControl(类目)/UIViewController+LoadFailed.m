//
//  UIViewController+LoadFailed.m
//  Tomaintain
//
//  Created by iOS on 15/9/5.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import "UIViewController+LoadFailed.h"

@implementation UIViewController (LoadFailed)
-(void)loadFailedWithImagesWithNavigationBar
{
    UIImageView * iV  = (UIImageView *)[self.view viewWithTag:100001];
    if (iV)
    {
        return;
    }
    iV.userInteractionEnabled=YES;
    
    UIImageView * IV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN.width/3,(SCREEN.width/3)/151*203)];
    IV.tag=100001;
    IV.image=[UIImage imageNamed:@"加载失败"];
    CGPoint point=self.view.center;
    point.y=point.y;
    IV.center=point;
    [self.view addSubview:IV];
}

-(void)loadFailedWithImage
{
    UIImageView * iV  = (UIImageView *)[self.view viewWithTag:100001];
    if (iV)
    {
        return;
    }
    
    UIImageView * IV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN.width/3,(SCREEN.width/3)/151*203)];
    IV.tag=100001;
    IV.image=[UIImage imageNamed:@"加载失败"];
    CGPoint point=self.view.center;
    point.y=point.y-100;
    IV.center=point;
    [self.view addSubview:IV];
}
-(void)removeFailesImage
{
    
    UIImageView * IV  = (UIImageView *)[self.view viewWithTag:100001];
    if (IV)
    {
         [IV removeFromSuperview];
    }
   
}


#pragma mark - 根据输入移动View 位置
- (void)moveView:(UIView *)textField bottomView:(UIView*)btn leaveView:(BOOL)leave
{
    UIView *accessoryView = textField.inputAccessoryView;
    UIView *inputview     = textField.inputView;
    
    int textFieldY = 0;
    int accessoryY = 0;
    if (accessoryView && inputview)
    {
        CGRect accessoryRect = accessoryView.frame;
        CGRect inputViewRect = inputview.frame;
        accessoryY = SCREEN.height - (accessoryRect.size.height + inputViewRect.size.height);
    }
    else if (accessoryView)
    {
        CGRect accessoryRect = accessoryView.frame;
        accessoryY = SCREEN.height - (accessoryRect.size.height + self.view.frame.origin.y-20);
    }
    else if (inputview)
    {
        CGRect inputViewRect = inputview.frame;
        accessoryY = SCREEN.height -inputViewRect.size.height;
    }
    else
    {
        if (CGRectGetMaxY(self.view.frame)-CGRectGetMaxY(textField.frame)<300)
        {
            accessoryY=CGRectGetMaxY(self.view.frame)-CGRectGetMaxY(btn.frame);
        }else
        {
            return;
        }
        
    }
    
    
    CGRect textFieldRect = textField.frame;
    textFieldY = textFieldRect.origin.y + textFieldRect.size.height + 20;
    
    int offsetY = textFieldY - accessoryY;
    if (!leave && offsetY > 0)
    {
        int y_offset = -5;
        
        y_offset += -offsetY;
        
        CGRect viewFrame = self.view.frame;
        
        viewFrame.origin.y += y_offset;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
    else
    {
        CGRect viewFrame = CGRectMake(0, 0, SCREEN.width, SCREEN.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
}

@end
