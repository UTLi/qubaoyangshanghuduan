//
//  HomeViewController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/1/25.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "HomeViewController.h"
#import "MainTopView.h"
#import "TwoLabelView.h"
#import "ImaAndLabView.h"
#import "LoginViewController.h"
#import "VerificationVC.h"
#import "TodaySaleController.h"
#import "AppointmentController.h"
#import "MessageCenterController.h"
#import "CommentController.h"
#import "MemberManageController.h"

#define TopViewHeight (SCREEN.height - 3 -115)*220/916 //顶部View高度
#define MiddleViewHeight (SCREEN.height - 3 - 115)*280/916 //中部View高度
#define BottomViewHeight (SCREEN.height - 3 - 115)*416/916 //底部View高度

#define GAPS  5 //缝隙
#define TOPGAPS 20 //顶部缝隙
#define LabelHeight (TopViewHeight - 15 - GAPS * 4)/4 //Label高度
@interface HomeViewController ()
{
    NSDictionary *_dic;
    TwoLabelView *_todayLab;
    TwoLabelView *_yesterDayLab;
    TwoLabelView *_alredayLab;
    TwoLabelView *_waitLab;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"去保养";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = RGColor(241, 241, 241);
    [self downloadData];
    [self addTopView];
    [self addMiddleView];
    [self addBottomView];
}


#pragma mark--下载数据

-(void)downloadData{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    NSString *urlStr = [NSString stringWithFormat:@"%@?stationId=%@&token=%@",mainPage,stationId,token];
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
            [self refreshData];
        }else{
        //重新登录
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
            
        }
      
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
   


}
#pragma mark--刷新订单数据

-(void)refreshData{
    NSString *todayOrder = [_dic objectForKey:@"todayOrder"];
    _todayLab.label.text = todayOrder;
    NSString *yesterday = [_dic objectForKey:@"yesterdayOrder"];
    _yesterDayLab.label.text = yesterday;
    NSString *alredayLab = [_dic objectForKey:@"historyCount"];
    _alredayLab.label.text = alredayLab;
    NSString *waitLab = [_dic objectForKey:@"orderCount"];
    _waitLab.label.text = waitLab;
    
}



#pragma mark--顶部View
-(void)addTopView{
    MainTopView *topView = [[MainTopView alloc]init];
    [self.view addSubview:topView];

}
#pragma mark--中部View
-(void)addMiddleView{
    UIView *MiddleView = [[UIView alloc]initWithFrame:CGRectMake(0, TopViewHeight + 1 + 64, SCREEN.width, MiddleViewHeight)];
    [self.view addSubview:MiddleView];
//    NSString* todayOrder = [_dic objectForKey:@"todayOrder"];
    
    TwoLabelView *TodayLab = [[TwoLabelView alloc]initWithFrame:CGRectMake(0, 0, (SCREEN.width - 1)/2, (MiddleViewHeight - 1)/2) andLabOneColor:[UIColor redColor] andLabTwo:@"今日订单数"];
    [MiddleView addSubview:TodayLab];
    _todayLab = TodayLab;
    
    TwoLabelView *YesterDayLab = [[TwoLabelView alloc]initWithFrame:CGRectMake((SCREEN.width + 1)/2, 0, (SCREEN.width - 1)/2, (MiddleViewHeight - 1)/2) andLabOneColor:[UIColor blackColor] andLabTwo:@"昨日订单数"];
    [MiddleView addSubview:YesterDayLab];
    _yesterDayLab = YesterDayLab;
    
    TwoLabelView *AlredayLab = [[TwoLabelView alloc]initWithFrame:CGRectMake(0, (MiddleViewHeight + 1)/2, (SCREEN.width - 1)/2, (MiddleViewHeight - 1)/2) andLabOneColor:[UIColor blackColor] andLabTwo:@"已处理订单数"];
    [MiddleView addSubview:AlredayLab];
    _alredayLab = AlredayLab;
    
    TwoLabelView *WaitLab = [[TwoLabelView alloc]initWithFrame:CGRectMake((SCREEN.width + 1)/2, (MiddleViewHeight + 1)/2, (SCREEN.width - 1)/2, (MiddleViewHeight - 1)/2) andLabOneColor:[UIColor redColor] andLabTwo:@"待处理订单数"];
    [MiddleView addSubview:WaitLab];
    _waitLab = WaitLab;


}
#pragma mark--底部View

