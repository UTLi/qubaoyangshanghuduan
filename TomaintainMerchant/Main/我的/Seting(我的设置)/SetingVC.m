//
//  SetingVC.m
//  Tomaintain
//
//  Created by iOS on 15/8/6.
//  Copyright (c) 2015年 iOS. All rights reserved.
//

#import "SetingVC.h"
#import "UIView+Frame.h"
#import "SetingCell.h"
#import "AboutUsVC.h"
#import "UIAlertController+Login.h"
#import "SDImageCache.h"
#import "AFNetworking.h"


#define appID @"1037937054"
@interface SetingVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)UITableView * tableView;
@property(nonatomic,assign)float cacheSize;//缓存大小


@end

@implementation SetingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    //添加左侧leftBar
    [self addLetfBarAndDismissToLastWithTarget];
    self.navigationItem.title=@"设置";
    self.view.backgroundColor=[UIColor whiteColor];
    //添加图标 二维码
//    [self loadICon];
    [self.tableView registerNib:[UINib nibWithNibName:@"SetingCell" bundle:nil] forCellReuseIdentifier:@"setingCell"];
    //添加 退出登陆按钮
//    [self addLogoutBtn];
    //获得cache文件缓存
    [self getCacheSize];
    
    
    
    
}




#pragma mark-添加蓝色按钮 (退出登陆) (设置tableView的Footer)
-(void)addLogoutBtn
{
    
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, 60)];
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTintColor:[UIColor whiteColor]];
    //如果用户登陆  则显示按钮  不登陆则隐藏按钮
    if ([[NSUserDefaults standardUserDefaults ] objectForKey:@"userName"]!= nil)
    {
        [btn setTitle:@"退出当前用户" forState:UIControlStateNormal];
    }else
    {
        btn.alpha=0;
        btn.userInteractionEnabled=NO;
    }
    btn.backgroundColor=RGColor(42, 122, 247);
    btn.layer.cornerRadius=2;
    btn.frame=CGRectMake(13,20,SCREEN.width-30, 40);
    [view addSubview:btn];
    
    //添加btn的点击事件
//    [btn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView=view;
    
}
-(void)logout
{
    if ([[NSUserDefaults standardUserDefaults ] objectForKey:@"userName"]!= nil)
    {//如果登陆  则退出
        [self alertUserOut];
       
    }
   
}

#pragma mark - 提示退出信息
-(void)alertUserOut
{
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确定退出?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
//        //清除本地缓存
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"usersMessage"];
//        //清除本地缓存
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
//        //清除本地缓存
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"stationId"];

        
        [self removeNSUserDefaults]; 
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ShopCarClean" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ShopCarNULL" object:nil];
        LoginViewController * LoginVC = [[LoginViewController alloc]init];
        [self presentViewController:LoginVC animated:YES completion:nil];

        
    }];
    UIAlertAction * cancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
    }];
    [alert addAction:action];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)removeNSUserDefaults
{
    NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary * dic=[userDefatluts dictionaryRepresentation];
    NSLog(@"%lu",(unsigned long)dic.allKeys.count);
    NSLog(@"%@",dic);
    for(NSString* key in [dic allKeys]){
        //map  存储是否打开过地图
        if([key isEqual:@"map"]){
            continue;
        }
        [userDefatluts removeObjectForKey:key];
        [userDefatluts synchronize];
    }
}

#pragma mark - 设置tableView
-(UITableView *)tableView
{
    if (_tableView==nil) {
        //设置tabeView的类型
        _tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.delegate=self;
        _tableView.bounces=NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

#pragma  mark - 加载iCon (二维码以及显示的Lable)
-(void)loadICon
{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN.width, SCREEN.width/640*372)];
    view.backgroundColor=[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    //二维码显示的ImageView
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [self.view widthWithUIScreen]/3, [self.view widthWithUIScreen]/3)];
    //设置图片
    imageView.image=[UIImage imageNamed:@"qubaoyangerweima"];
    //设置大小
    imageView.center=CGPointMake(view.frame.size.width/2,view.frame.size.height/2-10);
    [view addSubview:imageView];
    
    //设置二维码下的文字
    UILabel * lab=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+10, SCREEN.width, 30)];
    lab.text=@"扫描二维码,关注去保养";
    [lab setTextColor:[UIColor lightGrayColor]];
    lab.font=[UIFont systemFontOfSize:14];
    lab.textAlignment=NSTextAlignmentCenter;
    [view addSubview:lab];
    
    //设置tableView的headerView
    self.tableView.tableHeaderView=view;
}



#pragma mark - Table view data source
//区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
//每个区返回的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }
    return 1;
}

#pragma mark - 设置区高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section!=0) {
        return 10;
    }
    return 0;
}


#pragma mark - 设置tableView的Cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SetingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setingCell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
                cell.titleLab.text=@"清除本地缓存";
                //获取缓存文件的大小
                cell.cacheLab.text=[NSString stringWithFormat:@"%.2fM",_cacheSize];
            }else{
                cell.titleLab.text=@"关于我们";
            }
        }
            break;
        case 1:
        {
            if(indexPath.row==0)
            {
                cell.titleLab.text=@"退出当前账号";
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UIAlertView 提示正在清除
-(void)pushCacheAlertView
{
    [UIAlertController showWithTitle:@"正在清理缓存" AfterDismissWithTime:1.5 RootVC:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _cacheSize=0.0;
        [self.tableView reloadData];
    });
}

#pragma mark - tableView点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row==0) {
                //获得需要行处的文件的路径
                NSString * cachePath=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
                //清除缓存文件
                [SetingVC clearCache:cachePath];
                //推出显示正在清除的提示框
                [self pushCacheAlertView];
                
            }else if (indexPath.row==1)
            {
                //弹出关于我们页面
                AboutUsVC * about=[[AboutUsVC alloc]initWithNibName:@"AboutUsVC" bundle:nil];
                [self.navigationController pushViewController:about animated:YES];
                
            }
        }
            break;
        case 1:
        {
            if (indexPath.row==0)
            {
              //退出当前账号
                [self alertUserOut];
            }

        }
            break;
            
        default:
            break;
    }
   
}


#pragma mark - 获得cache文件的内容的大小
-(void)getCacheSize
{
    NSString * cachePath=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    //计算缓存大小
     _cacheSize  =  [self folderSizeAtPath:cachePath];
    
}

//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
#pragma mark - 清除缓存文件
+(void)clearCache:(NSString *)path{
    [[SDImageCache sharedImageCache]cleanDisk];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
