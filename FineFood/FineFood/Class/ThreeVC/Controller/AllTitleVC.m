//
//  AllTitleVC.m
//  FineFood
//
//  Created by Anker Xiao on 16/7/19.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "AllTitleVC.h"
#import "DataModelTarget.h"
#import <UIImageView+WebCache.h>
#import "ThreeCollectionVC.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface AllTitleVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation AllTitleVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    DataModelTarget *model = self.dataArray[indexPath.section];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENW/2)];
    [imageV sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url]];
    imageV.alpha = 0.7;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENW/2)];
    label.center = CGPointMake(SCREENW/2, SCREENW/4);
    if(indexPath.section == 0)
    {
        label.text = @"体验课";
    }
    if(indexPath.section == 1)
    {
        label.text = @"下厨房";
    }
    if(indexPath.section == 2)
    {
        label.text = @"周末宅家";
    }
    if(indexPath.section == 3)
    {
        label.text = @"夏夜微风";
    }
    [label setFont:[UIFont systemFontOfSize:30]];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [imageV addSubview:label];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = imageV;
//    cell.backgroundView
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREENW/2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        ThreeCollectionVC *vc = [[ThreeCollectionVC alloc] init];
        vc.str = [NSString stringWithFormat:@"%ld",indexPath.section];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(indexPath.section == 1)
    {
        ThreeCollectionVC *vc = [[ThreeCollectionVC alloc] init];
        vc.str = [NSString stringWithFormat:@"%ld",indexPath.section];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(indexPath.section == 2)
    {
        ThreeCollectionVC *vc = [[ThreeCollectionVC alloc] init];
        vc.str = [NSString stringWithFormat:@"%ld",indexPath.section];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(indexPath.section == 3)
    {
        ThreeCollectionVC *vc = [[ThreeCollectionVC alloc] init];
        vc.str = [NSString stringWithFormat:@"%ld",indexPath.section];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
