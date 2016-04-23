//
//  TodaySaleController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/1.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "TodaySaleController.h"
#import "ProductsCell.h"
#import "ProductModel.h"
#import "PurchaseCarController.h"
@interface TodaySaleController ()<UITableViewDataSource,UITableViewDelegate,ProductsCellDelegate>

{
    UITableView *_tableView;
    int _pageNo;//分页
    NSDictionary *_dic;
    UILabel *_redLabel;//购物车红点

}
@property (nonatomic, strong) NSMutableArray *datas;


@end

@implementation TodaySaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日特惠";
    //注册Cell,设置tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, SCREEN.height) style:UITableViewStylePlain];
    _tableView = tableView;
    [_tableView registerClass:[ProductsCell class] forCellReuseIdentifier:@"ProductsCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _datas = [NSMutableArray array];
    _pageNo = 1;
    //去掉分割线
//    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
    [self addLetfBarAndDismissToLastWithTarget];
    //rightBarButtonItem购物车按钮
    UIBarButtonItem *RightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"购物车"] style:UIBarButtonItemStyleDone target:self action:@selector(RightBtnClickBack)];
    self.navigationItem.rightBarButtonItem = RightBtn;
    [self CreatRefresh];
    //上拉加载
    [self footerRereshing];
    [self downloadDataandUp:YES];
    

    //购物车红点
    [self setRedLabel];
    
}


#pragma mark--设置购物车红点
- (void)setRedLabel{
    UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.width - 20  ,5, 12 , 12)];
    redLabel.layer.masksToBounds = YES;
    redLabel.layer.cornerRadius = 6;
    redLabel.backgroundColor = [UIColor redColor];
    redLabel.font = [UIFont systemFontOfSize:8];
    redLabel.textColor =[UIColor whiteColor];
    redLabel.textAlignment = NSTextAlignmentCenter;
    _redLabel = redLabel;
    [self.navigationController.navigationBar addSubview:redLabel];
//    [self.navigationItem addSubview:redLabel];
    //    _redLabel.hidden = YES;
    [self setRedLabelNum];
}
#pragma mark--设置购物车红点数据

- (void)setRedLabelNum{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlStr = [NSString stringWithFormat:@"%@?stationId=%@&token=%@",cartCount,stationId,token];
    [manager GET: urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        NSDictionary *dic = responseObject;
        NSString *judjeStr = [dic objectForKey:@"note"];
        if ([judjeStr isEqualToString:@"SUCCESS"]) {
            NSString *result = [dic objectForKey:@"result"];
            _redLabel.text = [NSString stringWithFormat:@"%@",result];
        }else{
            //重新登录
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
}

#pragma mark--点击购物车
- (void)RightBtnClickBack{
    PurchaseCarController *carVC = [[PurchaseCarController alloc]init];
    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:carVC];
    [self presentViewController:Nav animated:YES completion:nil];

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
    NSString * urlStr = [NSString stringWithFormat:@"%@?pageNum=%d&token=%@",todaySale,_pageNo,token];
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
           NSArray *arr = [dic objectForKey:@"result"];
             if (Up == YES) {
                 //YES是下拉刷新移除所有数据
                 [_datas removeAllObjects];
             }
            
             for (int i = 0; i < arr.count; i++) {
                 NSDictionary *dictionary = arr[i];
                 ProductModel *proModel = [[ProductModel alloc]init];
                 [proModel setValuesForKeysWithDictionary:dictionary];
                 [_datas addObject:proModel];
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





#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ProductsCell";
    ProductsCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ProductsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.model = _datas[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return SCREEN.width*0.3 + 20;
}


#pragma mark--ProductsCellDelegate

-(void)addToPurchasCarWithProductId:(NSString *)productId{
    
    //加入购物车
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    
    NSDictionary *parameters = @{@"stationId":stationId,
                                 @"productId":productId,
                                 @"token":token,
                                 };
    NSLog(@"%@",parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [ manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:add1Product parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        NSString *judjeStr = [dic objectForKey:@"note"];
        
        if ([judjeStr isEqualToString:@"SUCCESS"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSString *code = [result objectForKey:@"code"];
            NSString *msgbody = [result objectForKey:@"msgbody"];
            if ([code isEqualToString:@"1000"]) {
                //成功
                //                NSLog(@"%@",msgbody);
                [self setRedLabelNum];
            }else{
                //失败
                [UIAlertController showWithTitle:@"网络异常" AfterDismissWithTime:1.0 RootVC:self];
                
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
        [UIAlertController showWithTitle:@"网络异常" AfterDismissWithTime:1.0 RootVC:self];
        [self loadFailedWithImage];
        
    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