-(void)addBottomView{
    UIView *BottomView = [[UIView alloc]initWithFrame:CGRectMake(0, TopViewHeight + MiddleViewHeight + 2 + 64, SCREEN.width, BottomViewHeight)];
    [self.view addSubview:BottomView];
    BottomView.backgroundColor = [UIColor whiteColor];
    ImaAndLabView *VerificationView = [[ImaAndLabView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width/3, BottomViewHeight/2) andImageName:@"核销管理" andlabelTex:@"核销管理" andBlock:^(ImaAndLabView *imaAndLabView) {
        //跳转核销管理
        VerificationVC *verifVC = [[VerificationVC alloc]init];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:verifVC];
        [self presentViewController:Nav animated:YES completion:nil];
        
        
    }];
    [BottomView addSubview:VerificationView];
    
    ImaAndLabView *AppointmentView = [[ImaAndLabView alloc]initWithFrame:CGRectMake(SCREEN.width/3, 0, SCREEN.width/3, BottomViewHeight/2) andImageName:@"预约管理" andlabelTex:@"预约管理" andBlock:^(ImaAndLabView *imaAndLabView) {
        //跳转预约管理
        AppointmentController *appointmentVC = [[AppointmentController alloc]init];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:appointmentVC];
        [self presentViewController:Nav animated:YES completion:nil];
        
    }];
    [BottomView addSubview:AppointmentView];
    
    ImaAndLabView *TodaySaleView = [[ImaAndLabView alloc]initWithFrame:CGRectMake((SCREEN.width/3) * 2, 0, SCREEN.width/3, BottomViewHeight/2) andImageName:@"今日特惠" andlabelTex:@"今日特惠" andBlock:^(ImaAndLabView *imaAndLabView) {
        //跳转今日特惠
        TodaySaleController *ToDayVC = [[TodaySaleController alloc]init];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:ToDayVC];
        [self presentViewController:Nav animated:YES completion:nil];
    }];
    [BottomView addSubview:TodaySaleView];
    
    ImaAndLabView *MemberView = [[ImaAndLabView alloc]initWithFrame:CGRectMake(0, BottomViewHeight/2, SCREEN.width/3, BottomViewHeight/2) andImageName:@"会员管理" andlabelTex:@"会员管理" andBlock:^(ImaAndLabView *imaAndLabView) {
        //跳转会员管理
        MemberManageController *memberVC = [[MemberManageController alloc]init];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:memberVC];
        [self presentViewController:Nav animated:YES completion:nil];
    }];
    [BottomView addSubview:MemberView];
    
    ImaAndLabView *MessageView = [[ImaAndLabView alloc]initWithFrame:CGRectMake(SCREEN.width/3, BottomViewHeight/2, SCREEN.width/3, BottomViewHeight/2) andImageName:@"消息中心" andlabelTex:@"消息中心" andBlock:^(ImaAndLabView *imaAndLabView) {
        //跳转消息中心
        MessageCenterController *messageVC = [[MessageCenterController alloc]init];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:messageVC];
        [self presentViewController:Nav animated:YES completion:nil];
    }];
    [BottomView addSubview:MessageView];
    
    ImaAndLabView *CommentView = [[ImaAndLabView alloc]initWithFrame:CGRectMake((SCREEN.width/3) * 2, BottomViewHeight/2, SCREEN.width/3, BottomViewHeight/2) andImageName:@"门店评论" andlabelTex:@"门店评论" andBlock:^(ImaAndLabView *imaAndLabView) {
        //跳转门店评论
        CommentController *commentVC = [[CommentController alloc]init];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:commentVC];
        [self presentViewController:Nav animated:YES completion:nil];
    }];
    [BottomView addSubview:CommentView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
