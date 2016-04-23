//
//  ServeNoteController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/18.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "ServeNoteController.h"
#import "serveNoteModel.h"
#import "ServeTopModel.h"
#import "serveTopView.h"
#import "ServeCell.h"
#import "ServeDetailController.h"
@interface ServeNoteController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *_autoDic;
    NSMutableArray *_datas;
    UITableView *_tableView;
    ServeTopModel *_topMode;;
}
@end

@implementation ServeNoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"保养记录";
    _datas = [NSMutableArray array];
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 144, SCREEN.width, SCREEN.height - 144) style:UITableViewStylePlain];
    [self.view addSubview:table];
    _tableView = table;
    [_tableView registerClass:[ServeCell class] forCellReuseIdentifier:@"ServeCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //去掉分割线
    _tableView.separatorStyle = NO;
    [self addLetfBarAndDismissToLastWithTarget];
    self.view.backgroundColor = [UIColor whiteColor];
    [self downLoadData];
}

#pragma mark--设置顶部view
- (void)setTopView{
    serveTopView *topView = [[serveTopView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.width, 144)];
    ServeTopModel *model =  [[ServeTopModel alloc]init];
    [model setValuesForKeysWithDictionary:_autoDic];
    _topMode = model;
    topView.model = model;
    [self.view addSubview:topView];


}


#pragma mark--下载数据
- (void)downLoadData{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString * urlStr = [NSString stringWithFormat:@"%@?autoId=%@&token=%@",maintainList,_autoId,token];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager GET: urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *judjeStr = [dic objectForKey:@"note"];
        [_tableView removeFailesImage];

        if ([judjeStr isEqualToString:@"SUCCESS"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSDictionary *autoDic = [result objectForKey:@"auto"];
            _autoDic = autoDic;
            [self setTopView];
            NSArray *arr = [result objectForKey:@"detailArray"];
                      for (int i = 0; i < arr.count; i++) {
                NSDictionary *dictionary = arr[i];
                serveNoteModel *serveModel = [[serveNoteModel alloc]init];
                [serveModel setValuesForKeysWithDictionary:dictionary];
                [_datas addObject:serveModel];
            }
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
 
        [self loadFailedWithImage];
        
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

    static NSString *ID = @"ServeCell";
    ServeCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ServeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.model = _datas[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    serveNoteModel *model = _datas[indexPath.row];
    NSString *detailId = [NSString stringWithFormat:@"%@",model.detailId];
    ServeDetailController *serDVC = [[ServeDetailController alloc]init];
    serDVC.topModel = _topMode;
    serDVC.detailId = detailId;
    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:serDVC];
    [self presentViewController:Nav animated:YES completion:nil];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 44;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
