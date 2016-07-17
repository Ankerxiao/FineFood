//
//  ScrollViewDetailOneVC.m
//  FineFood
//
//  Created by Anker Xiao on 16/7/17.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "ScrollViewDetailOneVC.h"
#import <UIImageView+WebCache.h>
#import "HTTPServiceSession.h"
#import "CollectionModel.h"
#import "WebView.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height



@interface ScrollViewDetailOneVC () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_dataArray;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation ScrollViewDetailOneVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray array];
    [self.view addSubview:self.collectionView];
    [self getData];
}

- (void)getData
{
    [HTTPServiceSession serviceSessionWithUrlStr:self.urlStr andDataBlock:^(NSData *receiveData, NSError *error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dictionary[@"data"][@"posts"];
        for(NSDictionary *dict in array)
        {
            CollectionModel *model = [[CollectionModel alloc] initWithDictionary:dict error:nil];
            [_dataArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(),^{
            [self.collectionView reloadData];
        });
    }];
}

- (UICollectionView *)collectionView
{
    if(nil == _collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, 210);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-69) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.alwaysBounceVertical = YES;
    }
//    _collectionView.contentSize = CGSizeMake(SCREENW, 750);
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 210)];
    vw.backgroundColor = [UIColor grayColor];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    CollectionModel *model = _dataArray[indexPath.item];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, SCREENW-10, 150)];
    [imageV sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url]];
    [vw addSubview:imageV];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(imageV.frame)+5, SCREENW, 20)];
    label2.text = model.title;
    [vw addSubview:label2];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(SCREENW-110, imageV.frame.origin.y-20, 100, 20)];
    label3.text = [NSString stringWithFormat:@"点赞:%@",model.likes_count];
    label3.textColor = [UIColor redColor];
    [label3 setFont:[UIFont boldSystemFontOfSize:20]];
    [imageV addSubview:label3];
    cell.backgroundView = vw;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionModel *model = _dataArray[indexPath.item];
    WebView *webView = [[WebView alloc] init];
    webView.strUrl = model.content_url;
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
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
