//
//  AboutUsVC.m
//  Tomaintain
//
//  Created by iOS on 15/8/17.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()
@property(nonatomic,assign)float centerY;
@property(nonatomic,assign)BOOL bo;
@end

@implementation AboutUsVC



- (void)viewDidLoad {
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [super viewDidLoad];
    self.btn.layer.cornerRadius=5;
    self.bo=NO;
    self.centerY=0;
    self.navigationItem.title=@"关于我们";
    //添加Leftbar
    [self addLetfBarAndPopToLastWithTarget];
    
}

#pragma mark - 拨打电话按钮点击事件
- (IBAction)btnClick:(id)sender {
    
    //点击按钮拨打电话
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4008810410"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
