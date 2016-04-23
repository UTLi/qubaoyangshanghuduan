//
//  AdressController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/27.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "AdressController.h"
#import "AddressModel.h"
#import "AdressCell.h"
#import "AddAddressController.h"
@interface AdressController ()<UITableViewDelegate, UITableViewDataSource,AdressCellDelegate,AddAddressControllerDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic ,retain) NSMutableArray *datas;
@end

@implementation AdressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    self.view.backgroundColor = [UIColor whiteColor];
    _datas = [NSMutableArray array];
    [self addLetfBarAndDismissToLastWithTarget];
    //注册Cell,设置tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, SCREEN.height - 60) style:UITableViewStylePlain];
    _tableView = tableView;
    [_tableView registerClass:[AdressCell class] forCellReuseIdentifier:@"AdressCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    [self setBottomView];
    [self downloadData];
}
#pragma mark--设置底部View
- (void)setBottomView{
    UIButton *newAddressBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, SCREEN.height - 60, SCREEN.width - 60, 40)];
    [newAddressBtn setTitle:@"＋新建地址" forState:UIControlStateNormal];
    [newAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newAddressBtn.backgroundColor = RGColor(234, 58, 66);
    [newAddressBtn.layer setMasksToBounds:YES];
    [newAddressBtn.layer setCornerRadius:5.0];
    [newAddressBtn addTarget:self action:@selector(newAddressClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newAddressBtn];

}
#pragma mark-- 点击新建地址
- (void)newAddressClick{
    //新建收货地址
    AddAddressController *addVC = [[AddAddressController alloc]init];
    addVC.addressId = @"";
    addVC.isDefault = @"0";
    addVC.titleStr = @"添加收货地址";
    addVC.delegate = self;
    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:addVC];
    [self presentViewController:Nav animated:YES completion:nil];

   

}


#pragma mark--下载数据
-(void)downloadData {
    [_datas removeAllObjects];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    NSString * urlStr = [NSString stringWithFormat:@"%@?stationId=%@&token=%@",addressList,stationId,token];
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
//                NSDictionary *diction = arr[i];
                 AddressModel *addressModel = [[AddressModel alloc]init];
                 [addressModel setValuesForKeysWithDictionary:arr[i]];
                 [_datas addObject:addressModel];
                
            }
            //             [_tableView removeFailesImage];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [_tableView reloadData];
            
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


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"PurchaseCarCell";
    AdressCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AdressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.model = _datas[indexPath.section];
    cell.delegate = self;
//    设置cell选中状态
    if ([cell.model.isDefault isEqualToString:@"1"]) {
        [cell.circleImage setImage:[UIImage imageNamed:@"红色对号"]];
    }else {
        [cell.circleImage setImage:[UIImage imageNamed:@"圆圈"]];
    }

    
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
    
}


#pragma mark-- AdressCellDelegate

- (void)setIfDefaultWithAddressId:(NSString *)addressId{
 //设为默认
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    NSString * urlStr = [NSString stringWithFormat:@"%@?stationId=%@&id=%@&token=%@",setDefault,stationId,addressId,token];
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
            NSString *code= [result objectForKey:@"code"];
            NSString *msgbody = [result objectForKey:@"msgbody"];
            //结果码 1000：成功、1001：失败
            if ([code isEqualToString:@"1000"]) {
                //成功
                [UIAlertController showWithTitle:msgbody AfterDismissWithTime:1.0 RootVC:self];
                [self downloadData];
            }else{
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
        [self loadFailedWithImage];
    }];
    

}

- (void)EditAddressWithAddressId:(NSString *)addressId AndisDefault:(NSString *)isDefault{
    //编辑
    AddAddressController *addVC = [[AddAddressController alloc]init];
    addVC.titleStr = @"编辑收货地址";
    addVC.isDefault = isDefault;
    addVC.delegate = self;
    addVC.addressId = addressId;
    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:addVC];
    [self presentViewController:Nav animated:YES completion:nil];


}


- (void)DeletAddressWithAddressId:(NSString *)addressId{
//删除
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString * urlStr = [NSString stringWithFormat:@"%@?id=%@&token=%@",delAddress,addressId,token];
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
            NSString *code= [result objectForKey:@"code"];
            NSString *msgbody = [result objectForKey:@"msgbody"];
            //结果码 1000：成功、1001：失败
            if ([code isEqualToString:@"1000"]) {
                //成功
                [UIAlertController showWithTitle:msgbody AfterDismissWithTime:1.0 RootVC:self];
                [self downloadData];
            }else{
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
        [self loadFailedWithImage];
    }];


}
#pragma mark--AddAddressControllerDelegate
- (void)refreshVC{

    [self downloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
