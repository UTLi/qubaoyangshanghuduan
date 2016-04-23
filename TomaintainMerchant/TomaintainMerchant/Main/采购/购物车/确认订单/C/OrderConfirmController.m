//
//  OrderConfirmController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/7.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "OrderConfirmController.h"
#import "OrderConProCell.h"
#import "OrderConAdressCell.h"
#import "PurchaseCarModel.h"
#import "AddressModel.h"
#import "AdressController.h"
#import "OnLinePayController.h"
@interface OrderConfirmController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    AddressModel *_addressModel;
    NSMutableString *_productStr;
}
//@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation OrderConfirmController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    [self setBottomView];
    //注册Cell,设置tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.width, SCREEN.height - 44 - 64) style:UITableViewStylePlain];
    _tableView = tableView;
    [_tableView registerClass:[OrderConProCell class] forCellReuseIdentifier:@"OrderConProCell"];
    [_tableView registerClass:[OrderConAdressCell class] forCellReuseIdentifier:@"OrderConAdressCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    _productStr = [NSMutableString string];
    
    [self addLetfBarAndDismissToLastWithTarget];
    [self setBottomView];
    
    
}

#pragma mark--设置底部View
- (void)setBottomView{

    UIView *bottomView  = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN.height - 44, SCREEN.width, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    UILabel * line = [[UILabel alloc]initWithFrame: CGRectMake(0, 0, SCREEN.width/2, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line];
    
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, SCREEN.width/2, 23.5)];
    [bottomView addSubview:moneyLabel];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.textColor = CharacterColor1;
    moneyLabel.text = [NSString stringWithFormat:@"实付款：¥%.2f",_allMoney];
    UIButton *subBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN.width/2, 0, SCREEN.width/2, 44)];
    subBtn.backgroundColor = [UIColor redColor];
    [subBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [subBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [subBtn addTarget:self action:@selector(subBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:subBtn];

}

#pragma mark--点击提交订单
- (void)subBtnClick{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    NSString *amount = [NSString stringWithFormat:@"%.2f",_allMoney];
    _productStr = [NSMutableString string];
    for (int i = 0; i < _dataArr.count; i++) {
        PurchaseCarModel *pro = _dataArr[i];
        NSString *str = [NSString stringWithFormat:@"%@:%@",pro.productId,pro.total];
        if (i == _dataArr.count - 1) {
            [_productStr appendFormat:@"%@",str];
        }else{
            [_productStr appendFormat:@"%@|",str];
        }
    }
    NSDictionary *parameters = @{@"stationId":stationId,
                                 @"products":_productStr,
                                 @"token":token,
                                 @"addressId":_addressModel.addressId,
                                 @"amount":amount
                                 };
    //    NSLog(@"%@",parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [ manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:submitOrder parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSString *judjeStr = [dic objectForKey:@"note"];
        
        if ([judjeStr isEqualToString:@"SUCCESS"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSString *code = [result objectForKey:@"code"];
            NSString *msgbody = [result objectForKey:@"msgbody"];
            NSString *orderNum = [result objectForKey:@"orderNum"];
            if ([code isEqualToString:@"1000"]) {
                //成功
                NSLog(@"%@",msgbody);
                OnLinePayController *onlinePayVC = [[OnLinePayController alloc]init];
                onlinePayVC.orderNum = orderNum;
                onlinePayVC.finalPrice = _allMoney;
                onlinePayVC.paysum = [NSString stringWithFormat:@"%.2f",_allMoney];
                UINavigationController *Nav =[[UINavigationController alloc]initWithRootViewController:onlinePayVC];
                [self presentViewController:Nav animated:YES completion:nil];
            }else{
                //失败
                [UIAlertController showWithTitle:@"网络异常" AfterDismissWithTime:1.0 RootVC:self];
                
            }
            //             [_tableView removeFailesImage];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self downloadData];
            
        }else{
            //重新登录
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [UIAlertController showWithTitle:@"网络异常" AfterDismissWithTime:1.0 RootVC:self];
        [self loadFailedWithImage];
        
    }];
    


}

#pragma mark--下载数据

- (void)downloadData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    NSString * urlStr = [NSString stringWithFormat:@"%@?stationId=%@&token=%@",defaultAddress,stationId,token];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager GET: urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        NSDictionary *dic = responseObject;
        NSString *judjeStr = [dic objectForKey:@"note"];
        
        if ([judjeStr isEqualToString:@"SUCCESS"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            AddressModel *model = [[AddressModel alloc]init];
            [model setValuesForKeysWithDictionary:result];
            _addressModel = model;
            //   [_tableView removeFailesImage];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [ _tableView reloadData];
            
        }else{
            //重新登录
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //      [UIAlertController showWithTitle:@"网络异常" AfterDismissWithTime:1.0 RootVC:self];
//        if (_datas.count<=0)
//        {
//            //[self.tableView loadFailedWithImage];
//            [self loadFailedWithImage];
//        }
        
    }];


}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        static NSString *ID = @"OrderConAdressCell";
        OrderConAdressCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[OrderConAdressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.model = _addressModel;
        return cell;
    }else{
        static NSString *ID = @"OrderConProCell";
        OrderConProCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[OrderConProCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.model = _dataArr[indexPath.row -1];
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 90.5;
    }else{
    return SCREEN.width*0.3 + 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //点击地址
        AdressController *adressVC = [[AdressController alloc]init];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:adressVC];
        [self presentViewController:Nav animated:YES completion:nil];
    }

}

- (void)viewWillAppear:(BOOL)animated{

    [self downloadData];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
