//
//  OneVC.m
//  FineFood
//
//  Created by Anker Xiao on 16/7/16.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "OneVC.h"
#import <UIImageView+WebCache.h>
#import "DataModel.h"
#import "DataModelTarget.h"
#import "HTTPServiceSession.h"
#import "ScrollViewDetailOneVC.h"
#import "CollectionModel.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

#define SCROLL_H (150)


#define SCROLL_API @"http://api.guozhoumoapp.com/v1/banners?channel=iOS"
#define Collection1_API @"http://api.guozhoumoapp.com/v1/channels/4/items?gender=1&generation=1&limit=20&offset=0" //精选
//周末逛店
#define Collection2_API @"http://api.guozhoumoapp.com/v1/channels/12/items?limit=20&offset=0"
//尝美食
#define Collection3_API @"http://api.guozhoumoapp.com/v1/channels/15/items?limit=20&offset=0"
//体验课
#define Collection4_API @"http://api.guozhoumoapp.com/v1/channels/13/items?limit=20&offset=0"
//周边游
#define Collection5_API @"http://api.guozhoumoapp.com/v1/channels/14/items?limit=20&offset=0"

@interface OneVC () <UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_scrollDataArray;
    NSMutableArray *_collectionDataArray;
    NSMutableArray *_collection1DataArray;
    NSMutableArray *_collection2DataArray;
    NSMutableArray *_collection3DataArray;
    NSMutableArray *_collection4DataArray;
    NSMutableArray *_collection5DataArray;
    
    UIButton *_button;
}

@property (nonatomic,strong) UIScrollView *bigScrollView;

@property (nonatomic,strong) UIView *btnListView;
@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) UIButton *btn2;
@property (nonatomic,strong) UIButton *btn3;
@property (nonatomic,strong) UIButton *btn4;
@property (nonatomic,strong) UIButton *btn5;
@property (nonatomic,strong) UIView *bottomLine;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UICollectionView *collectionView1;
@property (nonatomic,strong) UICollectionView *collectionView2;
@property (nonatomic,strong) UICollectionView *collectionView3;
@property (nonatomic,strong) UICollectionView *collectionView4;
@property (nonatomic,strong) UICollectionView *collectionView5;
@end

@implementation OneVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    UIButton *bbb = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    bbb.backgroundColor = [UIColor blackColor];
//    [bbb addTarget:self action:@selector(wo:) forControlEvents:UIControlEventTouchDragOutside];
//    [self.view addSubview:bbb];

    
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor brownColor];//设置导航栏颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//设置标题颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;//设置状态栏的颜色(前景色)为白色
    
    //btnlist的初始化
    [self initWithBtnListView];
    
    //大的ScrollView加到self.view上
    [self.view addSubview:self.bigScrollView];
    
    //ScrollView的初始化
    _scrollDataArray = [NSMutableArray array];
    
    //collectionview的初始化，默认初始化第一页
    _collectionDataArray = [NSMutableArray array];
    _collection1DataArray = [NSMutableArray array];
    _collection2DataArray = [NSMutableArray array];
    _collection3DataArray = [NSMutableArray array];
    _collection4DataArray = [NSMutableArray array];
    _collection5DataArray = [NSMutableArray array];
    [self initCollectionView];
    [self getCollectionData:Collection1_API];
}

#pragma mark 大的scrollView的懒加载
- (UIScrollView *)bigScrollView
{
    if(nil == _bigScrollView)
    {
        _bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
        _bigScrollView.delegate = self;
        _bigScrollView.contentSize = CGSizeMake(5*SCREENW, 0);
        _bigScrollView.pagingEnabled = YES;
    }
    return _bigScrollView;
}

#pragma mark btnList的初始化
- (void)initWithBtnListView
{
    _btnListView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 30)];
    NSArray *btnTitle = @[@"精选",@"周末逛店",@"尝美食",@"体验课",@"周边游"];
    NSInteger count = btnTitle.count;
    
    for(int i=0;i<count;i++)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*SCREENW/5, 0, SCREENW/5, 30)];
        [btn setTitle:btnTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor greenColor];
        btn.tag = 20+i;
        if(i == 0)
        {
            //默认第一个按钮被选中
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _button = btn;
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(changeCollectionView:) forControlEvents:UIControlEventTouchUpInside];
        
        [_btnListView addSubview:btn];
    }
        [self.view addSubview:_btnListView];
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_btnListView.frame)-2, SCREENW/5, 2)];
    _bottomLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:_bottomLine];
}

- (void)changeCollectionView:(UIButton *)btn
{
    
    NSLog(@"------------");
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _bigScrollView.contentOffset = CGPointMake((btn.tag-20)*SCREENW, 0);
    [UIView animateWithDuration:0.5 animations:^{
        _bottomLine.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(_btnListView.frame)-2, SCREENW/5, 2);
    }];
}

