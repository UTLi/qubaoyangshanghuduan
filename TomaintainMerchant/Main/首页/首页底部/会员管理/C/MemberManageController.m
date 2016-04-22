//
//  MemberManageController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/17.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "MemberManageController.h"
#import "MemberManageCell.h"
#import "MemberManageModel.h"
#import "MemberDetailController.h"
#import <MessageUI/MessageUI.h>
@interface MemberManageController ()<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>
{
    UITableView *_tableView;
    int _pageNo;//分页
    NSDictionary *_dic;
    UILabel *_bottomBtn;//底部按钮
    NSMutableArray *_selectIndexs; //选中的行
    NSMutableArray *_selectMobilNum;//手机号
    
}
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation MemberManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员管理";
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    //注册Cell,设置tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, SCREEN.height) style:UITableViewStylePlain];
    _tableView = tableView;
    [_tableView registerClass:[MemberManageCell class] forCellReuseIdentifier:@"MemberManageCell"];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _datas = [NSMutableArray array];
    _selectIndexs = [NSMutableArray array];
    _selectMobilNum = [NSMutableArray array];
    _pageNo = 1;
    //去掉分割线
    [self.view addSubview:_tableView];
    [self addLetfBarAndDismissToLastWithTarget];
    //rightBarButtonItem编辑
    UIBarButtonItem *RightBtn = [[UIBarButtonItem alloc]initWithTitle:@"消息" style:UIBarButtonItemStyleDone target:self action:@selector(RightBtnClickBack)];
    self.navigationItem.rightBarButtonItem = RightBtn;
    [self CreatRefresh];
    [self setBtn];
    //上拉加载
    [self footerRereshing];
    [self downloadDataandUp:YES];

}
#pragma mark--设置底部按钮
- (void)setBtn{
    UILabel *btn = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN.height - 60, SCREEN.width, 60)];
    btn.backgroundColor = RGColor(188, 196, 206);
    btn.textColor = [UIColor redColor];
    btn.textAlignment = NSTextAlignmentCenter;
    btn.text = @"发送消息(0)    ";
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap)];
    [btn addGestureRecognizer:singleTap];
    btn.userInteractionEnabled = YES;
    _bottomBtn = btn;
    [self.view addSubview:btn];
    _bottomBtn.hidden = YES;

    

}
#pragma mark--点击发送消息
- (void)labelTap{
    [_selectMobilNum removeAllObjects];
    for (int i = 0 ; i< _selectIndexs.count; i++) {
        NSIndexPath *index = _selectIndexs[i];
        MemberManageModel *model = _datas[index.row];
        [_selectMobilNum addObject:model.mobile];
    }
    NSLog(@"%@",_selectMobilNum);
    [self showMessageView:[NSArray arrayWithArray:_selectMobilNum] title:@"去保养" body:@"去保养：尊敬的客户"];

}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}


-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}





#pragma mark--点击编辑
- (void)RightBtnClickBack{
    [_selectIndexs removeAllObjects];
    [_selectMobilNum removeAllObjects];
    _bottomBtn.text = [NSString stringWithFormat:@"发送消息(%@)    ",@"0"];
    [_tableView setEditing:!_tableView.editing animated:YES];
    
    if (_tableView.frame.size.height == SCREEN.height) {
          [_tableView setFrame:CGRectMake(0, 0, SCREEN.width, SCREEN.height - 60 )];
        _bottomBtn.hidden = NO;
    }else{
    [_tableView setFrame:CGRectMake(0, 0, SCREEN.width, SCREEN.height  )];
        _bottomBtn.hidden = YES;
    }


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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    NSString * urlStr = [NSString stringWithFormat:@"%@?stationId=%@&pageNum=%d&token=%@",memberManageList,stationId,_pageNo,token];
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
                NSDictionary *dictionary = arr[i];
                MemberManageModel *memModel = [[MemberManageModel alloc]init];
                [memModel setValuesForKeysWithDictionary:dictionary];
                [_datas addObject:memModel];
            }
            [_tableView removeFailesImage];
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




#pragma mark-- TableView 支持的编辑状态
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 或符号 iOS里面的类型设置很多都是这种写法
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"MemberManageCell";
    MemberManageCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[MemberManageCell  alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.model = _datas[indexPath.row];


    return cell;
}



#pragma mark -UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_bottomBtn.hidden == YES) {
        //如果不是编辑状态
        MemberDetailController *MemberDetailVC = [[MemberDetailController alloc]init];
        MemberManageModel *model = _datas[indexPath.row];
        MemberDetailVC.userId = model.userId;
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:MemberDetailVC];
        [self presentViewController:Nav animated:YES completion:^{
            
        }];
    }else{
      //是编辑状态
      [_selectIndexs addObject:indexPath];
    _bottomBtn.text = [NSString stringWithFormat:@"发送消息（%lu）        ",(unsigned long)_selectIndexs.count];
    }
    
}

// 不选中
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_bottomBtn.hidden == NO) {
        //是编辑状态
    [_selectIndexs removeObject:indexPath];
        _bottomBtn.text = [NSString stringWithFormat:@"发送消息（%lu）        ",(unsigned long)_selectIndexs.count];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
