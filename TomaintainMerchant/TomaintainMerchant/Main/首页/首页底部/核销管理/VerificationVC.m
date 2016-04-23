//
//  VerificationVC.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/1/28.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "VerificationVC.h"
#import "LoginViewController.h"
@interface VerificationVC ()<UITextFieldDelegate>
{
    UITextField *_verificationTex;//核销码
    UILabel *_numLabel;//订单编号
    UILabel *_mobilLabel;//手机号码
    UILabel *_timeLabel;//下单时间
    NSDictionary *_dic;//数据
    NSDictionary *_cancelDic;//数据

}
@end

@implementation VerificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"核销管理";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addLetfBarAndDismissToLastWithTarget];//添加返回按钮
    [self setUI];
    

}


-(void)setUI{
    //核销码输入框
    UITextField *verificationTex = [[UITextField alloc]initWithFrame:CGRectMake(10, 20 + 64, (SCREEN.width - 25)/4.5*3.5, 50)];
    [self.view addSubview:verificationTex];
    verificationTex.backgroundColor = RGColor(234, 235, 238);
    verificationTex.layer.cornerRadius = 5;
    verificationTex.placeholder = @"  请输入核销码";
    verificationTex.delegate = self;
    [verificationTex setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:20.00]];
    _verificationTex = verificationTex;
    //查询按钮
    UIButton *inquiryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    inquiryBtn.frame = CGRectMake(CGRectGetMaxX(verificationTex.frame) + 5, 20 + 64, (SCREEN.width - 25)/4.5, 50);
    inquiryBtn.backgroundColor = RGColor(97, 49, 163);
    inquiryBtn.layer.cornerRadius=5.0f;
    [inquiryBtn setTitle:@"查询" forState:UIControlStateNormal];
    inquiryBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    inquiryBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [inquiryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [inquiryBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [inquiryBtn addTarget:self action:@selector(inquiryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inquiryBtn];

   //订单编号
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(verificationTex.frame)+20, SCREEN.width/3.5, 40)];
    numLabel.text = @"订单编号：";
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:numLabel];
    
    UILabel *numShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame)+10,CGRectGetMaxY(verificationTex.frame)+20, SCREEN.width/1.8, 40)];
    numShowLabel.textColor = CharacterColor2;
    numShowLabel.layer.borderWidth  = 1.0f;
    numShowLabel.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    numShowLabel.layer.cornerRadius = 5.0f;
    numShowLabel.textAlignment = NSTextAlignmentLeft;
    numShowLabel.font = [UIFont systemFontOfSize:18];
    _numLabel = numShowLabel;
    [self.view addSubview:numShowLabel];
    
    //手机号码
    UILabel *mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(numLabel.frame)+20, SCREEN.width/3.5, 40)];
    mobileLabel.text = @"手机号码：";
    mobileLabel.textAlignment = NSTextAlignmentCenter;
    mobileLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:mobileLabel];
    
    UILabel *mobileShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame)+10,CGRectGetMaxY(numLabel.frame)+20, SCREEN.width/1.8, 40)];
    mobileShowLabel.textColor = CharacterColor2;
    mobileShowLabel.layer.borderWidth  = 1.0f;
    mobileShowLabel.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    mobileShowLabel.layer.cornerRadius = 5.0f;
    mobileShowLabel.textAlignment = NSTextAlignmentLeft;
    mobileShowLabel.font = [UIFont systemFontOfSize:18];
    _mobilLabel = mobileShowLabel;
    [self.view addSubview:mobileShowLabel];
    
    //下单时间
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(mobileLabel.frame)+20, SCREEN.width/3.5, 40)];
    timeLabel.text = @"下单时间：";
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:timeLabel];
    
    UILabel *timeShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame)+10,CGRectGetMaxY(mobileLabel.frame)+20, SCREEN.width/1.8, 40)];
    timeShowLabel.textColor = CharacterColor2;
    timeShowLabel.layer.borderWidth  = 1.0f;
    timeShowLabel.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    timeShowLabel.layer.cornerRadius = 5.0f;
    timeShowLabel.textAlignment = NSTextAlignmentLeft;
    timeShowLabel.font = [UIFont systemFontOfSize:18];
    _timeLabel = timeShowLabel;
    [self.view addSubview:timeShowLabel];


    //确认核销
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(10 , CGRectGetMaxY(timeLabel.frame)+30, SCREEN.width - 20, 50);
    confirmBtn.backgroundColor = RGColor(97, 49, 163);
    confirmBtn.layer.cornerRadius=5.0f;
    [confirmBtn setTitle:@"确认核销" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    confirmBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [confirmBtn addTarget:self action:@selector(confirmBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];

    
}


#pragma mark--点击查询
-(void)inquiryBtnClick{

    
    //   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *code = _verificationTex.text;
    NSString *urlStr = [NSString stringWithFormat:@"%@?code=%@&token=%@",verification,code,token];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [ manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSString *judjeStr = [dic objectForKey:@"note"];
         
         if ([judjeStr isEqualToString:@"SUCCESS"]) {
             NSDictionary *dic2 = [dic objectForKey:@"result"];
             _dic = dic2;
             NSString *checkMsg = [_dic objectForKey:@"checkMsg"];
             if ([checkMsg isEqualToString:@"1"]) {
                 //校检成功
                 [self refreshData];

             }else{
               //校检失败
             [UIAlertController showWithTitle:@"查询失败请输入正确的核销码" AfterDismissWithTime:1.0 RootVC:self];
             
             }
         }else{
             //重新登录
             LoginViewController *loginVC = [[LoginViewController alloc]init];
             [self presentViewController:loginVC animated:YES completion:nil];
             
         }
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [UIAlertController showWithTitle:@"网络连接失败" AfterDismissWithTime:1.0 RootVC:self];
     }];

    
}
#pragma mark--刷新数据
-(void)refreshData{
    _numLabel.text = [_dic objectForKey:@"orderNum"];
    _mobilLabel.text = [_dic objectForKey:@"mobile"];
    _timeLabel.text = [_dic objectForKey:@"createDate"];

}

#pragma mark--点击确认核销

-(void)confirmBtnBtnClick{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    NSString *code = _verificationTex.text;
    NSString *source = [_dic objectForKey:@"source"];
    NSString *orderNum = [_dic objectForKey:@"orderNum"];
    NSDictionary *parameters =@{@"code":code ,
                                @"source":source ,
                                @"orderNum":orderNum ,
                                @"stationId":stationId ,
                                @"token":token
                                };
   
    NSString *urlStr = cancelOrder;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [ manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *judjeStr = [responseObject objectForKey:@"note"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([judjeStr isEqualToString:@"SUCCESS"]) {
            NSDictionary *dic2 = [responseObject objectForKey:@"result"];
            _cancelDic = dic2;
            NSString *checkStatus = [_cancelDic objectForKey:@"checkStatus"];
            if ([checkStatus isEqualToString:@"1"]) {
                //核销成功
                [UIAlertController showWithTitle:@"核销成功" AfterDismissWithTime:1.0 RootVC:self];
                
            }else{
                //核销失败
                [UIAlertController showWithTitle:@"核销失败" AfterDismissWithTime:1.0 RootVC:self];
            }
        }else{
            //重新登录
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        [UIAlertController showWithTitle:@"网络连接失败" AfterDismissWithTime:1.0 RootVC:self];
    }];
    


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
