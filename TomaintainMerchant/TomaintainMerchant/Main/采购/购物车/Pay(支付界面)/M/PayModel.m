//
//  PayModel.m
//  Tomaintain
//
//  Created by iOS on 15/8/5.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import "PayModel.h"

@implementation PayModel

-(instancetype)initWithIcon:(UIImage *)iconImage bString:(NSString *)bString sString:(NSString *)sString selectImage:(UIImage *)selectImage deselectImage:(UIImage *)deselectImage didSelected:(BOOL)didSelected

{
    if (self=[super init]) {
        self.iconImage=iconImage;
        self.bString=bString;
        self.sString=sString;
        self.selectImage=selectImage;
        self.deselectImage=deselectImage;
        
    }
    return self;
}
@end
