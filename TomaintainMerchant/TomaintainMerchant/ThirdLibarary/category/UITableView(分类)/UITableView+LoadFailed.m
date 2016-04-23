//
//  UITableView+LoadFailed.m
//  Tomaintain
//
//  Created by iOS on 15/9/5.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import "UITableView+LoadFailed.h"

@implementation UITableView (LoadFailed)
-(void)loadFailedWithImage
{
    UIImageView * iV  = (UIImageView *)[self viewWithTag:100001];
    if (iV)
    {
        return;
    }
    
    UIImageView * IV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN.width/3,(SCREEN.width/3)/151*203)];
    IV.tag=100001;
    IV.image=[UIImage imageNamed:@"加载失败"];
    CGPoint point=self.center;
    point.y=point.y-50;
    IV.center=point;
    [self addSubview:IV];
}
-(void)removeFailesImage
{
    
    UIImageView * IV  = (UIImageView *)[self viewWithTag:100001];
    if (IV)
    {
        [IV removeFromSuperview];
    }
    
}
@end
