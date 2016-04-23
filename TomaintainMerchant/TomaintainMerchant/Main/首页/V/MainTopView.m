//
//  MainTopView.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/1/26.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "MainTopView.h"
#define TopViewHeight (SCREEN.height - 3 - 115)*220/916 //顶部View高度
#define GAPS  5 //缝隙
#define TOPGAPS 10 //顶部缝隙
#define LabelHeight (TopViewHeight - 10 - GAPS * 4)/4 //Label高度
@implementation MainTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic= [defaults objectForKey:@"usersMessage"];
        NSDictionary *stationDic =[dic objectForKey:@"station"];
        NSString *stationName = [stationDic objectForKey:@"stationName"];
        NSString *workTime = [stationDic objectForKey:@"workTime"];
        NSString *address = [stationDic objectForKey:@"address"];
        NSString *img = [stationDic objectForKey:@"img"];
        UIView *BackView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.width, TopViewHeight)];
        BackView.backgroundColor = [UIColor blackColor];
        BackView.userInteractionEnabled = YES;
        [self addSubview:BackView];
        
        UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, TOPGAPS, TopViewHeight/ 2, TopViewHeight / 2)];
        [leftImageView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"头像"]];
        leftImageView.layer.cornerRadius =  TopViewHeight / 4;
        leftImageView.layer.masksToBounds = YES;
        leftImageView.backgroundColor = [UIColor purpleColor];
        [BackView addSubview:leftImageView];
        
        UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageView.frame)+ GAPS, TOPGAPS, SCREEN.width - (CGRectGetMaxX(leftImageView.frame)+ GAPS), LabelHeight)];
        NameLabel.textColor = [UIColor whiteColor];
        NameLabel.textAlignment = NSTextAlignmentLeft;
        NameLabel.backgroundColor = [UIColor clearColor];
        NameLabel.text = stationName;
        NameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
        [BackView addSubview:NameLabel];
        
        UILabel *TimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageView.frame)+ GAPS, TOPGAPS + LabelHeight + GAPS , SCREEN.width - (CGRectGetMaxX(leftImageView.frame)+ GAPS), LabelHeight)];
        TimeLabel.textColor = [UIColor whiteColor];
        TimeLabel.textAlignment = NSTextAlignmentLeft;
        TimeLabel.backgroundColor = [UIColor clearColor];
        TimeLabel.text = [NSString stringWithFormat:@"营业时间：%@",workTime];
        TimeLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13];
        [BackView addSubview:TimeLabel];
        
        UILabel *AddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageView.frame)+ GAPS, TOPGAPS + (LabelHeight + GAPS) * 2,SCREEN.width - (CGRectGetMaxX(leftImageView.frame)+ GAPS), LabelHeight)];
        AddressLabel.textColor = RGColor(162, 140, 191);
        AddressLabel.textAlignment = NSTextAlignmentLeft;
        AddressLabel.backgroundColor = [UIColor clearColor];
        AddressLabel.text = [NSString stringWithFormat:@"地址：%@",address];
        AddressLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13];
        [BackView addSubview:AddressLabel];
        
        UILabel *StateLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.width - 80, TopViewHeight - GAPS - LabelHeight, 70, LabelHeight )];
        StateLabel.backgroundColor = [UIColor whiteColor];
        StateLabel.layer.masksToBounds = YES;
        StateLabel.layer.cornerRadius = 5;
        StateLabel.textColor = RGColor(162, 140, 191);
        StateLabel.textAlignment = NSTextAlignmentCenter;
        StateLabel.text = @"营业中";
        StateLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:15];
        [BackView addSubview:StateLabel];
        

    }
    return self;
}

@end
