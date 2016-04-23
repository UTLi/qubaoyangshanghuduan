//
//  ImaAndLabView.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/1/26.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "ImaAndLabView.h"
@implementation ImaAndLabView

- (id)initWithFrame:(CGRect)frame andImageName:(NSString *)imageName andlabelTex:(NSString *)labelTex andBlock:(myBlock)tapBlock
{
    self = [super initWithFrame:frame];
    if (self) {
  //  110/210 400
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width - frame.size.height/2)/2, 10, frame.size.height/2, frame.size.height/2)];
        [image setImage:[UIImage imageNamed:imageName]];
        [self addSubview:image];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 10)];
        label.text = labelTex;
        label.textColor = CharacterColor2;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.tempBlock = tapBlock;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
        [self addGestureRecognizer:singleTap];
    
    }
    return self;
}

-(void)Tap:(ImaAndLabView *)imaKabView{

    self.tempBlock(imaKabView);

}

@end
