//
//  AppointmentController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/2.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "AppointmentController.h"
#import "OrderModel.h"
#import "OrderHeaderView.h"
#import "OrderCell.h"
@interface AppointmentController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITextField *_serchTex;//订单编号手机号
    NSString *_queryInfo;//查询条件
    UIView *_searchView;
    UITableView* _tableView;
    int _pageNo;
}
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation AppointmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约管理";
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, SCREEN.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    [self.view addSubview:tableView];
    _datas = [NSMutableArray array];
    _pageNo = 1;
    _queryInfo = @"";
    [self addLetfBarAndDismissToLastWithTarget];
    [self CreatRefresh];
    [self footerRereshing];
    [self downloadDataandUp:YES];
    //自定义组头
    [_tableView registerClass:[OrderHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
    //注册cell
    [_tableView registerClass:[OrderCell class] forCellReuseIdentifier:@"OrderCell1"];
    [_tableView registerClass:[OrderCell class] forCellReuseIdentifier:@"OrderCell2"];
    [_tableView registerClass:[OrderCell class] forCellReuseIdentifier:@"OrderCell3"];
    [_tableView registerClass:[OrderCell class] forCellReuseIdentifier:@"OrderCell4"];

    //rightBarButtonItem搜索按钮
    UIBarButtonItem *RightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"搜索"] style:UIBarButtonItemStyleDone target:self action:@selector(RightBtnClickBack)];
    self.navigationItem.rightBarButtonItem = RightBtn;
    //创建搜索框
    [self CreatSerchBar];



}

#pragma mark--下拉刷新
- (void)CreatRefresh{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _pageNo = 1;
        //        [weakSelf removeFailesImage];
        [weakSelf downloadDataandUp:YES];
    }];
}
#pragma mark--上拉加载
- (void)footerRereshing{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNo = _pageNo + 1;
        [weakSelf downloadDataandUp:NO];
    }];
}




#pragma mark--下载数据
-(void)downloadDataandUp:(BOOL)Up {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    NSString *queryType = @"0";
    NSString * urlStr = [NSString stringWithFormat:@"%@?stationId=%@&queryInfo=%@&pageNum=%d&token=%@&queryType=%@",historyOrder,stationId,_queryInfo,_pageNo,token,queryType];
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
            if (Up == YES) {
                //YES是下拉刷新移除所有数据
                [_datas removeAllObjects];
            }
            for (int i = 0; i < arr.count; i++) {
                NSDictionary *orderDic = arr[i];
//                NSLog(@"%@",orderDic);
                OrderModel *orderModel = [[OrderModel alloc]init];
                [orderModel setValuesForKeysWithDictionary:orderDic];
                [_datas addObject:orderModel];

            }
            //             [_tableView removeFailesImage];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [_tableView.header endRefreshing];
            [_tableView.footer endRefreshing];
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
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        if (_datas.count<=0)
        {
            //[self.tableView loadFailedWithImage];
            [self loadFailedWithImage];
        }
        
    }];
}


#pragma mark--自定义组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString * const OrderHeaderId = @"header";
    OrderHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OrderHeaderId ];
    header.model = _datas[section];
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    OrderModel *model = _datas[section];
    if ([model.source isEqualToString:@"1"]) {
        return 2;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderModel *model = _datas[indexPath.section];
      if ([model.source isEqualToString:@"0"]) {
        if (indexPath.row == 0) {
            static NSString *ID1 = @"OrderCell1";
            OrderCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID1];
            if (cell == nil) {
                cell = [[OrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID1];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.leftLabel.text = @"预约时间：";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@",model.orderDate];
            return cell;

        }else if (indexPath.row == 1){
            static NSString *ID2 = @"OrderCell2";
            OrderCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID2];
            if (cell == nil) {
                cell = [[OrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID2];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.leftLabel.text = @"服务项目：";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@",model.serviceItems];
            return cell;

        }else if (indexPath.row == 2){
            static NSString *ID3 = @"OrderCell3";
            OrderCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID3];
            if (cell == nil) {
                cell = [[OrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID3];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.leftLabel.text = @"联 系 人：";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@",model.userName];
            return cell;

        }else {
            static NSString *ID4 = @"OrderCell4";
            OrderCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID4];
            if (cell == nil) {
                cell = [[OrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID4];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.leftLabel.text = @"联系电话：";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@",model.mobile];
            return cell;
        }

    }else {
        if (indexPath.row == 1){
            static NSString *ID3 = @"OrderCell3";
            OrderCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID3];
            if (cell == nil) {
                cell = [[OrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID3];
                   }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.leftLabel.text = @"联 系 人 ：";
        cell.rightLabel.text = [NSString stringWithFormat:@"%@",model.userName];
        return cell;
        }else {
            static NSString *ID4 = @"OrderCell4";
            OrderCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID4];
            if (cell == nil) {
                cell = [[OrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID4];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.leftLabel.text = @"联系电话：";
            cell.rightLabel.text = [NSString stringWithFormat:@"%@",model.mobile];
            return cell;
        }
        
    }
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 40;
}

#pragma mark--CreatSerchBar
- (void)CreatSerchBar{
    //创建搜索框
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, SCREEN.height)];
    view.backgroundColor = RGColor(231, 232, 234);
    _searchView = view;
    [self.view addSubview:view];
    _searchView.hidden = YES;
    UIImage *image = [UIImage imageNamed:@"订单电话"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 260, SCREEN.width - 160, (SCREEN.width - 160)/2)];
    [imageView setImage:image];
    [_searchView addSubview:imageView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width,90)];
    topView.backgroundColor = RGColor(92, 44, 160);
    [view addSubview:topView];
    //输入框
    UITextField *serchTex = [[UITextField alloc]initWithFrame:CGRectMake(10, 25 , SCREEN.width - 60, 50)];
    [topView addSubview:serchTex];
    serchTex.backgroundColor = RGColor(70, 20, 135);
    serchTex.layer.cornerRadius = 7;
    serchTex.placeholder = @"  搜索订单编号/手机号码";
    [serchTex setValue:RGColor(96, 46, 165) forKeyPath:@"_placeholderLabel.textColor"];
    serchTex.textColor =[UIColor whiteColor];
    serchTex.delegate = self;
    [serchTex setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:20.00]];
    _serchTex = serchTex;
    //查询按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(CGRectGetMaxX(_serchTex.frame) + 10, 35, 30, 30);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"叉号"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:searchBtn];


}

#pragma mark--RightBtnClickBack

- (void)RightBtnClickBack{
    
    //点击搜索
    
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
//    [self.navigationController setToolbarHidden:YES animated:TRUE];
    _searchView.hidden = NO;
}

- (void)searchBtnClick{

    //点击查找
    
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
//    [self.navigationController setToolbarHidden:NO animated:TRUE];
    _searchView.hidden = YES;
    _queryInfo = _serchTex.text;
    [self downloadDataandUp:YES];
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
