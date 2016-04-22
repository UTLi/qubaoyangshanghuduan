//
//  OnLinePayController.m
//  Tomaintain
//
//  Created by 李沛 on 15/10/7.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import "OnLinePayController.h"
#import "PayModel.h"
#import "ImageAndText2AndImageCell.h"
#import "Text2AndImageCell.h"
#import "TwoLabelCell.h"
#import "TextAndImageViewCell.h"

#import "AFNetworking.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "UPPayPlugin.h"
#import "WXApi.h"

@interface OnLinePayController ()<UITableViewDataSource,UITableViewDelegate,UPPayPluginDelegate>
{
PayModel *_paymodle1;
PayModel *_paymodle2;
PayModel *_paymodle3;
NSString *_stationName;
float _stationID;//厂站ID
UIButton *_payButton;//支付按钮
NSString *_res;//支付宝返回数据
}
@property(nonatomic, retain) UITableView * tableView;
@property(nonatomic, retain) NSMutableArray * payArrary;
@property(nonatomic,retain) PayModel * nowPayModel;
@property(nonatomic,strong)NSString * tn;//银联订单号
@end

@implementation OnLinePayController

#pragma mark - tableView懒加载

-(NSMutableArray *)payArrary
{
    if (_payArrary==nil) {
        _payArrary=[NSMutableArray array];
    }
    return _payArrary;
}


-(UITableView *)tableView
{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, SCREEN.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线支付";
    [self addLetfBarAndDismissToLastWithTarget];
//返回通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weixinReturn) name:@"weixin" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weixinFailReturn) name:@"weixinshibai" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhifubaoReturn) name:@"zhifubao" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(zhifubaoCancel) name:@"zhifubaoreturn" object:nil];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageAndText2AndImageCell" bundle:nil] forCellReuseIdentifier:@"it2iCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoLabelCell" bundle:nil] forCellReuseIdentifier:@"TwoLabelCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextAndImageViewCell" bundle:nil] forCellReuseIdentifier:@"tiCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"Text2AndImageCell" bundle:nil] forCellReuseIdentifier:@"t2iCell"];
    //加载支付方式
    [self payArraryDataLoad];
    //创建底部支付按钮
    [self creatPayBtn];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PaySuccess) name:@"PaySuccess"  object:nil];
}
#pragma  mark --创建底部支付按钮
- (void)creatPayBtn{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 350, SCREEN.width - 40, 44)];
    _payButton = button;
    button.backgroundColor = RGColor(53, 147, 249);
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 6.0;
    [button setTitle:@"确认支付" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Pay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
 

}

#pragma  mark -- 加载支付方式
-(void)payArraryDataLoad
{
    PayModel * paymodle1=[[PayModel alloc]initWithIcon:[UIImage imageNamed:@"@2x支付宝"] bString:@"支付宝支付" sString:@"推荐已安装支付宝的用户使用" selectImage:[UIImage imageNamed:@"@2x勾选"] deselectImage:[UIImage imageNamed:@"@2x勾选2"] didSelected:NO];
    _paymodle1 = paymodle1;
    PayModel * paymodle2=[[PayModel alloc]initWithIcon:[UIImage imageNamed:@"@2x微信"] bString:@"微信支付" sString:@"推荐微信用户使用" selectImage:[UIImage imageNamed:@"@2x勾选"] deselectImage:[UIImage imageNamed:@"@2x勾选2"] didSelected:NO];
    _paymodle2 = paymodle2;
    PayModel * paymodle3=[[PayModel alloc]initWithIcon:[UIImage imageNamed:@"@2x银联"] bString:@"银联支付" sString:@"使用银行卡账号支付" selectImage:[UIImage imageNamed:@"@2x勾选"] deselectImage:[UIImage imageNamed:@"@2x勾选2"] didSelected:NO];
    _paymodle3 = paymodle3;
    [self.payArrary addObject:paymodle1];
    [self.payArrary addObject:paymodle2];
    [self.payArrary addObject:paymodle3];
}
//#pragma mark - 注册通知
//-(void)registNotification
//{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getStation:) name:StationSelect object:nil];
//}

//-(void)getStation:(NSNotification *)nc
//{
//    
//    NSDictionary * dic =  nc.userInfo;
//    Station * station = dic[@"station"];
//    _stationID = station.stationId;
//    _stationName = station.name;
//    
//    
//}

