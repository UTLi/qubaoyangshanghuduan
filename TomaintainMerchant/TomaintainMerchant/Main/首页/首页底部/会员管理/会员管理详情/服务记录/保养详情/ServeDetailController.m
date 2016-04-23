//
//  ServeDetailController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/19.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "ServeDetailController.h"
#import "ServeTopModel.h"
#import "serveTopView.h"
@interface ServeDetailController ()
{
    NSDictionary *_datas;
}
@end

@implementation ServeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"保养详情";
    [self addLetfBarAndDismissToLastWithTarget];
    self.view.backgroundColor = [UIColor whiteColor];
    [self downLoadData];
    
}

#pragma mark--设置顶部View
- (void)setTopView{

    serveTopView *topView = [[serveTopView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.width, 144)];

    topView.model = _topModel;
    NSString *date = [_datas objectForKey:@"createDate"];
    topView.dateLabel.text = [NSString stringWithFormat:@"    %@",date];
    topView.dateLabel.textColor = CharacterColor2;
    NSString *distance = [_datas objectForKey:@"distance"];
    topView.meterLabel.text = [NSString stringWithFormat:@"%@公里    ",distance];
    topView.meterLabel.textColor = CharacterColor2;
    [self.view addSubview:topView];

   UITextView* label=[[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(topView.frame), SCREEN.width - 20, SCREEN.height - topView.frame.size.height)];;
    label.editable=NO;
    label.textColor = CharacterColor1;
    label.font = [UIFont systemFontOfSize:15];
    label.text = [_datas objectForKey:@"item"];
    [self.view addSubview:label];
    
}

#pragma mark--下载数据
- (void)downLoadData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString * urlStr = [NSString stringWithFormat:@"%@?detailId=%@&token=%@",maintainDetail,_detailId,token];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager GET: urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self removeFailesImage];
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *judjeStr = [dic objectForKey:@"note"];
        
        if ([judjeStr isEqualToString:@"SUCCESS"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            _datas = result;
            [self setTopView];

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
//            [_tableView reloadData];
        
        }else{
            //重新登录
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self loadFailedWithImage];
        
    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
