//
//  PurchaseCarController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/23.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "PurchaseCarController.h"
#import "PurchaseCarCell.h"
#import "PurchaseCarModel.h"
#import "PKYStepper.h"
#import "OrderConfirmController.h"
@interface PurchaseCarController ()<UITableViewDataSource,UITableViewDelegate,PurchaseCarCellDelegate>
{
    UITableView *_tableView;
    UIButton *_subBtn;//全选Btn
    BOOL _subBtnState;//是否全选
    UIBarButtonItem *_rightBtn;//编辑按钮
    PurchaseCarCell *_cell;
    float _allMoney;//总钱数
    float _allTotal;//总数量
    UILabel *_amountLabel;//合计Label
    UIButton *_accountBtn;//结算Btn
    NSMutableString *_productStr;//商品Str

    
}
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *selectDatas;

@end

@implementation PurchaseCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结算";
    [self setBottomView];
    //注册Cell,设置tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.width, SCREEN.height - 60 - 64) style:UITableViewStylePlain];
    _tableView = tableView;
    [_tableView registerClass:[PurchaseCarCell class] forCellReuseIdentifier:@"PurchaseCarCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];
    _datas = [NSMutableArray array];
    _allMoney = 0;
    _allTotal = 0;
    //rightBarButtonItem编辑
    UIBarButtonItem *RightBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(RightBtnClickBack)];
    _rightBtn = RightBtn;
    self.navigationItem.rightBarButtonItem = RightBtn;

    [self addLetfBarAndDismissToLastWithTarget];
    [self downloadData];
}

#pragma mark--点击编辑
- (void)RightBtnClickBack{
    if ([_rightBtn.title isEqualToString:@"编辑"]) {
        //进入编辑状态
        
        [_rightBtn setTitle:@"完成"];
       
        for (NSIndexPath* i in [_tableView indexPathsForVisibleRows])
        {
            PurchaseCarCell *cell = [_tableView cellForRowAtIndexPath:i];
            cell.numLabel.hidden = YES;
            cell.plainStepper.hidden = NO;
     
        }
//        [_tableView reloadData];
        
    }else{
        //进入完成状态
       [_rightBtn setTitle:@"编辑"];
        for (NSIndexPath* i in [_tableView indexPathsForVisibleRows])
        {
            PurchaseCarCell *cell = [_tableView cellForRowAtIndexPath:i];
            cell.numLabel.hidden = NO;
            cell.plainStepper.hidden = YES;
            
        }
        //上传数据
        [self pushDatas];

    }

}
#pragma mark--上传购物车数据
- (void)pushDatas{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    _productStr = [NSMutableString string];
    for (int i = 0; i < _datas.count; i++) {
        PurchaseCarModel *pro = _datas[i];
        NSString *str = [NSString stringWithFormat:@"%@:%@",pro.productId,pro.total];
        if (i == _datas.count - 1) {
            [_productStr appendFormat:@"%@",str];
        }else{
            [_productStr appendFormat:@"%@|",str];
        }
    }
    NSDictionary *parameters = @{@"stationId":stationId,
                                 @"products":_productStr,
                                 @"token":token,
                                 };
//    NSLog(@"%@",parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [ manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:addProduct parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
                NSString *judjeStr = [dic objectForKey:@"note"];
        
                if ([judjeStr isEqualToString:@"SUCCESS"]) {
                    NSDictionary *result = [dic objectForKey:@"result"];
                    NSString *code = [result objectForKey:@"code"];
                    if ([code isEqualToString:@"1000"]) {
                        //成功
                        
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


#pragma mark--设置底部View
- (void)setBottomView{
   
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN.height - 60, SCREEN.width, 60)];
    bottomView.backgroundColor = RGColor(234, 235, 236);
    [self.view addSubview:bottomView];
    
    UIButton *subBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 20, 20)];
    [subBtn.layer setMasksToBounds:YES];
    [subBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [subBtn setBackgroundImage:[UIImage imageNamed:@"红色对号"] forState:UIControlStateNormal];
    _subBtnState = YES;//是全选状态
    [subBtn addTarget:self action:@selector(subBtnClick) forControlEvents:UIControlEventTouchUpInside];
    if ((_subBtnState = YES)) {
        //全选状态
        [subBtn setBackgroundImage:[UIImage imageNamed:@"红色对号"] forState:UIControlStateNormal];

    }else{
        [subBtn setBackgroundImage:[UIImage imageNamed:@"圆圈"] forState:UIControlStateNormal];
    }
    _subBtn = subBtn;
    [bottomView addSubview:subBtn];
    UILabel *selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(subBtn.frame) + 10, 20, 40, 20)];
    selectLabel.text = @"全选";
    selectLabel.font = [UIFont systemFontOfSize:15];
    selectLabel.textAlignment = NSTextAlignmentLeft;
    selectLabel.textColor = CharacterColor2;
