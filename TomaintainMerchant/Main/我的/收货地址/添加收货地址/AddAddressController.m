//
//  AddAddressController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/29.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "AddAddressController.h"
#import "addAddressView.h"
#import "AddressDetailModel.h"
#import "AddressPickView.h"
#define viewH 44
#define lab1W (SCREEN.width - 30 )* 0.3 + 10 //label宽度
#define TFW (SCREEN.width - 30) * 0.7  //textField宽度

@interface AddAddressController ()<UITextFieldDelegate,AddressPickViewDelegate>
{
    UITextField *_nameTF;
    UITextField *_phoneTF;
    UILabel *_addressLabel;
    UITextField *_addressDetailTF;
    UITextField *_postCodeTF;
    AddressDetailModel *_detailModel;
    AddressPickView *_pickView;
    NSString *_phone;
    NSString *_code;
    NSString *_name;
    NSString *_address;
    
}
@property (nonatomic, retain) NSString *provinceCode;
@property (nonatomic, retain) NSString *cityCode;
@property (nonatomic, retain) NSString *areaCode;
@end

@implementation AddAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.titleStr;
    [self addLetfBarAndDismissToLastWithTarget];
    //rightBarButtonItem搜索按钮
    UIBarButtonItem *RightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(EditDown)];
    self.navigationItem.rightBarButtonItem = RightBtn;
    [self setUI];
    [self setPickView];
    
    UITapGestureRecognizer *viewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTouchInSide)];
    viewGesture.numberOfTapsRequired = 1;
    viewGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:viewGesture];
    
}



#pragma mark--设置UI

- (void)setUI{
    addAddressView *nameView = [[addAddressView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.width, viewH) andlabel1Str:@"收  货  人："];
    _nameTF = [[UITextField alloc]initWithFrame:CGRectMake(lab1W + 10, 0, TFW, viewH - 0.5)];
    _nameTF.textColor = CharacterColor2;
    _nameTF.delegate = self;
    [_nameTF setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:16.00]];
    [nameView addSubview:_nameTF];
    [self.view addSubview:nameView];
    
    addAddressView *phoneView = [[addAddressView alloc]initWithFrame:CGRectMake(0, 64 + viewH, SCREEN.width, viewH) andlabel1Str:@"联系方式："];
    _phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(lab1W + 10, 0, TFW, viewH - 0.5)];
    _phoneTF.textColor = CharacterColor2;
    _phoneTF.delegate = self;
    [_phoneTF setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:16.00]];
    [phoneView addSubview:_phoneTF];
    [self.view addSubview:phoneView];
    
    addAddressView *addressView = [[addAddressView alloc]initWithFrame:CGRectMake(0, 64 + viewH * 2, SCREEN.width, viewH) andlabel1Str:@"所在地区："];
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(lab1W + 10, 0, TFW, viewH - 0.5)];
    _addressLabel.textColor = RGColor(195, 195, 200);
    [_addressLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:16.00]];
    [addressView addSubview:_addressLabel];
    [self.view addSubview:addressView];
    //给 iconView添加手势]
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickViewshow)];    //点击的次数
    tapGR.numberOfTapsRequired = 1;
    [_addressLabel setUserInteractionEnabled:YES];
    //给self.view添加一个手势监测；
    [_addressLabel addGestureRecognizer:tapGR];

    
    addAddressView *addressDetailView = [[addAddressView alloc]initWithFrame:CGRectMake(0, 64 + viewH * 3, SCREEN.width, viewH) andlabel1Str:@"详情地址："];
    _addressDetailTF = [[UITextField alloc]initWithFrame:CGRectMake(lab1W + 10, 0, TFW, viewH - 0.5)];
    _addressDetailTF.textColor = CharacterColor2;
    _addressDetailTF.delegate = self;
    [_addressDetailTF setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:16.00]];
    [addressDetailView addSubview:_addressDetailTF];
    [self.view addSubview:addressDetailView];

    addAddressView *postCodeView = [[addAddressView alloc]initWithFrame:CGRectMake(0, 64 + viewH * 4, SCREEN.width, viewH) andlabel1Str:@"邮政编码："];
    _postCodeTF = [[UITextField alloc]initWithFrame:CGRectMake(lab1W + 10, 0, TFW, viewH - 0.5)];
    _postCodeTF.textColor = CharacterColor2;
    _postCodeTF.delegate = self;
    [_postCodeTF setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:16.00]];
    [postCodeView addSubview:_postCodeTF];
    [self.view addSubview:postCodeView];
    
    _nameTF.placeholder = @"请输入姓名";
    _phoneTF.placeholder = @"请输入手机号码";
    _addressLabel.text = @"请选择所在地区";
    _addressDetailTF.placeholder = @"请填写详情地址";
    _postCodeTF.placeholder = @"请输入邮政编码";
    
    if ([_titleStr isEqualToString:@"编辑收货地址"]) {
        
        [self downLoadData];
    }
}

