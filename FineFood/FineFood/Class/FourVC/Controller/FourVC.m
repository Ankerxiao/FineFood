//
//  FourVC.m
//  FineFood
//
//  Created by Anker Xiao on 16/7/16.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "FourVC.h"
#import "LoginVC.h"

@interface FourVC ()

@end

@implementation FourVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    
}

- (IBAction)pressLoginBtn:(id)sender
{
    //需要判断当前是否已经登录
    
    //已登录，处理下面事情
    
    
    
    //未登录，处理下面事情
    LoginVC *lvc = [[LoginVC alloc] init];
    [self presentViewController:lvc animated:YES completion:nil];
}


- (void)presentLoginVC
{
    
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
