//
//  PurchaseController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/1/25.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "PurchaseController.h"
#import "PProductsCell.h"
#import "ProductModel.h"
#import "ClassifyView.h"
#import "PurchaseCarController.h"
@interface PurchaseController ()<UITableViewDataSource,UITableViewDelegate,PProductsCellDelegate,UITextFieldDelegate,ClassifyViewDelegate>
{
    UITextField *_serchTex;//商品
    UITableView *_tableView;
    NSString *_queryInfo;//查询条件
    int _pageNo;//分页
    NSString *_catolog;//上级类别ID，（level为1时，catolog为空）
    ClassifyView *_classifyView;
    UILabel *_redLabel;//购物车红点
    PProductsCell *_cell;
}

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation PurchaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    //注册Cell,设置tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.width, SCREEN.height - 64 - 44) style:UITableViewStylePlain];
    _tableView = tableView;
    [_tableView registerClass:[PProductsCell class] forCellReuseIdentifier:@"PProductsCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _datas = [NSMutableArray array];
    _pageNo = 1;
    _queryInfo = @"";
    _catolog = @"";
    //去掉分割线
    //    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];

    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:tableViewGesture];
    [self downloadDataandUp:YES];
    self.view.userInteractionEnabled = YES;
    [self CreatRefresh];
    [self footerRereshing];
    //创建分类View
    ClassifyView *classView = [[ClassifyView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.width, SCREEN.height - 64)];
    [self.view addSubview:classView];
    _classifyView = classView;
    _classifyView.hidden = YES;
    _classifyView.delegate =self;

    //购物车红点
    [self setRedLabel];
}

#pragma mark--设置购物车红点
- (void)setRedLabel{
    UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.width - 30  ,25, 12 , 12)];
    redLabel.layer.masksToBounds = YES;
    redLabel.layer.cornerRadius = 6;
    redLabel.backgroundColor = [UIColor redColor];
    redLabel.font = [UIFont systemFontOfSize:8];
    redLabel.textColor =[UIColor whiteColor];
    redLabel.textAlignment = NSTextAlignmentCenter;
    _redLabel = redLabel;
    
    [self.view addSubview:redLabel];
    _redLabel.hidden = YES;
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
            
            if (result == 0) {
                
            }else{
                _redLabel.hidden = NO;
                _redLabel.text = [NSString stringWithFormat:@"%@",result];

            }
        }else{
            //重新登录
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];



}

- (void)tableViewTouchInSide{
    [self.view endEditing:YES];
    [_serchTex resignFirstResponder];
    if ([_serchTex.text isEqualToString:@""]) {
        
    }else {
        _queryInfo = _serchTex.text;
        [self downloadDataandUp:YES];
    }
}


#pragma mark--设置顶部View
- (void)initNavigationBar{
    [self.navigationController setNavigationBarHidden:YES];
    //分类
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN.width , 64)];
    UINavigationItem *item = [[UINavigationItem alloc]init];
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 40, 40)];
    [left setImage:[UIImage imageNamed:@"分类"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(classifyViewShow) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:left];
    [item setLeftBarButtonItem:leftButton];
    
    //搜索框

    UITextField *serchTex = [[UITextField alloc]initWithFrame:CGRectMake(0, 0 , SCREEN.width - 2 * (left.frame.size.width), 35)];
    UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"搜索紫"]];
    serchTex.leftView=imgv;
    serchTex.leftViewMode = UITextFieldViewModeAlways;
    serchTex.backgroundColor = RGColor(70, 20, 135);
    serchTex.layer.cornerRadius = 7;
    serchTex.placeholder = @"搜索商品";
    [serchTex setValue:RGColor(96, 46, 165) forKeyPath:@"_placeholderLabel.textColor"];
    serchTex.textColor =[UIColor whiteColor];
    serchTex.delegate = self;  
    [serchTex setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:18.00]];
    [item setTitleView:serchTex];
    _serchTex = serchTex;
    
    
    [self.view addSubview:bar];
    
    //购物车
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setFrame:CGRectMake(0, 0, 40, 40)];
    [right setImage:[UIImage imageNamed:@"购物车"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(purchaseCar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:right];
    [item setRightBarButtonItem:rightButton];
    [bar pushNavigationItem:item animated:NO];

}

#pragma mark--ClassifyViewDelegate
- (void)refreshTableViewWithCatolog:(NSString *)catolog{
    _catolog = catolog;
    [self downloadDataandUp:YES];
    _classifyView.hidden = YES;
  
}
#pragma mark--商品分类
- (void)classifyViewShow{
  
    [_classifyView setHidden:!_classifyView.hidden];
    

}

#pragma mark--购物车
- (void)purchaseCar{
   
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
//    _queryInfo = _serchTex.text;//查询条件
//    NSString * urlStr = [NSString stringWithFormat:@"%@?catolog=%@&queryInfo=%@&pageNum=%d&token=%@",productList,_catolog,_queryInfo,_pageNo,token];
    NSDictionary * params=@{
                            @"catolog":[NSString stringWithFormat:@"%@",_catolog],
                            @"token":[NSString stringWithFormat:@"%@",token],
                            @"queryInfo":[NSString stringWithFormat:@"%@",_queryInfo],
                            @"pageNum":[NSNumber numberWithFloat:_pageNo],
                            };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager GET: productList parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

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
    static NSString *ID = @"PProductsCell";
    PProductsCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
    _cell = cell;
    if (cell == nil) {
        cell = [[PProductsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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


#pragma mark--PProductsCellDelegate

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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//2.要实现的Delegate方法,关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.view endEditing:YES];
    if ([_serchTex.text isEqualToString:@""]) {
        
    }else {
        _queryInfo = _serchTex.text;
        [self downloadDataandUp:YES];
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
   
    [self setRedLabelNum];

}

@end
