//
//  CommentController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/16.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "CommentController.h"
#import "CommentCell.h"
#import "CommentModel.h"
#define GAP 10
#define Font [UIFont systemFontOfSize:18]

@interface CommentController ()
{
    UITableView *_tableView;
    int _pageNo;//分页
    NSMutableArray *_datas;
    
}
@end

@implementation CommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论管理";
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self addLetfBarAndDismissToLastWithTarget];
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"CommentCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _datas = [NSMutableArray array];
    _pageNo = 1;
    //去掉分割线
    self.tableView.separatorStyle = NO;
    [self CreatRefresh];
    //上拉加载
    [self footerRereshing];
    [self downloadDataandUp:YES];

}

#pragma mark--下拉刷新
- (void)CreatRefresh{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    __weak __typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _pageNo = _pageNo + 1;
        [weakSelf downloadDataandUp:NO];
    }];
}

#pragma mark--下载数据
-(void)downloadDataandUp:(BOOL)Up {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId	 = [defaults objectForKey:@"stationId"];
    NSString * urlStr = [NSString stringWithFormat:@"%@?stationId=%@&pageNum=%d&token=%@",commentList,stationId,_pageNo,token];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
                NSDictionary *dictionary = arr[i];
                CommentModel *commentModel = [[CommentModel alloc]init];
                [commentModel setValuesForKeysWithDictionary:dictionary];
                [_datas addObject:commentModel];
            }
            //             [_tableView removeFailesImage];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            [self.tableView reloadData];
            
        }else{
            //重新登录
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //      [UIAlertController showWithTitle:@"网络异常" AfterDismissWithTime:1.0 RootVC:self];
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if (_datas.count<=0)
        {
            //[self.tableView loadFailedWithImage];
            [self loadFailedWithImage];
        }
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _datas.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"CommentCell";
    CommentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.model = _datas[indexPath.row];
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    CommentModel *model = _datas[indexPath.row];
    //计算尺寸
    NSString *s = model.content;
    //设置一个行高上限
    CGSize size = CGSizeMake(SCREEN.width - 3 * 10 - 60,MAXFLOAT);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize = [self sizeWithText:s font:Font maxSize:size];
    return labelsize.height + 55;
}

//算尺寸方法
- (CGSize)sizeWithText:(NSString*)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return  [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}



@end