//    selectLabel.backgroundColor = [UIColor cyanColor];
    [bottomView addSubview:selectLabel];
    
    UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(selectLabel.frame) + 10, 20, 110, 20)];
    amountLabel.textAlignment = NSTextAlignmentLeft;
    amountLabel.textColor = CharacterColor2;
    amountLabel.font = [UIFont systemFontOfSize:15];
    _amountLabel = amountLabel;
    [bottomView addSubview:amountLabel];
    
    UIButton *accountBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_amountLabel.frame) + 10, 10, SCREEN.width - 50 - 20 - 40 - 110, 40)];
    [accountBtn.layer setMasksToBounds:YES];
    accountBtn.font = [UIFont systemFontOfSize:15];
    [accountBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    accountBtn.backgroundColor = [UIColor redColor];
    [accountBtn addTarget:self action:@selector(accountBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [accountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _accountBtn = accountBtn;

    [bottomView addSubview:accountBtn];
    
    
}

#pragma mark--accountBtnClick点击去结算
- (void)accountBtnClick{
    OrderConfirmController *orderConfirmVC = [[OrderConfirmController alloc]init];
    orderConfirmVC.allMoney = _allMoney;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0 ; i < _datas.count; i++) {
        PurchaseCarModel *model = _datas[i];
        if (model.ifSlect == YES) {
            [arr addObject:model];
        }
    }
  
    orderConfirmVC.dataArr = arr;
    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:orderConfirmVC];
    
    [self presentViewController:Nav animated:YES completion:nil];

}

#pragma mark--点击全选
- (void)subBtnClick{
  
    if (_subBtnState == YES) {
        _subBtnState = NO;
        [_subBtn setBackgroundImage:[UIImage imageNamed:@"圆圈"] forState:UIControlStateNormal];
        //改变选中状态
        for (NSIndexPath* i in [_tableView indexPathsForVisibleRows])
        {
            PurchaseCarCell *cell = [_tableView cellForRowAtIndexPath:i];
            cell.ifSlected = NO;
           [cell.circleImage setImage:[UIImage imageNamed:@"圆圈"]];
        }
        //改变model状态
        for (int i = 0; i<_datas.count;i++ ) {
            PurchaseCarModel *model = _datas[i];
            model.ifSlect = NO;
        }
        //改变Label和Btn
        [_selectDatas removeAllObjects];
        
    }else{
        _subBtnState = YES;
        [_subBtn setBackgroundImage:[UIImage imageNamed:@"红色对号"] forState:UIControlStateNormal];
        //改变uanzhong状态
        for (NSIndexPath* i in [_tableView indexPathsForVisibleRows])
        {
            PurchaseCarCell *cell = [_tableView cellForRowAtIndexPath:i];
            cell.ifSlected = YES;
            [cell.circleImage setImage:[UIImage imageNamed:@"红色对号"]];
        }
        //改变model状态
        for (int i = 0; i<_datas.count;i++ ) {
            PurchaseCarModel *model = _datas[i];
            model.ifSlect = YES;
        }
        [_selectDatas addObjectsFromArray:_datas];

    }
    //设置Label和Btn
    [self setAmountLabelAndaccountBtn];
}

#pragma mark--PurchaseCarCellDelegate

- (void)ChangeMoneyAndAmount{

    [self setAmountLabelAndaccountBtn];
//    PurchaseCarModel *model = _datas[1];
//    NSLog(@"%@",model.total);
}

- (void)ChangeSubBtnState{
    //改变全选按钮的状态
    int sub = 0;
    for (int i = 0; i<_datas.count; i++) {
        PurchaseCarModel *model = _datas[i];
        if (model.ifSlect == YES) {
            sub = sub + 1;
        }
        
    }
    
    if (sub == _datas.count) {
        _subBtnState = YES;
        [_subBtn setBackgroundImage:[UIImage imageNamed:@"红色对号"] forState:UIControlStateNormal];
    }else{
    
        _subBtnState = NO;
        [_subBtn setBackgroundImage:[UIImage imageNamed:@"圆圈"] forState:UIControlStateNormal];
    }
//改变Label和Btn数值
    [self setAmountLabelAndaccountBtn];

}


#pragma mark--下载数据
- (void)downloadData{
    [_datas removeAllObjects];//清空数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    NSString * urlStr = [NSString stringWithFormat:@"%@?stationId=%@&token=%@",cartList,stationId,token];
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
            
            for (int i = 0; i < arr.count; i++) {
                NSDictionary *dictionary = arr[i];
                PurchaseCarModel *proModel = [[PurchaseCarModel alloc]init];
                [proModel setValuesForKeysWithDictionary:dictionary];
                 proModel.ifSlect = YES;
                [_datas addObject:proModel];
            }
            [self setAmountLabelAndaccountBtn];
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
        if (_datas.count<=0)
        {
            //[self.tableView loadFailedWithImage];
            [self loadFailedWithImage];
        }
        
    }];
}

