//
//  WaitOrderController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/2.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "WaitOrderController.h"
#import "OrderAllModel.h"
#import "OrderProCell.h"
#import "OrderProHeaderView.h"
#import "OrderProFooterView.h"
#import "OrderPayQuitFooterView.h"
@interface WaitOrderController ()<UITableViewDataSource,UITableViewDelegate,OrderPayQuitFooterViewDelegate>
{
    NSMutableArray *_datas;
    UITableView* _tableView;
    
}


@end

@implementation WaitOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _datas = [NSMutableArray array];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, SCREEN.height- 64 - 44) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    [self.view addSubview:tableView];
    
    //自定义组头
    [_tableView registerClass:[OrderProHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
    //自定义组尾
    [_tableView registerClass:[OrderProFooterView class] forHeaderFooterViewReuseIdentifier:@"proFooter"];
    [_tableView registerClass:[OrderPayQuitFooterView class] forHeaderFooterViewReuseIdentifier:@"payQuitFooterView"];
    
    //注册cell
    [_tableView registerClass:[OrderProCell class] forCellReuseIdentifier:@"OrderProCell"];
    [self downLoadData];


}

#pragma mark--下载数据
- (void)downLoadData{
    [_datas removeAllObjects];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    NSString * urlStr = [NSString stringWithFormat:@"%@?stationId=%@&token=%@&status=%@",orderList,stationId,token,@"0"];
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
            NSArray *arr = [dic objectForKey:@"result"];
            for (int i = 0; i < arr.count; i++) {
                NSDictionary *diction = arr[i];
                OrderAllModel *allModel = [[OrderAllModel alloc]init];
                [allModel setValuesForKeysWithDictionary:diction];
                [_datas addObject:allModel];
                
            }
            //             [_tableView removeFailesImage];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [_tableView reloadData];
            
        }else{
            //重新登录
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //      [UIAlertController showWithTitle:@"网络异常" AfterDismissWithTime:1.0 RootVC:self];
        [self loadFailedWithImage];
    }];
    
}


#pragma mark--自定义组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString * const OrderHeaderId = @"header";
    OrderProHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderHeaderId ];
    header.model = _datas[section];
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

#pragma mark--自定义组尾

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderAllModel *model = _datas[section];
    
    if ([model.status isEqualToString:@"0"]) {
        //未支付
        static NSString * const PayQuitFooterID = @"payQuitFooterView";
        OrderPayQuitFooterView *payQuitFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:PayQuitFooterID ];
        payQuitFooter.model = _datas[section];
        payQuitFooter.delegate = self;//设置代理
        return payQuitFooter;
    }else{
        
        static NSString * const proFooterId = @"proFooter";
        OrderProFooterView *proFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:proFooterId ];
        proFooter.model = _datas[section];
        return proFooter;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    OrderAllModel *model = _datas[section];
    
    if ([model.status isEqualToString:@"0"]) {
        return 90;
    }else{
        
        return 50;
    }
    
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OrderAllModel *model = _datas[section];
    //    NSArray *arr = model.productArr;
    //    NSLog(@"%lu",(unsigned long)arr.count);
    return model.productArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"OrderProCell";
    OrderProCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[OrderProCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    OrderAllModel *model = _datas[indexPath.section];
    cell.model = model.productArr[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}
#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return SCREEN.width*0.3 + 20;
}



#pragma mark--OrderPayQuitFooterViewDelegate支付|取消
- (void)payClick{
    
    
    
}

- (void)quitClickWithOrderNum:(NSString *)orderNum{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString * urlStr = [NSString stringWithFormat:@"%@?orderNum=%@&token=%@",quitOrder,orderNum,token];
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
            NSDictionary *result = [dic objectForKey:@"result"];
            NSString *code = [result objectForKey:@"code"];
            NSString *msgbody = [result objectForKey:@"msgbody"];
            if ([code isEqualToString:@"1000"]) {
                //成功
                [UIAlertController showWithTitle:msgbody AfterDismissWithTime:1.0 RootVC:self];
                [self downLoadData];
            }else{
                //失败
                [UIAlertController showWithTitle:msgbody AfterDismissWithTime:1.0 RootVC:self];
                
            }
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