#pragma mark--UITableViewDataSourse

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 1;
    }else{
        return 3;
    }
}
#pragma mark--UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
         //实付金额
        Text2AndImageCell * cell=[tableView dequeueReusableCellWithIdentifier:@"t2iCell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.TypeLab.text=@"实付金额：";
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textlab.text = [NSString stringWithFormat:@"￥%@",_paysum];
        cell.textlab.textColor = [UIColor redColor];
        cell.backgroundColor = RGColor(252, 244, 242);
        return cell;
            
        }else if(indexPath.section == 1)
        {
         //选择支付方式
            TextAndImageViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"tiCell" forIndexPath:indexPath];
            cell.textLab.text=@"选择支付方式";
            cell.textLab.textColor = [UIColor lightGrayColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor = RGColor(235, 235, 244);
            return cell;
            
        }else{
         //支付方式
                ImageAndText2AndImageCell * cell=[tableView dequeueReusableCellWithIdentifier:@"it2iCell" forIndexPath:indexPath];
                PayModel * paymodel=[self.payArrary objectAtIndex:indexPath.row];
                cell.paytypeLab.text=paymodel.bString;
                cell.sPayTypeLab.text=paymodel.sString;
                if (paymodel.didSelected == YES ) {
                    cell.selectImageView.image = paymodel.selectImage;
                }else{
                    cell.selectImageView.image = [UIImage imageNamed:@"@2x勾选2"];
                }
                cell.payIconImageView.image = paymodel.iconImage;
                cell.payIconImageView.layer.cornerRadius = 8;
                cell.payIconImageView.layer.masksToBounds = YES;
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
              }

    }
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
                    PayModel * model=[_payArrary objectAtIndex:indexPath.row];
        
                    [self setPay:model];
    }
    }

#pragma mark--选择支付方式
-(void)setPay:(PayModel *) model
{
    
    for (int i = 0; i<_payArrary.count; i++) {
        
        
        PayModel * m=[_payArrary objectAtIndex:i];
        if ([model.bString isEqualToString:m.bString])
        {
            _nowPayModel=model;
            model.didSelected=YES;
        }else
        {
            m.didSelected=NO;
        }
        
    }
    [self.tableView reloadData];
}
#pragma mark--设置tableFooterView
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 10;
    }else{
        return 1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, 60)];
    view.backgroundColor = RGColor(235, 235, 244);
    return view;
}


