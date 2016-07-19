//
//  TwoVC.m
//  FineFood
//
//  Created by Anker Xiao on 16/7/16.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "TwoVC.h"
#import "HTTPServiceSession.h"
#import "TwoModel.h"
#import "TwoCollectionCell.h"
#import "WebView.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

#define DANPIN_API @"http://api.guozhoumoapp.com/v2/items?gender=1&generation=0&limit=20&offset=0"
#define DETAIL_API @"http://api.guozhoumoapp.com/v2/items/"

@interface TwoVC () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_dataArray;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation TwoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.barTintColor = [UIColor brownColor];//设置导航栏颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//设置标题颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;//设置状态栏的颜色(前景色)为白色
    
    [self.view addSubview:self.collectionView];
    
    [self getData];
}

#pragma mark 请求数据
- (void)getData
{
    [HTTPServiceSession serviceSessionWithUrlStr:DANPIN_API andDataBlock:^(NSData *receiveData, NSError *error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingAllowFragments error:nil];
        NSMutableArray *tempArr = [NSMutableArray array];
        for(NSDictionary *dict in dictionary[@"data"][@"items"])
        {
            TwoModel *model = [[TwoModel alloc] initWithDictionary:dict[@"data"] error:nil];
            [tempArr addObject:model];
        }
        _dataArray = tempArr;
        dispatch_async(dispatch_get_main_queue(),^{
            [self.collectionView reloadData];
        });
    }];
}

#pragma mark collectionview的处理
- (UICollectionView *)collectionView
{
    if(nil == _collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREENW-15)/2, 3*(SCREENW-15)/4);
        
        flowLayout.minimumLineSpacing = 15;
        flowLayout.minimumInteritemSpacing = 15;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-49) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor lightGrayColor];
//        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
        [_collectionView registerNib:[UINib nibWithNibName:@"TwoCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
        
        
    }
    return _collectionView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TwoModel *model = _dataArray[indexPath.item];
    TwoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    [cell updateData:model];
//    cell.backgroundColor = [UIColor brownColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TwoModel *model = [[TwoModel alloc] init];
    model = _dataArray[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@%@",DETAIL_API, model.identifier];
    [HTTPServiceSession serviceSessionWithUrlStr:str andDataBlock:^(NSData *receiveData, NSError *error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingAllowFragments error:nil];
        WebView *webView = [[WebView alloc] init];
        webView.strUrl = dic[@"data"][@"url"];
        dispatch_async(dispatch_get_main_queue(),^{
            [self.navigationController pushViewController:webView animated:YES];;
        });
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
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