#pragma mark 滚动视图ScrollView
- (void)getScrollData
{
    [HTTPServiceSession serviceSessionWithUrlStr:SCROLL_API andDataBlock:^(NSData *receiveData, NSError *error) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dict[@"data"][@"banners"];
        for(NSDictionary *dict in array)
        {
            NSArray *temp = [NSArray array];
            NSLog(@"%@",dict);
            DataModel *model = [[DataModel alloc] initWithDictionary:dict error:nil];
            NSLog(@"%@",model.target);
            DataModelTarget *modelT = [[DataModelTarget alloc] initWithDictionary:model.target error:nil];
            NSLog(@"%@",modelT.banner_image_url);
            temp = @[model,modelT];
            [_scrollDataArray addObject:temp];
        }
        dispatch_async(dispatch_get_main_queue(),^{
            [self updataInScrollView];;
        });
    }];
}

- (UIScrollView *)createScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCROLL_H)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    return _scrollView;
}

- (void)updataInScrollView
{
    NSInteger count = _scrollDataArray.count;
    for(int i=0;i<count;i++)
    {
        if(i == 0)
        {
            DataModel *model = _scrollDataArray[count-1][0];
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCROLL_H)];
            [imageV sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
            [_scrollView addSubview:imageV];
        }
        if(i == count-1)
        {
            DataModel *model = _scrollDataArray[0][0];
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((count+1)*SCREENW, 0, SCREENW, SCROLL_H)];
            [imageV sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
            [_scrollView addSubview:imageV];
        }
        DataModel *model = _scrollDataArray[i][0];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((i+1)*SCREENW, 0, SCREENW, SCROLL_H)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
        imageV.userInteractionEnabled = YES;
        imageV.tag = 1+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageVInScrollView:)];
        [imageV addGestureRecognizer:tap];
        [_scrollView addSubview:imageV];
    }
    _scrollView.contentOffset = CGPointMake(SCREENW, 0);
    _scrollView.contentSize = CGSizeMake((_scrollDataArray.count+2)*SCREENW, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([scrollView isEqual:_scrollView])
    {
        NSInteger count = _scrollDataArray.count;
        if(scrollView.contentOffset.x/SCREENW == 0)
        {
            [scrollView setContentOffset:CGPointMake(count*SCREENW, 0)];
        }
        if(scrollView.contentOffset.x/SCREENW == count+1)
        {
            [scrollView setContentOffset:CGPointMake(SCREENW, 0)];
        }
    }
    if([scrollView isEqual:_bigScrollView])
    {
        if(_bigScrollView.contentOffset.x/SCREENW == 0)
        {
            [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn = [_btnListView viewWithTag:20+scrollView.contentOffset.x/SCREENW];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.5 animations:^{
                _bottomLine.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(_btnListView.frame)-2, SCREENW/5, 2);
            }];
            _button = btn;
            [self getCollectionData:Collection1_API];
        }
        if(_bigScrollView.contentOffset.x/SCREENW == 1)
        {
            [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn = [_btnListView viewWithTag:20+scrollView.contentOffset.x/SCREENW];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.5 animations:^{
                _bottomLine.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(_btnListView.frame)-2, SCREENW/5, 2);
            }];
            _button = btn;
            [self getCollectionData:Collection2_API];
        }
        if(_bigScrollView.contentOffset.x/SCREENW == 2)
        {
            [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn = [_btnListView viewWithTag:20+scrollView.contentOffset.x/SCREENW];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.5 animations:^{
                _bottomLine.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(_btnListView.frame)-2, SCREENW/5, 2);
            }];
            _button = btn;
            [self getCollectionData:Collection3_API];
        }
        if(_bigScrollView.contentOffset.x/SCREENW == 3)
        {
            [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn = [_btnListView viewWithTag:20+scrollView.contentOffset.x/SCREENW];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.5 animations:^{
                _bottomLine.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(_btnListView.frame)-2, SCREENW/5, 2);
            }];
            _button = btn;
            [self getCollectionData:Collection4_API];
        }
        if(_bigScrollView.contentOffset.x/SCREENW == 4)
        {
            [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            UIButton *btn = [_btnListView viewWithTag:20+scrollView.contentOffset.x/SCREENW];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [UIView animateWithDuration:0.5 animations:^{
                _bottomLine.frame = CGRectMake(btn.frame.origin.x, CGRectGetMaxY(_btnListView.frame)-2, SCREENW/5, 2);
            }];
            _button = btn;
            [self getCollectionData:Collection5_API];
        }
        
    }
}

- (void)tapImageVInScrollView:(UITapGestureRecognizer *)tap
{
    if(tap.view.tag == 1)
    {
        NSLog(@"1");
    }
    if(tap.view.tag == 2)
    {
        NSLog(@"2");
    }
    if(tap.view.tag == 3)
    {
        NSLog(@"3");
    }
}


