//
//  ClassifyView.m
//  TomaintainMerchant
//
//  Created by 李沛 on 16/2/22.
//  Copyright © 2016年 LP. All rights reserved.
//

#import "ClassifyView.h"
#import "ClassifyProductModel.h"
#import "OneLabelCell.h"
#import "CollectionViewCell.h"
@interface ClassifyView()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UITableView *_tableView;
    UICollectionView *_collectionView;

}
@property (nonatomic ,retain) NSString *catolog;
@property (nonatomic ,retain) NSString *level;
@property (nonatomic ,retain) NSMutableArray *datas;
@property (nonatomic ,retain) NSMutableArray *level2Datas;

@end

@implementation ClassifyView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _catolog = @"";
        _level = @"1";
        _datas = [NSMutableArray array];
        _level2Datas = [NSMutableArray array];
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, self.frame.size.height)];
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGColor(239, 240, 241);
        _tableView.separatorStyle = NO;
        [self addSubview:tableView];
        [_tableView registerClass:[OneLabelCell class] forCellReuseIdentifier:@"OneLabelCell"];
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.headerReferenceSize = CGSizeMake(SCREEN.width - 100, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(100, 0, SCREEN.width- 100, self.frame.size.height ) collectionViewLayout:flowLayout];
        _collectionView.delegate =self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];

        [self addSubview:_collectionView];
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
        
        
        
        [self downloadData];
    }
    return self;
}

#pragma mark--下载数据
- (void)downloadData{
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 15.0f;
            [ manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *token = [defaults objectForKey:@"token"];
            NSString * urlStr = [NSString stringWithFormat:@"%@?level=%@&catolog=%@&token=%@",classifyList,_level,_catolog,token];

    [manager GET: urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //        NSDictionary *dic = responseObject;
        NSString *judjeStr = [dic objectForKey:@"note"];
        
        if ([judjeStr isEqualToString:@"SUCCESS"]) {
            NSArray *arr = [dic objectForKey:@"result"];

            if ([_level isEqualToString:@"1"]) {
                [_datas removeAllObjects];
                for (int i = 0; i < arr.count; i++) {
                    NSDictionary *dictionary = arr[i];
                    ClassifyProductModel *model = [[ClassifyProductModel alloc]init];
                    [model setValuesForKeysWithDictionary:dictionary];
                    [_datas addObject:model];
                }
                    [_tableView reloadData];
                    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
                    [_tableView selectRowAtIndexPath:first animated:YES scrollPosition:UITableViewScrollPositionTop];
                    _level = @"2";
                    ClassifyProductModel *model1 = _datas[0];
                    _catolog = model1.proId;
                    [self downloadData];
                
            }else{
                //level = 2
                [_level2Datas removeAllObjects];
                for (int i = 0; i < arr.count; i++) {
                    NSDictionary *dictionary = arr[i];
                    ClassifyProductModel *model = [[ClassifyProductModel alloc]init];
                    [model setValuesForKeysWithDictionary:dictionary];
                    [_level2Datas addObject:model];
                    [_collectionView reloadData];

                }
            
            }
//            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        }else{
            //重新登录
            LoginViewController *loginVC = [[LoginViewController alloc]init];
//            [self presentViewController:loginVC animated:YES completion:nil];
            
        }

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                
            }];
}
//============================================================
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ProductsCell";
    OneLabelCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[OneLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.model = _datas[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

   _level = @"2";
    ClassifyProductModel *model = _datas[indexPath.row];
   _catolog = model.proId;
    [self downloadData];

}


        

//============================================================
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _level2Datas.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"CollectionViewCell";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    cell.model = _level2Datas[indexPath.row];

    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake((SCREEN.width - 100 )/3 - 10 ,(SCREEN.width - 100 - 20)/3 + 20);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor redColor];
    ClassifyProductModel *model = _level2Datas[indexPath.row];
    [self.delegate refreshTableViewWithCatolog:model.proId];
//    NSLog(@"选择%ld",indexPath.row);
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
