//
//  Text2AndImageCell.h
//  Tomaintain
//
//  Created by iOS on 15/8/5.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Text2AndImageCell : UITableViewCell
//信息(服务站点/时间)
@property (weak, nonatomic) IBOutlet UILabel *textlab;
//服务类型/预约时间
@property (weak, nonatomic) IBOutlet UILabel *TypeLab;

@end
