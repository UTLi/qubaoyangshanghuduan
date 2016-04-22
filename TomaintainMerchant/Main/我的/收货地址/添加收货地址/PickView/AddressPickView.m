//
//  AddressPickView.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/3/1.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "AddressPickView.h"

@interface AddressPickView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *_pickView;
}
@property (nonatomic, strong) NSArray *citys;
@property (nonatomic,assign) NSInteger firstComp;//
@property (nonatomic,assign) NSInteger secondComp;
@property (nonatomic,assign) NSInteger thirdComp;
@property (nonatomic, retain) NSString *provinceStr;
@property (nonatomic, retain) NSString *cityStr;
@property (nonatomic, retain) NSString *areaStr;
@property (nonatomic, retain) NSString *provinceCode;
@property (nonatomic, retain) NSString *cityCode;
@property (nonatomic, retain) NSString *areaCode;
@property (weak, nonatomic)  NSLayoutConstraint *contentViewHegithCons;
////总体数据
//@property (strong, nonatomic) NSArray *regionArr;
////省 数组
//@property (strong, nonatomic) NSMutableArray *provinceArr;
////城市 数组
//@property (strong, nonatomic) NSArray *cityArr;
////区县 数组
//@property (strong, nonatomic) NSArray *areaArr;

@end

@implementation AddressPickView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _citys = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"regionList.plist" ofType:nil]];
    self.userInteractionEnabled = YES;
    self.hidden = YES;
    self.contentViewHegithCons.constant = 0;
    [self layoutIfNeeded];
    [self setUI];
    return self;
}
#pragma mark--下载数据
- (void)downLoadData{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *token = [defaults objectForKey:@"token"];
//    NSString * urlStr = [NSString stringWithFormat:@"%@?token=%@",regionList,token];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 15.0f;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
////    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [manager GET: urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSArray *arr =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        _citys = arr;
//        [self setUI];
//           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    }];
        _citys = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"regionList.plist" ofType:nil]];
        [self setUI];
}

#pragma mark--设置UI
- (void)setUI{
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN.width - 50, 10 , 40, 20)];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneBtn];
    
    UIPickerView *pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, SCREEN.width, 200)];
    _pickView = pickView;
    [self addSubview:pickView];
    _pickView.delegate = self;
    _pickView.dataSource = self;

}

#pragma mark - 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0){
        return _citys.count;
        NSLog(@"----%ld",(long)_citys.count);
    }else if (component == 1) {
        return ((NSArray*)[_citys[_firstComp] objectForKey:@"childs"]).count;
    }
    return ((NSArray*)[((NSArray*)[_citys[_firstComp] objectForKey:@"childs"])[_secondComp] objectForKey:@"childs"]).count;
    
}

#pragma mark - 代理方法
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0){
        self.provinceStr = [_citys[row] objectForKey:@"regionName"];
        self.provinceCode = [_citys[row] objectForKey:@"regionCode"];
        return [_citys[row] objectForKey:@"regionName"];
    }else if (component == 1) {
        self.cityStr = [((NSArray*)[_citys[_firstComp] objectForKey:@"childs"])[row] objectForKey:@"regionName"];
        self.cityCode = [((NSArray*)[_citys[_firstComp] objectForKey:@"childs"])[row] objectForKey:@"regionCode"];
        return [((NSArray*)[_citys[_firstComp] objectForKey:@"childs"])[row] objectForKey:@"regionName"];
    }
    self.areaStr = [((NSArray*)[((NSArray*)[_citys[_firstComp] objectForKey:@"childs"])[_secondComp] objectForKey:@"childs"])[row] objectForKey:@"regionName"];
    self.areaCode = [((NSArray*)[((NSArray*)[_citys[_firstComp] objectForKey:@"childs"])[_secondComp] objectForKey:@"childs"])[row] objectForKey:@"regionCode"];
    return [((NSArray*)[((NSArray*)[_citys[_firstComp] objectForKey:@"childs"])[_secondComp] objectForKey:@"childs"])[row] objectForKey:@"regionName"];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _firstComp = row;
        _secondComp = 0;
        [pickerView reloadAllComponents];
    } else if (component == 1) {
        _secondComp = row;
        [pickerView reloadAllComponents];
    } else if (component == 2) {
        
    }
}



#pragma mark--点击完成
- (void)doneClick{
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@",_provinceStr,_cityStr,_areaStr];
    [self.delegate slectDoneWithRegionStr:str andProvinceCode:_provinceCode andCityCode:_cityCode andAreaCode:_areaCode];
//        NSLog(@"%@%@%@",_cityCode,_cityStr,_areaCode);

    self.hidden = YES;
}
- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.contentViewHegithCons.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show{
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = [win.subviews firstObject];
    [topView addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentViewHegithCons.constant = 250;
        [self layoutIfNeeded];
//        self.hidden = NO;
    }];
}

@end