#pragma mark--下载数据downLoadData
- (void)downLoadData{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString * urlStr = [NSString stringWithFormat:@"%@?id=%@&token=%@",addressEdit,_addressId,token];
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
            NSDictionary *result = [dic objectForKey:@"result"];
            AddressDetailModel *detailModel = [[AddressDetailModel alloc]init];
            [detailModel setValuesForKeysWithDictionary:result];
            _detailModel = detailModel;
            [self setMessage];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }else{
            //重新登录
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self loadFailedWithImage];
    }];

    
}
#pragma mark--设置信息
- (void)setMessage{
    _nameTF.placeholder = _detailModel.userName;
    _phoneTF.placeholder = _detailModel.phone;
    _addressLabel.text = [NSString stringWithFormat:@"%@%@%@",_detailModel.province,_detailModel.city,_detailModel.region];
    _addressDetailTF.placeholder = _detailModel.address;
    if ([_detailModel.code isEqualToString:@""]) {
    }else{
    _postCodeTF.placeholder = _detailModel.code;
    }
}


#pragma mark--设置PickView
- (void)setPickView{
     [self.view endEditing:YES];
    AddressPickView *pickView = [[AddressPickView alloc]initWithFrame:CGRectMake(0, SCREEN.height - 300, SCREEN.width, 200)];
    pickView.delegate = self;
    _pickView = pickView;
    [self.view addSubview:pickView];


}


#pragma mark--点击完成
- (void)EditDown{
 [self.view endEditing:YES];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    if ([_nameTF.text isEqualToString:@""]) {
        _name =_detailModel.userName;
    }else{
        _name = _nameTF.text;
    }
//    NSString *address = _addressLabel.text;

    if ([_phoneTF.text isEqualToString:@""]) {
        _phone = _detailModel.phone;
    }else{
        _phone = _phoneTF.text;
    }
    
    if ([_addressDetailTF.text isEqualToString:@""]) {
        _address = _detailModel.address;
        }else{
            _address = _addressDetailTF.text;
        }

        
    if ([_postCodeTF.text isEqualToString:@""]) {
        if ([_detailModel.code isEqualToString:@""]) {
            _code = @"";
        }else{
        _code = _detailModel.code;
        }
    }else{
        _code = _postCodeTF.text;
    }
    
    if (_provinceCode == nil) {
        _provinceCode = _detailModel.provinceCode;
    }
    if (_cityCode == nil) {
        _cityCode = _detailModel.cityCode;
    }
    if (_areaCode == nil) {
        _areaCode = _detailModel.regionCode;
    }
    
    NSDictionary *paragma = @{
                              @"addressId":_addressId,
                              @"stationId":stationId,
                              @"userName":_name,
                              @"address":_address,
                              @"province":_provinceCode,
                              @"city":_cityCode,
                              @"region":_areaCode,
                              @"phone":_phone,
                              @"code":_code,
                              @"isDefault":_isDefault,
                              @"token":token
                              };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [manager POST:addAddress parameters:paragma success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic =responseObject;
        NSString *judjeStr = [dic objectForKey:@"note"];
        if ([judjeStr isEqualToString:@"SUCCESS"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            NSString *code = [result objectForKey:@"code"];
            NSString *msgbody = [result objectForKey:@"msgbody"];
            if ([code isEqualToString:@"1000"]) {
                //成功
                
//                [UIAlertController alerShowWith:@"提示" Message:@"添加成功" adnOneBtn:@"确定" andTwoBtn:nil andOKBlock:^{
//                    MyCarTVC * myCarTvc=[[MyCarTVC alloc]initWithStyle:UITableViewStylePlain];
//                    UINavigationController * NC=[[UINavigationController alloc]initWithRootViewController:myCarTvc];
//                    [self presentViewController:NC animated:YES completion:nil];
                    
//                } andCancleBlock:nil andRootVC:self];
                //返回收货地址页面并刷新页面
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.delegate refreshVC];
                }];
                
                [UIAlertController showWithTitle:msgbody AfterDismissWithTime:1.0 RootVC:self];
                [self downLoadData];
                
            }else{
                //失败
                [UIAlertController showWithTitle:msgbody AfterDismissWithTime:1.0 RootVC:self];
           
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        }else{
            //重新登录
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //      [UIAlertController showWithTitle:@"网络异常" AfterDismissWithTime:1.0 RootVC:self];
        [self loadFailedWithImage];
    }];
    
    
    
    

}

#pragma mark--UITextFieldDelegate
//2.要实现的Delegate方法,关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.view endEditing:YES];

    return YES;
}
#pragma mark--viewTouchInSide收回键盘
- (void)viewTouchInSide{
//    [textField resignFirstResponder];
    [self.view endEditing:YES];

}


#pragma mark--AddressPickViewDelegate

- (void)slectDoneWithRegionStr:(NSString *)regionStr andProvinceCode:(NSString *)provinceCode andCityCode:(NSString *)cityCode andAreaCode:(NSString *)areaCode{

    _addressLabel.text = regionStr;
    _provinceCode = provinceCode;
    _cityCode = cityCode;
    _areaCode = areaCode;
    

}



#pragma mark--pickViewshow


- (void)pickViewshow{
   
    _pickView.hidden = NO;
    [self.view endEditing:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
