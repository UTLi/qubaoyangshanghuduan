//
//  MemberDetailController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/18.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "MemberDetailController.h"
#import "MemberDetailView.h"
#import "ServeNoteController.h"
#import <MessageUI/MessageUI.h>

#define Height 44
@interface MemberDetailController ()<MFMessageComposeViewControllerDelegate>

{
//    UILabel *_nameLabel;
//    UILabel *_mobileLabel;
//    UILabel *_brandLabel;//车牌车系
//    UILabel *_modelLabel;//车型
//    UILabel *_autoNum;//车牌号
    NSDictionary *_dic;//存储数据

}
@end

@implementation MemberDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员详情";
    [self addLetfBarAndDismissToLastWithTarget];
    self.view.backgroundColor = [UIColor whiteColor];
    [self downloadData];
}

- (void)setUI{
    NSDictionary *user = [_dic objectForKey:@"user"];
    NSDictionary *userAuto = [_dic objectForKey:@"userAuto"];

    NSString *userName = [user objectForKey:@"userName"];
    NSString *mobile = [user objectForKey:@"mobile"];
    NSString *autoNum = [userAuto objectForKey:@"autoNum"];
    NSString *brand = [userAuto objectForKey:@"brand"];
    NSString *model = [userAuto objectForKey:@"model"];

    MemberDetailView *view1 = [[MemberDetailView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.width, 44) andlabel1Str:@"姓        名：" andlabel2str:userName];
    [self.view addSubview:view1];
    
    MemberDetailView *view2 = [[MemberDetailView alloc]initWithFrame:CGRectMake(0, 64 + Height, SCREEN.width, 44) andlabel1Str:@"联系电话：" andlabel2str:mobile];
    [self.view addSubview:view2];
    
    MemberDetailView *view3 = [[MemberDetailView alloc]initWithFrame:CGRectMake(0,64 + Height *2, SCREEN.width, 44) andlabel1Str:@"品牌车系：" andlabel2str:brand];
    [self.view addSubview:view3];
    
    MemberDetailView *view4 = [[MemberDetailView alloc]initWithFrame:CGRectMake(0,64 + Height *3, SCREEN.width, 44) andlabel1Str:@"车牌号码：" andlabel2str:autoNum];
    [self.view addSubview:view4];
    
    MemberDetailView *view5 = [[MemberDetailView alloc]initWithFrame:CGRectMake(0,64 + Height *4, SCREEN.width, 44) andlabel1Str:@"车        型：" andlabel2str:model];
    [self.view addSubview:view5];
    
    UILabel *surveyLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.width  / 11,64 + Height * 5 + 20, SCREEN.width *4 / 11, Height)];
    surveyLabel.text = @"查看保养记录";
    surveyLabel.textColor = RGColor(92, 44 , 160);
    surveyLabel.layer.borderWidth  = 1.0f;
    surveyLabel.layer.borderColor  = RGColor(92, 44 , 160).CGColor;
    surveyLabel.layer.cornerRadius = 5.0f;
    surveyLabel.textAlignment = NSTextAlignmentCenter;
    surveyLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:surveyLabel];
    //给 surveyLabel添加手势]
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction)];
    //点击的次数
    aTapGR.numberOfTapsRequired = 1;
    [surveyLabel setUserInteractionEnabled:YES];
    [surveyLabel addGestureRecognizer:aTapGR];
    
    
    UILabel *sendLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN.width * 6 / 11,64 + Height * 5 + 20, SCREEN.width *4 / 11, Height)];
    sendLabel.text = @"发消息";
    sendLabel.textColor = [UIColor whiteColor];
    sendLabel.backgroundColor = RGColor(92, 44 , 160);
    sendLabel.layer.masksToBounds = YES;
    sendLabel.layer.cornerRadius = 5.0f;
    sendLabel.textAlignment = NSTextAlignmentCenter;
    sendLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:sendLabel];
    //给 surveyLabel添加手势]
    UITapGestureRecognizer *sTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stapGRAction)];
    //点击的次数
    sTapGR.numberOfTapsRequired = 1;
    [sendLabel setUserInteractionEnabled:YES];
    [sendLabel addGestureRecognizer:sTapGR];


}
#pragma mark--点击查看保养记录
- (void)tapGRAction{
    ServeNoteController *serveVC = [[ServeNoteController alloc]init];
    NSDictionary *userAuto = [_dic objectForKey:@"userAuto"];
    serveVC.autoId = [userAuto objectForKey:@"autoId"];
    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:serveVC];
    [self presentViewController:Nav animated:YES completion:nil];

}
#pragma mark--点击发送消息
- (void)stapGRAction{
    NSDictionary *user = [_dic objectForKey:@"user"];
    NSString *mobile = [user objectForKey:@"mobile"];
    [self showMessageView:[NSArray arrayWithObject:mobile] title:@"去保养" body:@"去保养：尊敬的客户"];
//

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




#pragma mark--下载数据
- (void)downloadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *userID = _userId;
    NSString * urlStr = [NSString stringWithFormat:@"%@?&token=%@&userId=%@",memberManageDetail,token,userID];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager GET: urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *judjeStr = [dic objectForKey:@"note"];
        [self removeFailesImage];
        if ([judjeStr isEqualToString:@"SUCCESS"]) {
            NSDictionary *dictionary = [dic objectForKey:@"result"];
            _dic = dictionary;
            [self setUI];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        }else{
            //重新登录
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        //      [UIAlertController showWithTitle:@"网络异常" AfterDismissWithTime:1.0  RootVC:self];
            [self loadFailedWithImage];
        
    }];

  


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
