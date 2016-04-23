//
//  MessageCenterController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/15.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "MessageCenterController.h"
#import "MessageModel.h"
#import "MessageCell.h"
#import "MessageDetailController.h"
@interface MessageCenterController ()<UITableViewDataSource,UITableViewDelegate>
   {
   UITableView* _tableView;
   int _pageNo;
   }
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *messageDatas;
@property (nonatomic, strong) NSMutableArray *tapDatas;


    @end

@implementation MessageCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.title = @"消息";
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, SCREEN.height) style:UITableViewStylePlain];
    _tableView = tableView;
    [_tableView registerClass:[MessageCell class] forCellReuseIdentifier:@"MessageCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //去掉分割线
    _tableView.separatorStyle = NO;
    [self.view addSubview:tableView];
    _datas = [NSMutableArray array];
    _messageDatas = [NSMutableArray array];
    _tapDatas = [NSMutableArray array];
    _pageNo = 1;
    [self addLetfBarAndDismissToLastWithTarget];
    [self CreatRefresh];
    //上拉加载
    [self footerRereshing];
    [self downloadDataandUp:YES];
    //自定义组头
//    [_tableView registerClass:[OrderHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];

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
    NSString * urlStr = [NSString stringWithFormat:@"%@?stationId=%@&pageNum=%d&token=%@",messageList,stationId,_pageNo,token];
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
//                  NSLog(@"%@",orderDic);
//                OrderModel *orderModel = [[OrderModel alloc]init];
//                [orderModel setValuesForKeysWithDictionary:orderDic];
                [_datas addObject:orderDic];
                
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


#pragma mark -- 设置组头

- ( NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *dic = _datas[section];
    NSString *str = [dic objectForKey:@"createDate"];
    return str;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _datas.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = _datas[section];
    NSArray *arr = [dic objectForKey:@"messageList"];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _datas[indexPath.section];
    NSArray *arr = [dic objectForKey:@"messageList"];
    [_messageDatas removeAllObjects];
    for (int i = 0; i < arr.count; i++) {
        MessageModel *model = [[MessageModel alloc ]init];
        [model setValuesForKeysWithDictionary:arr[i]];
        [_messageDatas addObject:model];
    }
    static NSString *ID = @"MessageCell";
    MessageCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.model = _messageDatas[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    MessageDetailController *MessageDVC = [[MessageDetailController alloc]init];
    NSDictionary *dic = _datas[indexPath.section];
    NSArray *arr = [dic objectForKey:@"messageList"];
    [_tapDatas removeAllObjects];
    for (int i = 0; i < arr.count; i++) {
        MessageModel *model = [[MessageModel alloc ]init];
        [model setValuesForKeysWithDictionary:arr[i]];
        [_tapDatas addObject:model];
    }
    MessageModel *model = _tapDatas[indexPath.row];
    NSString *MessageId = model.MessageId;
    MessageDVC.messageID = MessageId;
    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:MessageDVC];
    [self presentViewController:Nav animated:YES completion:^{
        
    }];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 80;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
