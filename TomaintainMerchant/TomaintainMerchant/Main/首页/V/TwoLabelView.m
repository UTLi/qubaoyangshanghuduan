//
//  TwoLabelView.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/1/26.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "TwoLabelView.h"

@implementation TwoLabelView

- (id)initWithFrame:(CGRect)frame andLabOneColor :(UIColor*)labOneColor andLabTwo:(NSString*)labTwo
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, frame.size.width, (frame.size.height - 15)/2)];
        labelOne.textColor = labOneColor;
        labelOne.textAlignment = NSTextAlignmentCenter;
        [labelOne setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:18.00]];
        _label = labelOne;
        [self addSubview:labelOne];

        UILabel *labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(0, ((frame.size.height - 15)/2) + 10, frame.size.width, (frame.size.height - 15)/2)];
        labelTwo.textColor = CharacterColor1;
        labelTwo.textAlignment = NSTextAlignmentCenter;
        [labelTwo setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:20.00]];
        labelTwo.text = labTwo;
        [self addSubview:labelTwo];
        
        
        
    }
    return self;
}

@end
