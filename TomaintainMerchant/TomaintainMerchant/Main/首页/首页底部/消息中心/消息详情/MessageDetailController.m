//
//  MessageDetailController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/16.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "MessageDetailController.h"
#import "MessageDetailModel.h"
#define GAP 10
#define Font [UIFont systemFontOfSize:18]

@interface MessageDetailController ()
{
    MessageDetailModel *_model;
    CGSize _lableSize;
}
@end

@implementation MessageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"消息详情";
    [self addLetfBarAndDismissToLastWithTarget];
    self.view.backgroundColor = [UIColor whiteColor];
    [self downloadData];
   
}

//设置UI
- (void)setUI{
   
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(GAP, GAP + 64, SCREEN.width - GAP * 2, 30)];
    titleLabel.text = _model.title;
    titleLabel.textColor = CharacterColor1;
    [self.view addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(GAP, CGRectGetMaxY(titleLabel.frame) + GAP, SCREEN.width - 2 * GAP, 30)];
    timeLabel.text = _model.createDate;
    timeLabel.textColor = CharacterColor2;
    [self.view addSubview:timeLabel];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLabel.frame) + GAP, SCREEN.width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(GAP, CGRectGetMaxY(line.frame), SCREEN.width - 2 * GAP , SCREEN.height - 61 - 4 * GAP - 64  )];
    [self.view addSubview:scrollView];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.contentSize = _lableSize;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [scrollView addSubview:detailLabel];
    _detailLabel = detailLabel;
    //设置自动行数与字符换行
    [detailLabel setNumberOfLines:0];
    detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [detailLabel setFrame:CGRectMake(0, GAP, _lableSize.width, _lableSize.height)];
    detailLabel.text = _model.content;
    detailLabel.font = Font;
    detailLabel.textColor = CharacterColor2;
    
}

//算尺寸方法
- (CGSize)sizeWithText:(NSString*)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return  [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


//下载数据
- (void)downloadData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    NSString * urlStr = [NSString stringWithFormat:@"%@?stationId=%@&messageId=%@&token=%@",messageDetail,stationId,_messageID,token];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager GET: urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *judjeStr = [dic objectForKey:@"note"];
        
        if ([judjeStr isEqualToString:@"SUCCESS"]) {
            NSDictionary *dictionary = [dic objectForKey:@"result"];
            MessageDetailModel *model = [[MessageDetailModel alloc]init];
            [model setValuesForKeysWithDictionary:dictionary];
            _model = model;
            //计算尺寸
            NSString *s = _model.content;
            //设置一个行高上限
            CGSize size = CGSizeMake(SCREEN.width - 2 * GAP,MAXFLOAT);
            //计算实际frame大小，并将label的frame变成实际大小
            CGSize labelsize = [self sizeWithText:s font:Font maxSize:size];
            _lableSize = labelsize;
            [self setUI];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }else{
            //重新登录
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //      [UIAlertController showWithTitle:@"网络异常" AfterDismissWithTime:1.0 RootVC:self];
            [self loadFailedWithImage];
        
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
