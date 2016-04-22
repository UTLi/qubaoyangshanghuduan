//
//  TrackingVC.m
//  Tomaintain
//
//  Created by iOS on 15/8/6.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import "TrackingVC.h"
#import "UIPlaceholderTextView.h"
#import "UIView+Frame.h"
#import "AFNetworking.h"

@interface TrackingVC ()<UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,retain)UIPlaceholderTextView * lTextView;//意见填写框
@property(nonatomic,retain)UITextField * sTextField;//输入邮箱框


@end

@implementation TrackingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"意见反馈";
    //添加leftbar
    [self addLetfBarAndDismissToLastWithTarget];
    //
    [self addTextfield];
    self.view.backgroundColor= RGColor(225, 226, 228);
    //rightBarButtonItem编辑
    UIBarButtonItem *RightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(LogoutBtnClick)];
//    _rightBtn = RightBtn;
    self.navigationItem.rightBarButtonItem = RightBtn;
//    [self addLogoutBtn];
    [self keyBoardReturn];
    // Do any additional setup after loading the view.
}

#pragma mark - 布局textView和TextFiled
-(void)addTextfield
{
    //UIPlaceholderTextView 第三方
    //布局意见填写框
    self.lTextView=[[UIPlaceholderTextView alloc]initWithFrame:CGRectMake(20,74 , SCREEN.width-40, 140)];
    self.lTextView.backgroundColor=[UIColor whiteColor];
    self.lTextView.textColor = CharacterColor2;
    self.lTextView.font = [UIFont systemFontOfSize:15];
    self.lTextView.layer.masksToBounds = YES;
    self.lTextView.layer.cornerRadius = 5;
    _lTextView.delegate=self;
    self.lTextView.placeholder=@"输入意见反馈，我们将为您不断改进";
    [self.view addSubview:_lTextView];
    
    //布局邮箱输入框
    self.sTextField=[[UITextField alloc]initWithFrame:CGRectMake(20,224 , SCREEN.width-40, 44)];
    _sTextField.placeholder=@"请输入手机号码或者邮箱";
    _sTextField.font= [UIFont systemFontOfSize:15];
    _sTextField.layer.masksToBounds = YES;
    _sTextField.layer.cornerRadius = 5;
    _sTextField.delegate=self;
    _sTextField.textColor = CharacterColor2;
    self.sTextField.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_sTextField];
    
}

#pragma mark - 限制意见反馈的输入字数
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=120)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark-添加提交Btn
-(void)addLogoutBtn
{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTintColor:[UIColor whiteColor]];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.backgroundColor=RGColor(42, 122, 247);
    btn.layer.cornerRadius=2;
    btn.frame=CGRectMake(20,278, SCREEN.width-40, 40);
    [self.view addSubview:btn];
    
    //btn的点击事件 设置
    [btn addTarget:self action:@selector(LogoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
//btn的点击事件
-(void)LogoutBtnClick
{
    [self commitTaking];
}

-(BOOL)automaticallyAdjustsScrollViewInsets
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


#pragma mark - 根据输入移动View 位置
- (void)moveView:(UITextField *)textField leaveView:(BOOL)leave
{
    UIView *accessoryView = textField.inputAccessoryView;
    UIView *inputview     = textField.inputView;
    
    int textFieldY = 0;
    int accessoryY = 0;
    if (accessoryView && inputview)
    {
        CGRect accessoryRect = accessoryView.frame;
        CGRect inputViewRect = inputview.frame;
        accessoryY = SCREEN.height - (accessoryRect.size.height + inputViewRect.size.height);
    }
    else if (accessoryView)
    {
        CGRect accessoryRect = accessoryView.frame;
        accessoryY = SCREEN.height - (accessoryRect.size.height + 300);
    }
    else if (inputview)
    {
        CGRect inputViewRect = inputview.frame;
        accessoryY = SCREEN.height -inputViewRect.size.height;
    }
    else
    {
        accessoryY = SCREEN.height-300; //480 - 216;
    }
    
    
    CGRect textFieldRect = textField.frame;
    textFieldY = textFieldRect.origin.y + textFieldRect.size.height + 20;
    
    int offsetY = textFieldY - accessoryY;
    if (!leave && offsetY > 0)
    {
        int y_offset = -5;
        
        y_offset += -offsetY;
        
        CGRect viewFrame = self.view.frame;
        
        viewFrame.origin.y += y_offset;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
    else
    {
        CGRect viewFrame = CGRectMake(0, 0, SCREEN.width, SCREEN.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
}


#pragma mark - 开始编辑时 移动View的位置
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveView:textField leaveView:NO];
}
#pragma mark - 结束编辑时 移动View的位置
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    [self moveView:textField leaveView:YES];
}



#pragma mark - 添加回收键盘手势
-(void)keyBoardReturn
{
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardHuiShou)];
    [self.view addGestureRecognizer:tap];
    
}
//收键盘手势 触发事件
-(void)keyboardHuiShou
{
    [self.view endEditing:YES];
    
}

#pragma mark - 提交意见反馈
-(void)commitTaking
{
     [self.view endEditing:YES];
    
 //反馈不能为空
    if ([self.lTextView.text isEqual:@""]) {
        [UIAlertController showWithTitle:@"反馈不能为空" AfterDismissWithTime:1 andAfterDoSomethingWithBlock:^{
           
        } RootVC:self];
        return ;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager * manager=[AFHTTPRequestOperationManager manager];
    
    //设置AFN的请求时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //设施request的请求样式
    manager.requestSerializer= [AFJSONRequestSerializer serializer];
    //请求参数
    NSDictionary * params=@{@"advicebody":self.lTextView.text,
                            @"advicephone":self.sTextField.text};
    
    //post请求
    [manager POST:ticklingURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //隐藏旋转
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //显示请求结果
        [UIAlertController showWithTitle:[responseObject objectForKey:@"msgbody"] AfterDismissWithTime:1 andAfterDoSomethingWithBlock:^{
           
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } RootVC:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [UIAlertController showWithTitle:@"网络异常" AfterDismissWithTime:1.0 RootVC:self];
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
