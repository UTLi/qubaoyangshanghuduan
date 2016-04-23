//
//  ServeCell.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/19.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "ServeCell.h"
#import "serveNoteModel.h"
@implementation ServeCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
 
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width / 2, self.frame.size.height)];
        dateLabel.textColor = CharacterColor2;
        dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel = dateLabel;
        [self addSubview:dateLabel];
        
        UILabel * metersLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.width/2, 0, SCREEN.width/2 - 50, self.frame.size.height)];
        metersLabel.textAlignment = NSTextAlignmentRight;
        metersLabel.textColor = CharacterColor2;
        _metersLabel = metersLabel;
        [self addSubview:metersLabel];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(metersLabel.frame) + 10, self.frame.size.height/3, 1, self.frame.size.height/3)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        
        UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0 , self.frame.size.height- 0.5, SCREEN.height, 0.5)];
        line2.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line2];
        
        
    }
    return self;
}

- (void)setModel:(serveNoteModel *)model{
    _model = model;
    _dateLabel.text =  [NSString stringWithFormat:@"  %@",model.createDate];
    _metersLabel.text = [NSString stringWithFormat:@"%@",model.distance];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
