//
//  ThreeDetailVC.m
//  FineFood
//
//  Created by Anker Xiao on 16/7/19.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "ThreeDetailVC.h"
#import "CollectionModel.h"
#import <UIImageView+WebCache.h>
#import "HTTPServiceSession.h"
#import "WebView.h"

#define DETAIL_API @"http://api.guozhoumoapp.com/v1/channels/%@/items?limit=20&offset=0"


#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface ThreeDetailVC () <UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *_dataArray;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation ThreeDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataArray = [NSMutableArray array];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREENW, 210);
    flowLayout.minimumLineSpacing = 20;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH-49) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:_collectionView];
    
    [self getData];
    
}

- (void)getData
{
    NSString *urlStr = [NSString stringWithFormat:DETAIL_API,self.identifier];
    NSLog(@"%@",urlStr);
    [HTTPServiceSession serviceSessionWithUrlStr:urlStr andDataBlock:^(NSData *receiveData, NSError *error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dictionary[@"data"][@"items"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for(NSDictionary *dict in array)
        {
            CollectionModel *model = [[CollectionModel alloc] initWithDictionary:dict error:nil];
            [tempArray addObject:model];
        }
        _dataArray = tempArray;
        dispatch_async(dispatch_get_main_queue(),^{
            [self.collectionView reloadData];
        });
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    CollectionModel *model = _dataArray[indexPath.item];
   
    UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 210)];
    vw.backgroundColor = [UIColor grayColor];
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
    WebView *webV = [[WebView alloc] init];
    webV.strUrl = model.url;
    [self.navigationController pushViewController:webV animated:YES];
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
