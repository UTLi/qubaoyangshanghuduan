//
//  ServerModel.h
//  Tomaintain
//
//  Created by iOS on 15/8/5.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerModel : NSObject

@property(nonatomic,retain)NSString * serverTitle;
-(instancetype)initWithServerTitle:(NSString *)serverTitle;

@end
