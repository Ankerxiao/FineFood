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


#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

#define COLLECTION_API @"http://api.guozhoumoapp.com/v1/collections?limit=6&offset=0"
#define CHANNELS_API @"http://api.guozhoumoapp.com/v1/channel_groups/all"

@interface ThreeVC () <UIScrollViewDelegate>
{
    NSMutableArray *_topViewArray;
}
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIScrollView *topScrollView;
@end

@implementation ThreeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //成员变量的初始化
    _topViewArray = [NSMutableArray array];
    
    [self initScrollView];
    
    
    [self getData:COLLECTION_API];
}

#pragma mark 请求数据
- (void)getData:(NSString *)urlStr
{
    [HTTPServiceSession serviceSessionWithUrlStr:urlStr andDataBlock:^(NSData *receiveData, NSError *error) {
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
    
}

#pragma mark 频道二
- (void)createChannelTwo
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
