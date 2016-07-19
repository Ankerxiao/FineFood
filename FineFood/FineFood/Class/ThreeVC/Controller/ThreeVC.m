//
//  ThreeVC.m
//  FineFood
//
//  Created by Anker Xiao on 16/7/16.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "ThreeVC.h"
#import "HTTPServiceSession.h"
#import <UIImageView+WebCache.h>
#import "DataModelTarget.h"
#import "ThreeModel.h"


#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

#define COLLECTION_API @"http://api.guozhoumoapp.com/v1/collections?limit=6&offset=0"
#define CHANNELS_API @"http://api.guozhoumoapp.com/v1/channel_groups/all"

@interface ThreeVC () <UIScrollViewDelegate>
{
    NSMutableArray *_topViewArray;
    NSMutableArray *_channel1Array;
    NSMutableArray *_channel2Array;
}
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIScrollView *topScrollView;
@property (nonatomic,strong) UIView *backOneView;
@property (nonatomic,strong) UIView *backTwoView;
@end

@implementation ThreeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //成员变量的初始化
    _topViewArray = [NSMutableArray array];
    _channel1Array = [NSMutableArray array];
    _channel2Array = [NSMutableArray array];
    
    [self initScrollView];
    
    
    [self getData:COLLECTION_API];
    [self getData:CHANNELS_API];
}

#pragma mark 请求数据
- (void)getData:(NSString *)urlStr
{
    [HTTPServiceSession serviceSessionWithUrlStr:urlStr andDataBlock:^(NSData *receiveData, NSError *error) {
        
        //topScrollView
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingAllowFragments error:nil];
        NSArray *tempArray = dictionary[@"data"][@"collections"];
        NSMutableArray *tempMu = [NSMutableArray array];
        for(NSDictionary *dict in tempArray)
        {
            DataModelTarget *model = [[DataModelTarget alloc] initWithDictionary:dict error:nil];
            [tempMu addObject:model];
        }
        _topViewArray = tempMu;
        dispatch_async(dispatch_get_main_queue(),^{
            [self updateTopScrollView];
        });
        
        //频道图片
        NSDictionary *dictionary2 = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingAllowFragments error:nil];
        NSArray *allChannel = dictionary2[@"data"][@"channel_groups"];
        NSDictionary *dict1 = allChannel[0];
        NSDictionary *dict2 = allChannel[1];
        NSArray *array1 = dict1[@"channels"];
        NSArray *array2 = dict2[@"channels"];
        
        NSMutableArray *tempChannel1 = [NSMutableArray array];
        for(NSDictionary *dic1 in array1)
        {
            ThreeModel *model = [[ThreeModel alloc] initWithDictionary:dic1 error:nil];
            [tempChannel1 addObject:model];
        }
        _channel1Array = tempChannel1;
        
        NSMutableArray *tempChannel2 = [NSMutableArray array];
        for(NSDictionary *dic2 in array2)
        {
            ThreeModel *model = [[ThreeModel alloc] initWithDictionary:dic2 error:nil];
            [tempChannel2 addObject:model];
        }
        _channel2Array = tempChannel2;
        dispatch_async(dispatch_get_main_queue(),^{
            [self updateChannelOne];
            [self updateChannelTwo];
        });
    }];
    
}

#pragma mark 初始化大的ScrollView
- (void)initScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH )];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    //初始化第一个view
    [self createOneView];
    
    //初始化频道一
    [self createChannelOne];
    
    //初始化频道二
    [self createChannelTwo];
}


#pragma mark 第一个view
- (void)createOneView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, 140)];
    backView.backgroundColor = [UIColor greenColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREENW/2, 30)];
    label.text = @"专题合集";
    [backView addSubview:label];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENW-110, 10, 100, 30)];
    [btn setTitle:@"查看全部>" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [backView addSubview:btn];
    
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame)+10, SCREENW, 80)];
    _topScrollView.showsHorizontalScrollIndicator = NO;
    [backView addSubview:_topScrollView];
    
    [_scrollView addSubview:backView];
}

- (void)updateTopScrollView
{
    NSInteger count = _topViewArray.count;
    for(int i=0;i<count;i++)
    {
        DataModelTarget *model = _topViewArray[i];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*(SCREENW/2+10), 0, SCREENW/2, 80)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:model.banner_image_url]];
        imageV.layer.cornerRadius = 10;
        imageV.layer.masksToBounds = YES;
        [_topScrollView addSubview:imageV];
    }
    _topScrollView.contentSize = CGSizeMake(2*SCREENW+50, 0);
}

#pragma mark 频道一
- (void)createChannelOne
{
    _backOneView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, SCREENW, 160)];
    _backOneView.backgroundColor = [UIColor redColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREENW, 30)];
    label.text = @"宅家";
    [_backOneView addSubview:label];
    
    NSArray *titleArr = @[@"DIY",@"下厨",@"电影",@"聚会"];
    for(int i=0;i<4;i++)
    {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30+i*SCREENW/4, 135,SCREENW/4,20)];
        title.text = titleArr[i];
        [_backOneView addSubview:title];
    }
    
    [_scrollView addSubview:_backOneView];
}

- (void)updateChannelOne
{
    NSInteger count = _channel1Array.count;
    for(int i=0;i<count;i++)
    {
        ThreeModel *model = _channel1Array[i]; //程序运行多次，在此会崩溃，数组元素为空
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5+i*SCREENW/4, 40, SCREENW/4-10, SCREENW/4-10)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
        imageV.layer.cornerRadius = 10;
        imageV.layer.masksToBounds = YES;
        [_backOneView addSubview:imageV];
    }
}

#pragma mark 频道二
- (void)createChannelTwo
{
    
}

- (void)updateChannelTwo
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
