//
//  UIView+Frame.m
//  Tomaintain
//
//  Created by iOS on 15/8/3.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
-(CGFloat)widthWithUIScreen
{
    CGRect rect=[[UIScreen mainScreen]bounds];
    return rect.size.width;
}
-(CGFloat)heightWithUIScreen
{
    CGRect rect=[[UIScreen mainScreen]bounds];
    return rect.size.height;
}
-(void)addLine
{
    UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.frame), SCREEN.width-20, 1)];
    lab.backgroundColor=[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    [self addSubview:lab];
}

@end