#pragma  mark -- 确认支付点击事件
-(void)Pay{

    if(_nowPayModel.bString == nil){
        //未选择支付方式
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请选择支付方式" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults objectForKey:@"token"];
        if ([_nowPayModel.bString isEqual:@"支付宝支付"]) {
         //支付宝支付=====================================================================================
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 15.0f;
            [ manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            NSString *url = [NSString stringWithFormat:@"%@?orderNum=%@&payway=%@&paysum=%@&token=%@",payment,_orderNum,@"1",_paysum,token];
            [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dic = responseObject;
                NSString *judjeStr = [dic objectForKey:@"note"];
                if ([judjeStr isEqualToString:@"SUCCESS"]) {
                    NSDictionary *result = [dic objectForKey:@"result"];
                NSString *partner = [result objectForKey:@"partner"];
                NSString *seller = [result objectForKey:@"seller_id"];
                NSString *tradNO = [result objectForKey:@"out_trade_no"];
                NSString *signedString = [result objectForKey:@"sign"];
                NSString *amount = [result objectForKey:@"total_fee"];
                NSString *notifyURL = [result objectForKey:@"notify_url"];
                NSString *productName = [result objectForKey:@"subject"];
                NSString *productDescription = [result objectForKey:@"body"];
                NSString *orderSpec = [result objectForKey:@"urlCode"];
                
                if (self.finalPrice == 0.00) {
                    //如果是0元
                        _payButton.userInteractionEnabled = YES;
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        [UIAlertView pushAlertView:@"提示" message:@"支付成功" delegate:nil];
                        [self dismissViewControllerAnimated:NO completion:^{
                        [self.delegate refresh];//刷新提交订单的页面
                        }];
                   }else{
                    /*
                     *生成订单信息及签名
                     */
                    //将商品信息赋予AlixPayOrder的成员变量
                    Order *order = [[Order alloc] init];
                    order.partner = partner;
                    order.seller = seller;
                    order.tradeNO = tradNO; //订单ID（由商家自行制定）
                    order.productName = productName; //商品标题

                    order.productDescription = productDescription; //商品描述
                    order.amount = amount; //商品价格
                    order.notifyURL = notifyURL; //回调URL
                    
                    order.service = @"mobile.securitypay.pay";
                    order.paymentType = @"1";
                    order.inputCharset = @"utf-8";
                    order.itBPay = @"30m";
                    
                    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
                    NSString *appScheme = @"TomaintainMerchant";
                    
                    //将签名成功字符串格式化为订单字符串,请严格按照该格式
                    NSString *orderString = nil;
                    if (signedString != nil) {
                        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                       orderSpec, signedString, @"RSA"];
                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                            NSLog(@"reslut = %@",resultDic);
                            //检测返回数据
                            NSString *resultSting = resultDic[@"result"];
                            NSArray *resultStringArray =[resultSting componentsSeparatedByString:NSLocalizedString(@"&", nil)];
                            for (NSString *str in resultStringArray)
                            {
                                NSString *newstring = nil;
                                newstring = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                NSArray *strArray = [newstring componentsSeparatedByString:NSLocalizedString(@"=", nil)];
                                for (int i = 0 ; i < [strArray count] ; i++)
                                {
                                    NSString *st = [strArray objectAtIndex:i];
                                    if ([st isEqualToString:@"success"])
                                    {
                                        NSLog(@"%@",[strArray objectAtIndex:1]);
                                        _res = [strArray objectAtIndex:1];
                                    }
                                }
                            }
                            
                            
                            if ( [resultDic[@"resultStatus"] isEqual:@"9000"]&&[_res isEqual:@"true"]) {
                                [UIAlertView pushAlertView:@"提示" message:@"支付成功" delegate:nil];
                                [self dismissViewControllerAnimated:NO completion:^{
                                    [self.delegate refresh];
                                }];
                                
                            }else if( [resultDic[@"resultStatus"] isEqual:@"6001"]){
                                UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"您已取消支付" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
                                alterView.tag = 102;
                                [alterView show];
                            }else if([resultDic[@"resultStatus"] isEqual:@"6002"]){
                                UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"网络连接错误" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
                                alterView.tag = 102;
                                [alterView show];
                                
                            }else if ([resultDic[@"resultStatus"] isEqual:@"4000"]){
                                
                                UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"订单支付失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
                                alterView.tag = 102;
                                [alterView show];
                            }else if([resultDic[@"resultStatus"] isEqual:@"8000"]){
                                UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"正在处理中" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
                                alterView.tag = 102;
                                [alterView show];
                            }
                        }];
                    }
                }
                }else{
                    //重新登录
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    LoginViewController *loginVC = [[LoginViewController alloc]init];
                    [self presentViewController:loginVC animated:YES completion:nil];
                
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alter =  [[UIAlertView alloc]initWithTitle:@"网络连接失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
            }];
        } else if([_nowPayModel.bString isEqual:@"微信支付"]){
        //微信支付=========================================================================================
        BOOL bo =  [WXApi isWXAppInstalled];
        if (bo==YES) {
            //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self WeChatPay];
        }else
        {
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [UIAlertController showWithTitle:@"未安装微信" AfterDismissWithTime:1 RootVC:self];
        }
       
        
        }else if([_nowPayModel.bString isEqual:@"银联支付"]){ 
        //银联支付=========================================================================================
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 15.0f;
            [ manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            NSString *url = [NSString stringWithFormat:@"%@?orderNum=%@&payway=%@&paysum=%@&token=%@",payment,_orderNum,@"3",_paysum,token];
            [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *judjeStr = [responseObject objectForKey:@"note"];
                
        if ([judjeStr isEqualToString:@"SUCCESS"]) {
            NSDictionary *result = [responseObject objectForKey:@"result"];
            _tn = [result objectForKey:@"tn"];

              if (self.finalPrice == 0.00) {
                    //如果是0元
//                    _payButton.userInteractionEnabled = YES;
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [UIAlertView pushAlertView:@"提示" message:@"支付成功" delegate:nil];
                    [self dismissViewControllerAnimated:NO completion:^{
                         [self.delegate refresh];
                    }];
                }else{
                    //不是0元
                    if (_tn != nil&& _tn.length > 0) {
                        [UPPayPlugin startPay:_tn mode:@"00" viewController:self delegate:self];//发送订单
                    }else {
//                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                        _payButton.userInteractionEnabled = YES;
                        UIAlertView *alter =  [[UIAlertView alloc]initWithTitle:@"网络连接失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alter show];
                        
                    }
                }
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }else{
            //重新登录
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
            
        }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                _payButton.userInteractionEnabled = YES;
                UIAlertView *alter =  [[UIAlertView alloc]initWithTitle:@"网络连接失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
            }];
        }
    }
                    
                    
}
            
  
#pragma mark - 微信支付
    -(void)WeChatPay
    {
        //微信支付
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *token = [defaults objectForKey:@"token"];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 15.0f;
        [ manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSString *url = [NSString stringWithFormat:@"%@?orderNum=%@&payway=%@&paysum=%@&token=%@",payment,_orderNum,@"2",_paysum,token];

//        NSLog(@"%@",url);
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"%@",responseObject);
            NSString *judjeStr = [responseObject objectForKey:@"note"];
            
            if ([judjeStr isEqualToString:@"SUCCESS"]) {
                NSDictionary *result = [responseObject objectForKey:@"result"];

             if (self.finalPrice == 0.00) {
                //如果是0元
//                _payButton.userInteractionEnabled = YES;
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [UIAlertView pushAlertView:@"提示" message:@"支付成功" delegate:nil];
                [self dismissViewControllerAnimated:NO completion:^{
                    [self.delegate refresh];
                }];
            }else{
#warning ______________
                        PayReq * request=[[PayReq alloc]init];
                        request.openID=@"wx4218279185d72b60";//wxdbd7217dd10c4865
                        request.partnerId = result[@"partnerId"];//商户ID
                        request.prepayId= result[@"prepayId"];/** 预支付订单 */
                        request.package = result[@"package"];/** 商家根据财付通文档填写的数据和签名 */
                        request.nonceStr=result[@"nonceStr"]  ;/** 随机串，防重发 */
                        request.timeStamp= [result[@"timeStamp"] intValue];/** 时间戳，防重发 */
                        request.sign= result[@"sign"];/** 商家根据微信开放平台文档对数据做的签名 */
                        BOOL bo =  [WXApi sendReq:request];
                        if (bo==NO) {
//                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                            _payButton.userInteractionEnabled = YES;
                            [UIAlertController showWithTitle:@"支付失败" AfterDismissWithTime:1 RootVC:self];
                        }
            }
            }else{
                //重新登录
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                NSLog(@"Error: %@",error);
//                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//                _payButton.userInteractionEnabled = YES;
                UIAlertView *alter =  [[UIAlertView alloc]initWithTitle:@"网络连接失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
            }];
        }
        

//==================================回调
#pragma mark--AppDele微信回调
-(void)weixinReturn{
//    _payButton.userInteractionEnabled = YES;
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    
    [self dismissViewControllerAnimated:NO completion:^{

        [self.delegate refresh];
        
    }];
    
}
-(void)weixinFailReturn
{
//    _payButton.userInteractionEnabled = YES;
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}
#pragma mark UPPayPluginResult--银联支付成功后回调
- (void)UPPayPluginResult:(NSString *)result
{
//    _payButton.userInteractionEnabled = YES;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString* msg = [NSString stringWithFormat:@"%@", result];//支付结果
    if ([msg isEqualToString:@"success"]) {
        [UIAlertView pushAlertView:@"提示" message:@"支付成功" delegate:nil];
        [self dismissViewControllerAnimated:NO completion:^{
            [self.delegate refresh];
        }];
        
    }else if ([msg isEqualToString:@"fail"]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"支付失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 102;
        [alertView show];
    }else if([msg isEqualToString:@"cancel"]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"支付已取消" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 102;
        [alertView show];
    }
    
}

#pragma mark--AppDele支付宝回调
-(void)zhifubaoReturn{
    
    
    [self dismissViewControllerAnimated:NO completion:^{
        
        
        [self.delegate refresh];
    }];
    
}
-(void)zhifubaoCancel{
    
    _payButton.userInteractionEnabled = YES;
}


//跳转入其他的App
-(void)PaySuccess{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
