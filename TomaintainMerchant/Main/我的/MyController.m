//
//  MyController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/1/25.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "MyController.h"
#import "MyCell.h"
#import "AdressController.h"
#import "TrackingVC.h"
#import "SetingVC.h"
#import "OrderBuyController.h"
@interface MyController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIView *_topView;
}
@end

@implementation MyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"我的";
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    //rightBarButtonItem购物车按钮
    UIBarButtonItem *RightBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"设置"] style:UIBarButtonItemStyleDone target:self action:@selector(setClick)];
    self.navigationItem.rightBarButtonItem = RightBtn;
    [self setTableView];
    [self setUI];
}
#pragma mark--设置UI
- (void)setUI{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic= [defaults objectForKey:@"usersMessage"];
    NSDictionary *stationDic =[dic objectForKey:@"station"];
    NSString *img = [stationDic objectForKey:@"img"];

    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN.width, SCREEN.width *0.56)];
    _topView = topView;
    topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topView];
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    imageView.center = CGPointMake(SCREEN.width/2, SCREEN.width*0.56/2);
    [imageView setBounds:CGRectMake(0, 0, SCREEN.width/3.7, SCREEN.width/3.7)];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = SCREEN.width/7.4;
    [topView addSubview:imageView];
    
    UILabel *userLabel = [[UILabel alloc]init];
    userLabel.center = CGPointMake(SCREEN.width/2, CGRectGetMaxY(imageView.frame) + 30);
    [userLabel setBounds:CGRectMake(0, 0, SCREEN.width, 20)];
    userLabel.backgroundColor = [UIColor clearColor];
    userLabel.textAlignment = NSTextAlignmentCenter;
    userLabel.textColor = RGColor(98, 41, 163);
    [topView addSubview:userLabel];

    NSString *stationName = [stationDic objectForKey:@"stationName"];
    userLabel.text = stationName;

    
    //客服电话
    UILabel *mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, SCREEN.height - 150, SCREEN.width - 80, 50)];
    mobileLabel.text = @"客服电话：400-8810-410";
    mobileLabel.textColor = RGColor(92, 44 , 160);
    mobileLabel.layer.borderWidth  = 1.0f;
    mobileLabel.layer.borderColor  = RGColor(92, 44 , 160).CGColor;
    mobileLabel.layer.cornerRadius = 5.0f;
    mobileLabel.textAlignment = NSTextAlignmentCenter;
    mobileLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:mobileLabel];
    //给 iconView添加手势]
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction)];    //点击的次数
    aTapGR.numberOfTapsRequired = 1;
    [mobileLabel setUserInteractionEnabled:YES];
    //给self.view添加一个手势监测；
    [mobileLabel addGestureRecognizer:aTapGR];

    

}
#pragma mark--打电话
- (void)tapGRAction{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-8810-410"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

}

#pragma mark--设置tableView

- (void)setTableView{

    //注册Cell,设置tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREEN.width* 0.56 , SCREEN.width, 250) style:UITableViewStylePlain];
    _tableView = tableView;
//    [_tableView registerClass:[MyCell class] forCellReuseIdentifier:@"MyCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    


}


#pragma mark--点击设置
- (void)setClick{
    SetingVC *setVC = [[SetingVC alloc]init];
    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:setVC];
    [self presentViewController:Nav animated:YES completion:nil];

}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        MyCell *cell = [[MyCell alloc]init];
        cell.image.image = [UIImage imageNamed:@"收货地址"];
        cell.label.text = @"收货地址";
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;

    }else if(indexPath.row == 1){
        MyCell *cell = [[MyCell alloc]init];
        cell.image.image = [UIImage imageNamed:@"采购订单"];
        cell.label.text = @"采购订单";
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    
    }else if(indexPath.row == 2){
        MyCell *cell = [[MyCell alloc]init];
        cell.image.image = [UIImage imageNamed:@"用户反馈"];
        cell.label.text = @"用户反馈";
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    
    }else{
    
        return nil;
    }
    
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        AdressController *AdVC = [[AdressController alloc]init];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:AdVC];
        [self presentViewController:Nav animated:YES completion:nil];
    }else if (indexPath.row == 1){
        OrderBuyController *orderVC = [[OrderBuyController alloc ]init];
        UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:orderVC];
        [self presentViewController:Nav animated:YES completion:nil];
    
    }else{
        TrackingVC * tracking=[[TrackingVC alloc]init];
        UINavigationController * NC=[[UINavigationController alloc]initWithRootViewController:tracking];
        [self.navigationController presentViewController:NC animated:YES completion:nil];
    }
//        MessageDVC.messageID = MessageId;
//    UINavigationController *Nav = [[UINavigationController alloc]initWithRootViewController:MessageDVC];
//    [self presentViewController:Nav animated:YES completion:^{
//        
//    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
