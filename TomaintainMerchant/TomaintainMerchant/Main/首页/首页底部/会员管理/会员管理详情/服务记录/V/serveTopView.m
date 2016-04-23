//
//  serveTopView.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/18.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "serveTopView.h"
#import "ServeTopModel.h"
#define Height 100
#define GAP 10
#define Whith 90
#define LabelW Height + 1 +GAP + Whith - 10
#define LabelHeight (Height - 4 * GAP ) / 3
#define Font1 [UIFont systemFontOfSize:18]
#define Font2 [UIFont systemFontOfSize:15]
@implementation serveTopView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(GAP * 2, GAP * 2, Height - GAP * 4, Height - GAP * 4)];
        _autoImgView = image;
        [self addSubview:image];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + GAP, GAP, 1, Height - 2 * GAP)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line.frame) + GAP, GAP, Whith, LabelHeight)];
        numLabel.text = @"车牌号码：";
        numLabel.textColor = CharacterColor1;
        numLabel.font = Font1;
        [self addSubview:numLabel];
        
        UILabel *brandLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line.frame) + GAP, GAP * 2 + LabelHeight, Whith, LabelHeight)];
        brandLabel.text = @"车辆品牌：";
        brandLabel.textColor = CharacterColor1;
        brandLabel.font = Font1;
        [self addSubview:brandLabel];
        
        UILabel *modelLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line.frame) + GAP, GAP * 3 + LabelHeight * 2, Whith, LabelHeight)];
        modelLabel.text = @"车辆车型：";
        modelLabel.textColor = CharacterColor1;
        modelLabel.font = Font1;
        [self addSubview:modelLabel];
        
        UILabel *licenseplateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame) , GAP, SCREEN.width - Height - Whith - GAP, LabelHeight)];
        licenseplateLabel.textColor = CharacterColor2;
        licenseplateLabel.font = Font2;
        [self addSubview:licenseplateLabel];
        _licenseplateLabel = licenseplateLabel;

        
        
        UILabel *autoBrandLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame) , GAP * 2 + LabelHeight, SCREEN.width - Height - Whith - GAP, LabelHeight)];
        autoBrandLabel.textColor = CharacterColor2;
        autoBrandLabel.font = Font2;
        [self addSubview:autoBrandLabel];
        _autoBrandLabel = autoBrandLabel;

 
        
        UILabel *autoModelLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame) , GAP * 3 + LabelHeight * 2, SCREEN.width - Height - Whith - GAP , LabelHeight)];
        autoModelLabel.textColor = CharacterColor2;
        autoModelLabel.font = Font2;
        [self addSubview:autoModelLabel];
        _autoModelLabel = autoModelLabel;
        
        UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, Height, SCREEN.width, 44)];
        grayView.backgroundColor = RGColor(235, 236, 237);
        [self addSubview:grayView];
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, (SCREEN.width - 20) * 3 / 5, 44)];
        dateLabel.text = @"  日期";
        dateLabel.font = Font2;
        dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel = dateLabel;
        [grayView addSubview:dateLabel];
        UILabel * meterLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dateLabel.frame), 0, (SCREEN.width - 20) * 2 / 5, 44)];
        meterLabel.text = @"行驶里程（公里）  ";
        meterLabel.font = Font2;
        meterLabel.textAlignment = NSTextAlignmentRight;
        _meterLabel = meterLabel;
        [grayView addSubview:meterLabel];
        
                                                  
    }
    return self;
}

-(void)setModel:(ServeTopModel *)model{
    _model = model;
    _autoBrandLabel.text = _model.autoBrand;
    _autoModelLabel.text = _model.autoModel;
    _licenseplateLabel.text = _model.licenseplate;
    [_autoImgView sd_setImageWithURL:[NSURL URLWithString:_model.autoImg] placeholderImage:nil];

}


@end