#pragma mark collectionview的初始化
- (void)initCollectionView
{
    for(int i=0;i<5;i++)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(SCREENW, 210);
        flowLayout.minimumLineSpacing = 20;
        UICollectionView *collec = [[UICollectionView alloc] initWithFrame:CGRectMake(i*SCREENW, 30, SCREENW, SCREENH-_btnListView.frame.size.height-113) collectionViewLayout:flowLayout];
        collec.backgroundColor = [UIColor whiteColor];
        collec.delegate = self;
        collec.dataSource = self;
        [collec registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"cell_%d",i]];
        switch (i)
        {
            case 0:
            {
                [collec registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reuseID"];
                self.collectionView1 = collec;
            }
                break;
            case 1:
                self.collectionView2 = collec;
                break;
            case 2:
                self.collectionView3 = collec;
                break;
            case 3:
                self.collectionView4 = collec;
                break;
            case 4:
                self.collectionView5 = collec;
                break;
            default:
                break;
        }
        [self.bigScrollView addSubview:collec];
    }
}

- (void)getCollectionData:(NSString *)urlStr
{
    [HTTPServiceSession serviceSessionWithUrlStr:urlStr andDataBlock:^(NSData *receiveData, NSError *error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dictionary[@"data"][@"items"];
        if(_collectionDataArray.count != 0)
        {
            [_collectionDataArray removeAllObjects];
        }
        for(NSDictionary *dict in array)
        {
            CollectionModel *model = [[CollectionModel alloc] initWithDictionary:dict error:nil];
            [_collectionDataArray addObject:model];
        }
        if(_bigScrollView.contentOffset.x/SCREENW == 0)
        {
            _collection1DataArray = _collectionDataArray;
            dispatch_async(dispatch_get_main_queue(),^{
                [self.collectionView1 reloadData];
            });
        }
        if(_bigScrollView.contentOffset.x/SCREENW == 1)
        {
            _collection2DataArray = _collectionDataArray;
            dispatch_async(dispatch_get_main_queue(),^{
                [self.collectionView2 reloadData];
            });
        }
        if(_bigScrollView.contentOffset.x/SCREENW == 2)
        {
            _collection3DataArray = _collectionDataArray;
            dispatch_async(dispatch_get_main_queue(),^{
                [self.collectionView3 reloadData];
            });
        }
        if(_bigScrollView.contentOffset.x/SCREENW == 3)
        {
            _collection4DataArray = _collectionDataArray;
            dispatch_async(dispatch_get_main_queue(),^{
                [self.collectionView4 reloadData];
            });
        }
        if(_bigScrollView.contentOffset.x/SCREENW == 4)
        {
            _collection5DataArray = _collectionDataArray;
            dispatch_async(dispatch_get_main_queue(),^{
                [self.collectionView5 reloadData];
            });
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _collectionDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 210)];
    vw.backgroundColor = [UIColor grayColor];
    if([collectionView isEqual:self.collectionView1])
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_0" forIndexPath:indexPath];
        CollectionModel *model = _collectionDataArray[indexPath.item];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, SCREENW, 20)];
        NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:[model.created_at intValue]];
        label1.text = [NSString stringWithFormat:@"%@",createTime];
        [vw addSubview:label1];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 30, SCREENW-10, 150)];
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
    if([collectionView isEqual:self.collectionView2])
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_1" forIndexPath:indexPath];
        CollectionModel *model = _collection2DataArray[indexPath.item];
//        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, SCREENW, 20)];
//        NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:[model.created_at intValue]];
//        label1.text = [NSString stringWithFormat:@"%@",createTime];
//        [vw addSubview:label1];
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
    if([collectionView isEqual:self.collectionView3])
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_2" forIndexPath:indexPath];
        CollectionModel *model = _collection3DataArray[indexPath.item];
//        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, SCREENW, 20)];
//        NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:[model.created_at intValue]];
//        label1.text = [NSString stringWithFormat:@"%@",createTime];
//        [vw addSubview:label1];
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
    if([collectionView isEqual:self.collectionView4])
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_3" forIndexPath:indexPath];
        CollectionModel *model = _collection4DataArray[indexPath.item];
//        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, SCREENW, 20)];
//        NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:[model.created_at intValue]];
//        label1.text = [NSString stringWithFormat:@"%@",createTime];
//        [vw addSubview:label1];
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
    if([collectionView isEqual:self.collectionView5])
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell_4" forIndexPath:indexPath];
        CollectionModel *model = _collection5DataArray[indexPath.item];
//        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, SCREENW, 20)];
//        NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:[model.created_at intValue]];
//        label1.text = [NSString stringWithFormat:@"%@",createTime];
//        [vw addSubview:label1];
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
    return nil;
}

//头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([collectionView isEqual:self.collectionView1])
    {
        if([kind isEqualToString:UICollectionElementKindSectionHeader])
        {
            UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reuseID" forIndexPath:indexPath];
            [header addSubview:[self createScrollView]];
            [self getScrollData];
            return header;
        }
    }
    return nil;
}

//头视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if([collectionView isEqual:self.collectionView1])
    {
        return CGSizeMake(SCREENW, 170);
    }
    return CGSizeZero;
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
