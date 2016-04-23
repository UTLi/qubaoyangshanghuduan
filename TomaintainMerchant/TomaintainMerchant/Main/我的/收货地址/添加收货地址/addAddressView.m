//
//  addAddressView.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/1.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "addAddressView.h"

@implementation addAddressView

- (id)initWithFrame:(CGRect)frame andlabel1Str:(NSString *)label1Str{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, (SCREEN.width - 30 )* 0.3, frame.size.height- 0.5)];
        label.textColor = CharacterColor1;
        label.text = label1Str;
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:15];
        [self addSubview:label];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0 ,frame.size.height - 0.5 , SCREEN.width, 0.5)];
        line.backgroundColor = RGColor(235, 236, 237);
        [self addSubview:line];
        
    }
    return self;
  }



@end