#pragma mark--设置合计Label和去结算Btn
- (void)setAmountLabelAndaccountBtn{
    _allMoney = 0;
    _allTotal = 0;
    for (int i = 0 ; i<_datas.count; i++) {
        PurchaseCarModel *model = _datas[i];
        NSString *money = model.price;
        NSString *total = model.total;
        float moneyF = [money floatValue];
        float totalF = [total floatValue];
        if (model.ifSlect == YES) {
            _allMoney= _allMoney + moneyF * totalF;
            _allTotal = _allTotal + totalF;
        }
    }
        _amountLabel.text = [NSString stringWithFormat:@"合计¥：%.2f",_allMoney];
       [_accountBtn setTitle:[NSString stringWithFormat:@"去结算（%.0f）",_allTotal] forState:UIControlStateNormal];

    
}

#pragma mark-- 返回TableView 可以编辑的样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return UITableViewCellEditingStyleDelete;
    
}

#pragma mark--删除时调用的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PurchaseCarModel *model = _datas[indexPath.row];
    NSString *cartId = model.cartId;
    [self removeProductsWithcartId:cartId];
    // 删除数据源的源的对应行
    [_datas removeObjectAtIndex:indexPath.row];
    //刷新总价的Label和Btn
    [self ChangeMoneyAndAmount];
    // 刷新TableView
    [tableView reloadData];
}
#pragma mark--删除商品
- (void)removeProductsWithcartId:(NSString*)cartId{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [ manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *urlStr = [NSString stringWithFormat:@"%@?cartId=%@&token=%@",removeProduct,cartId,token];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *judjeStr = [dic objectForKey:@"note"];
        
        if ([judjeStr isEqualToString:@"SUCCESS"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSString *code = [result objectForKey:@"code"];
            NSString *msgbody = [result objectForKey:@"msgbody"];
            if ([code isEqualToString:@"1000"]) {
                //成功
            }else{
                //失败
                [UIAlertController showWithTitle:@"网络异常" AfterDismissWithTime:1.0 RootVC:self];
            }
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//            [self downloadData];
            
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


#pragma mark--cell 左滑删除的字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"PurchaseCarCell";
    PurchaseCarCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[PurchaseCarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.model = _datas[indexPath.row];
    cell.delegate = self;
    //设置cell选中状态
    if (cell.model.ifSlect == YES) {
        [cell.circleImage setImage:[UIImage imageNamed:@"红色对号"]];
    }else {
        [cell.circleImage setImage:[UIImage imageNamed:@"圆圈"]];
    }
    //控件显示
    if ([_rightBtn.title isEqualToString:@"编辑"]) {

            cell.numLabel.hidden = NO;
            cell.plainStepper.hidden = YES;
    }else{
            cell.numLabel.hidden = YES;
            cell.plainStepper.hidden = NO;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN.width*0.3 + 20;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
