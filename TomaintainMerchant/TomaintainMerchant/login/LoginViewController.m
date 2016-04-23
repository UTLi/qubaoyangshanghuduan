//
//  LoginViewController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/1/25.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "LoginViewController.h"
#import "RootBarController.h"
#import "LoginModel.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *MobileNumTex;
    UITextField *PasswordTex;
    UIButton *LoginBtn;
    LoginModel* _model;
    NSDictionary *_dic;

}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGColor(94, 43, 160);
    //布置UI
    [self setUI];
    
    
}

#pragma mark--布置UI
-(void)setUI{
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 50, 200, 133.5)];
    topImageView.center = CGPointMake(SCREEN.width/2, 150);
    topImageView.image = [UIImage imageNamed:@"login图标"];
    [self.view addSubview:topImageView];
    UIImageView *texBackView = [[UIImageView alloc]initWithFrame:CGRectMake(30,SCREEN.height/2 - 60, SCREEN.width - 60, (SCREEN.width - 60)/3+1)];
    texBackView.backgroundColor = [UIColor whiteColor];
    texBackView.layer.cornerRadius=5;
    texBackView.userInteractionEnabled = YES;
    [self.view addSubview:texBackView];
    UILabel *grayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,(SCREEN.width - 60)/6 + 1, SCREEN.width - 60, 2)];
    grayLabel.backgroundColor = RGColor(235, 231, 240);
    [texBackView addSubview:grayLabel];
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(30, SCREEN.height/2 + 80, SCREEN.width - 60, (SCREEN.width - 60)/6);
    loginBtn.backgroundColor = RGColor(72, 23, 136);
    loginBtn.layer.cornerRadius=5;
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    LoginBtn = loginBtn;
    [LoginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LoginBtn];
    //手机号输入框
    UITextField *mobileNumTex = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width - 60, (SCREEN.width - 60)/6)];
    [texBackView addSubview:mobileNumTex];
    MobileNumTex = mobileNumTex;
    MobileNumTex.placeholder = @"  请输入账号";
    MobileNumTex.delegate = self;
    [MobileNumTex setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:20.00]];
    UITextField *passwordTex = [[UITextField alloc]initWithFrame:CGRectMake(0, (SCREEN.width - 60)/6 +1, SCREEN.width - 60, (SCREEN.width - 60)/6)];
    [texBackView addSubview:passwordTex];
    PasswordTex = passwordTex;
    PasswordTex.placeholder = @"  请输入密码";
    [PasswordTex setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:20.00]];
    PasswordTex.secureTextEntry=YES;
    PasswordTex.delegate=self;
}

#pragma mark--点击登录按钮
-(void)loginClick{
    NSString * passWord=PasswordTex.text;
    NSString * userName=MobileNumTex.text;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary * parameters =@{@"userName":userName ,@"password":passWord};
    [manager POST:loginStr  parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSDictionary *dic = responseObject;
        _dic = dic;
//        NSLog(@"%@",dic);
        LoginModel *model = [[LoginModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        _model = model;

        if ([_model.msgcode isEqualToString:@"0"]) {
            //登陆成功
            [[UINavigationBar appearance]setBarTintColor:RGColor(69, 33, 115)];
            [[UINavigationBar appearance]setTintColor:[UIColor blackColor]];
            RootBarController *RootVC = [[RootBarController alloc]init];
            //存储用户信息
            NSDictionary *loginMsg = [_dic objectForKey:@"loginMsg"];
//            NSString *msgcode = [loginMsg objectForKey:@"msgcode"];
            NSString *msgbody = [loginMsg objectForKey:@"msgbody"];
            NSString *stationId = _model.stationId;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:_dic forKey:@"usersMessage"];
            [defaults setObject:msgbody forKey:@"token"];//用户识别信息
            [defaults setObject:stationId forKey:@"stationId"];//场站Id
            [defaults synchronize];
            
            [self presentViewController:RootVC animated:YES completion:nil];
        }else if([_model.msgcode isEqualToString:@"1001"]){
            // 账号不存在
            [UIAlertController showWithTitle:@"您输入的账户不存在" AfterDismissWithTime:1.0 RootVC:self];
        }else if([_model.msgcode isEqualToString:@"1002"]){
            //用户名或密码错误
            [UIAlertController showWithTitle:@"用户名或密码错误" AfterDismissWithTime:1.0 RootVC:self];
        }else if([_model.msgcode isEqualToString:@"-1"]){
            //服务器内部发生异常
            [UIAlertController showWithTitle:@"网络异常" AfterDismissWithTime:1.0 RootVC:self];
        
        }else{
        
            NSLog(@"what?");
        }
            
        


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [UIAlertController showWithTitle:@"网络异常" AfterDismissWithTime:1.0 RootVC:self];
    }];

   }

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [MobileNumTex resignFirstResponder];
    [PasswordTex resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
