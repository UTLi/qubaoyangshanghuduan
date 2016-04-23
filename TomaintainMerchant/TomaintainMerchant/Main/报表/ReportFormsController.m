//
//  ReportFormsController.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/1/25.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "ReportFormsController.h"
#import "PNLineChartView.h"
#import "PNPlot.h"
#import "UUChart.h"
#define topViewW SCREEN.width - 10
#define topViewH (SCREEN.width - 10) / 5
@interface ReportFormsController ()<UUChartDataSource>
{
    PNLineChartView *_lineChartView;
    UIView *_topView;
    NSString *_dayCount;
    NSString *_monthCount;
    NSString *_yearCount;
    NSString *_count;
    NSArray *_arrData;
    NSArray *_statArr;
    NSMutableArray *_totalArr;
    NSMutableArray *_lastTotalArr;
    NSMutableArray *_monthArr;
    UUChart *chartView;
}
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *labels;

@end

@implementation ReportFormsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"报表";
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    self.view.backgroundColor = [UIColor whiteColor];
    _totalArr = [NSMutableArray array];
    _lastTotalArr = [NSMutableArray array];
    _monthArr = [NSMutableArray array];
    [self setTopView];
//    [self setLintChartView];
    [self downLoadData];


}

#pragma mark--设置顶部View
- (void)setTopView{

    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(5, 10 + 64, topViewW, topViewH)];
    _topView = topView;
    topView.layer.borderWidth = 1.0f;
    topView.layer.borderColor = MainPurpleColor.CGColor;
    topView.layer.masksToBounds = YES;
    topView.layer.cornerRadius = 5.0f;
    [self.view addSubview:topView];
    for (int i = 1; i <= 3; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake( i * topViewH*5/4, 0, 1, topViewH)];
        label.backgroundColor = MainPurpleColor;
        [topView addSubview:label];
    }
    NSArray *arr = @[@"今日订单",@"本月订单",@"本年订单",@"合计"];
    for (int i = 0; i < 4; i++) {
     
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(i * topViewH*5/4, topViewH/2, topViewH*5/4, topViewH/2)];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font = [UIFont systemFontOfSize:18];
        label2.textColor = CharacterColor1;
        label2.text = arr[i];
        [topView addSubview:label2];
    }
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(topView.frame) + 10, 50, 20)];
    label1.text = @"今年";
    label1.textColor = CharacterColor2;
    [self.view addSubview:label1];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label1.frame) , CGRectGetMaxY(topView.frame)+10, 50, 20)];
    label2.textColor = RGColor(243, 69, 57);
    label2.text = @"——";
    [self.view addSubview:label2];
    UILabel *label12 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label1.frame) + 10, 50, 20)];
    label12.text = @"去年";
    label12.textColor = CharacterColor2;
    [self.view addSubview:label12];
    UILabel *label22= [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label12.frame) , CGRectGetMaxY(label1.frame)+ 10, 50, 20)];
    label22.text = @"——";
    label22.textColor = RGColor(61, 177, 101);
    [self.view addSubview:label22];

}
#pragma mark--设置图表
- (void)setLintChartView{
    chartView = [[UUChart alloc]initWithFrame:CGRectMake(5,64 + 25 + topViewH + 50, topViewW - 20, topViewH * 3)
                                   dataSource:self
                                        style:UUChartStyleLine];
    [chartView showInView:self.view];
}
#pragma mark - @required
//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart
{
    NSArray *arr = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月",];
    
    return arr;
}
//数值多重数组
- (NSArray *)chartConfigAxisYValue:(UUChart *)chart
{
    
    for (int i = 0; i < _statArr.count; i++) {
                NSDictionary *dic = _statArr[i];
                NSString *total = [dic objectForKey:@"total"];
                NSString *lastTotal = [dic objectForKey:@"lastTotal"];
                NSString *month = [dic objectForKey:@"month"];
        
                [_totalArr addObject:total];
                [_lastTotalArr addObject:lastTotal];
                [_monthArr addObject:month];
            }

    
    return @[_totalArr,_lastTotalArr];
}

#pragma mark - @optional
//颜色数组
- (NSArray *)chartConfigColors:(UUChart *)chart
{
    return @[[UUColor red],[UUColor green]];
}
//显示数值范围
- (CGRange)chartRange:(UUChart *)chart
{
    
    return CGRangeMake(10, 0);
}

