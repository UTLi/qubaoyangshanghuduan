//
//  ServerModel.m
//  Tomaintain
//
//  Created by iOS on 15/8/5.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import "ServerModel.h"

@implementation ServerModel

-(instancetype)initWithServerTitle:(NSString *)serverTitle
{
    if (self=[super init]) {
        self.serverTitle=serverTitle;
    }
    return self;
}
@end
