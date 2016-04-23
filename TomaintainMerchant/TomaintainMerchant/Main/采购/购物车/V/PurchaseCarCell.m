//
//  PurchaseCarCell.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/23.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "PurchaseCarCell.h"
#import "PKYStepper.h"
#import "PurchaseCarModel.h"
#define ImgWidth SCREEN.width*0.3
#define GAP 5
#define ViewHeight SCREEN.width*0.3 + 20
@interface PurchaseCarCell()<PKYStepperDelegate>



@end
@implementation PurchaseCarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIButton *selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, ImgWidth )];
        _selectBtn = selectBtn;
        [selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selectBtn];
        
        UIImageView *circleImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, ImgWidth/2, 20, 20)];
        circleImage.userInteractionEnabled = YES;
        [circleImage.layer setMasksToBounds:YES];
        [circleImage.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
        UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBtnClick)];//点击的次数
        aTapGR.numberOfTapsRequired = 1;
        [circleImage setUserInteractionEnabled:YES];
        //给self.view添加一个手势监测；
        [circleImage addGestureRecognizer:aTapGR];
//        [circleImage.layer setBorderWidth:1.0]; //边框宽度
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 0, 0.5 });
//        [circleImage.layer setBorderColor:colorref];//边框颜色
        _circleImage = circleImage;
        _ifSlected = YES;//选中状态
        [_circleImage setImage:[UIImage imageNamed:@"红色对号"]];
        [self.contentView addSubview:circleImage];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10 + 40, 10, ImgWidth - 20,ImgWidth - 20)];
        image.backgroundColor = RGColor(92, 44 , 160);
        _image = image;
        [self.contentView addSubview:image];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + GAP, GAP, SCREEN.width - ImgWidth - 2*GAP - 40, (ViewHeight - 4 *GAP)/2)];
        nameLabel.textColor = CharacterColor1;
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        nameLabel.numberOfLines = 0;
        _nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        _plainStepper = [[PKYStepper alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + GAP, CGRectGetMaxY(nameLabel.frame ) + GAP, 100, (ViewHeight - 4 * GAP)/4)];
        _plainStepper.valueChangedCallback = ^(PKYStepper *stepper, float count) {
            stepper.countLabel.text = [NSString stringWithFormat:@"%@", @(count)];
        };
        [_plainStepper setBorderColor:RGColor(172, 173, 174)];
        [_plainStepper setBorderWidth:1];
        [_plainStepper setCornerRadius:5];
        [_plainStepper setLabelColor:RGColor(172, 173, 174)];
        [_plainStepper setLabelTextColor:RGColor(172, 173, 174)];
        [_plainStepper setButtonTextColor:RGColor(172, 173, 174) forState:UIControlStateNormal];
        [_plainStepper setButtonWidth:30];
        [_plainStepper setup];
        [_plainStepper setMinimum:1];
        [_plainStepper setMaximum:9999];
        [self.contentView addSubview:self.plainStepper];
        _plainStepper.hidden = YES;
        _plainStepper.delegate =self;

        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + GAP, CGRectGetMaxY(_plainStepper.frame ) + GAP , 100, (ViewHeight - 4 * GAP)/4)];
        priceLabel.textAlignment = NSTextAlignmentLeft;
        priceLabel.font = [UIFont systemFontOfSize:15];
        priceLabel.textColor = [UIColor redColor];
        _priceLabel = priceLabel;
        [self.contentView addSubview:priceLabel];
        
        UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.width - GAP - 100 , CGRectGetMaxY(_plainStepper.frame ) + GAP , 100, (ViewHeight - 4 * GAP)/4)];
        numLabel.textAlignment = NSTextAlignmentLeft;
        numLabel.font = [UIFont systemFontOfSize:15];
        numLabel.textColor = CharacterColor2;
        _numLabel = numLabel;
        [self.contentView addSubview:numLabel];

        
        
        UILabel  *borderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN.width*0.3 + 19.5, SCREEN.width, 0.5)];
        borderLabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:borderLabel];
        
    }
    return self;
}

- (void)setModel:(PurchaseCarModel *)model{

    _model = model;
    [_image sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:nil];
    _nameLabel.text = _model.productName;
    _priceLabel.text = [NSString stringWithFormat:@"¥%@",_model.price];
    _numLabel.text = [NSString stringWithFormat:@"×%@",_model.total];
    NSString *total = _model.total;
    float floatTotal = [total floatValue];
    [_plainStepper setValue:floatTotal];

}
#pragma mark--点击button
- (void)selectBtnClick{

    if (_ifSlected == YES) {
        //选中变为不选中
        _ifSlected = NO;
        _model.ifSlect = NO;
        [_circleImage setImage:[UIImage imageNamed:@"圆圈"]];
        [self.delegate ChangeSubBtnState];
    }else{
    //不选中变为选中
        _ifSlected = YES;
        _model.ifSlect = YES;
        [_circleImage setImage:[UIImage imageNamed:@"红色对号"]];
        [self.delegate ChangeSubBtnState];

    }

}

#pragma mark--PKYStepperDelegate

- (void)numChange{
    NSString *valueStr = [NSString stringWithFormat:@"%.0f",_plainStepper.value];
    _model.total = valueStr;
    _numLabel.text = [NSString stringWithFormat:@"×%@",_model.total];
    [self.delegate ChangeMoneyAndAmount];//改变总价格和数量
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
