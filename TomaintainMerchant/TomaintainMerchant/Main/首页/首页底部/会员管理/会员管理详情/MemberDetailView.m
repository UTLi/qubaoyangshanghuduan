//
//  MemberDetailView.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/18.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "MemberDetailView.h"

@implementation MemberDetailView

- (id)initWithFrame:(CGRect)frame andlabel1Str:(NSString *)label1Str
          andlabel2str:(NSString *)label2Str
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, (SCREEN.width - 30 )* 0.3, frame.size.height- 0.5)];
        label.textColor = CharacterColor1;
        label.text = label1Str;
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:15];
        [self addSubview:label];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 10 , 0, (SCREEN.width - 30) * 0.7, frame.size.height - 0.5)];
        label2.textColor = CharacterColor2;
        label2.text = label2Str;
        label2.textAlignment = NSTextAlignmentLeft;
        label2.font = [UIFont systemFontOfSize:18];
        [self addSubview:label2];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0 ,frame.size.height - 0.5 , SCREEN.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        
    }
    return self;
}

@end