#pragma mark 折线图专享功能

//标记数值区域
- (CGRange)chartHighlightRangeInLine:(UUChart *)chart
{

    return CGRangeZero;
}

//判断显示横线条
- (BOOL)chart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

//判断显示最大最小值
- (BOOL)chart:(UUChart *)chart showMaxMinAtIndex:(NSInteger)index
{
    return 0;
}

//- (void)setLintChartView{
//
//
//    PNLineChartView *lineChartView = [[PNLineChartView alloc]initWithFrame:CGRectMake(5,64 + 25 + topViewH, topViewW, topViewH * 3)];
//    lineChartView.backgroundColor = RGColor(178, 103, 255);
//    lineChartView.layer.masksToBounds = YES;
//    lineChartView.layer.cornerRadius = 5.0f;
//    [self.view addSubview:lineChartView];
//    _lineChartView = lineChartView;
//    for (int i = 0; i < _statArr.count; i++) {
//        NSDictionary *dic = _statArr[i];
//        NSString *total = [dic objectForKey:@"total"];
//        NSString *lastTotal = [dic objectForKey:@"lastTotal"];
//        NSString *month = [dic objectForKey:@"month"];
//
//        [_totalArr addObject:total];
//        [_lastTotalArr addObject:lastTotal];
//        [_monthArr addObject:month];
//    }
////    NSLog(@"%@",_totalArr);
//    NSArray* plottingDataValues1 =_totalArr;//total
//    NSArray* plottingDataValues2 =_lastTotalArr;
//    
//    _lineChartView.max = 50;
//    _lineChartView.min = 0;
//    
//    _lineChartView.interval = (_lineChartView.max-_lineChartView.min)/10;
//    
//    NSMutableArray* yAxisValues = [@[] mutableCopy];
//    for (int i=0; i<10; i++) {
//        NSString* str = [NSString stringWithFormat:@"%d", _lineChartView.min+_lineChartView.interval*i];
//        NSString *str2 = [NSString stringWithFormat:@"%d",i*10];
//        [yAxisValues addObject:str2];
//    }
//
//    _lineChartView.xAxisValues = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",];
//    _lineChartView.yAxisValues = yAxisValues;
//    _lineChartView.axisLeftLineWidth = 39;
//    
//    
//    PNPlot *plot1 = [[PNPlot alloc] init];
//    plot1.plottingValues = plottingDataValues1;
//    
//    plot1.lineColor = RGColor(98, 46, 170);
//    plot1.lineWidth = 2;
//    
//    [_lineChartView addPlot:plot1];
//    
//    
//    PNPlot *plot2 = [[PNPlot alloc] init];
//    
//    plot2.plottingValues = plottingDataValues2;
//    
//    plot2.lineColor = [UIColor whiteColor];
//    plot2.lineWidth = 2;
//    
//    [_lineChartView  addPlot:plot2];
//
//
//}

#pragma mark--下载数据
- (void)downLoadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *stationId = [defaults objectForKey:@"stationId"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlStr = [NSString stringWithFormat:@"%@?stationId=%@&token=%@",orderStat,stationId,token];
    [manager GET: urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        NSDictionary *dic = responseObject;
        NSString *judjeStr = [dic objectForKey:@"note"];
        if ([judjeStr isEqualToString:@"SUCCESS"]) {
            NSDictionary *result = [dic objectForKey:@"result"];
            _dayCount = [result objectForKey:@"dayCount"];
            _monthCount = [result objectForKey:@"monthCount"];
            _yearCount = [result objectForKey:@"yearCount"];
            _count = [result objectForKey:@"count"];
            _arrData = @[_dayCount,_monthCount,_yearCount,_count];
            [self setLabelData];
            _statArr = [result objectForKey:@"stat"];
            [self setLintChartView];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        }else{
            //重新登录
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
    
}
//设置Label数据
- (void)setLabelData{
    for (int i = 0; i < 4; i++) {

        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(i * topViewH*5/4, 0, topViewH*5/4, topViewH/2)];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font = [UIFont systemFontOfSize:18];
        label2.textColor = CharacterColor1;
        label2.text = _arrData[i];
        [_topView addSubview:label2];
    }


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
