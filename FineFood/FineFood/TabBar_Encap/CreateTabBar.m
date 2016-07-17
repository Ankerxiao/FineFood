//
//  CreateTabBar.m
//  CommonFunction
//
//  Created by Anker Xiao on 16/7/1.
//  Copyright © 2016年 Anker Xiao. All rights reserved.
//

#import "CreateTabBar.h"

@implementation CreateTabBar

+ (UITabBarController *)createTabBarControllerWithTitle:(NSArray *)titleArray andClassNameArray:(NSArray *)classNameArray andImageArray:(NSArray *)imageArray andSuffix:(NSString *)str
{
    NSMutableArray *viewControllers = [NSMutableArray array];
    NSInteger tabBarSum = titleArray.count;
    for(int i=0;i<tabBarSum;i++)
    {
        Class class = NSClassFromString([NSString stringWithFormat:@"%@%@",classNameArray[i],str]);
        UIViewController *vc = [[class alloc] init];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:titleArray[i] image:imageArray[i] selectedImage:imageArray[i]];
        vc.navigationItem.title = titleArray[i];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [viewControllers addObject:nav];
    }
    
    UITabBarController *tabBarC = [[UITabBarController alloc] init];
    tabBarC.viewControllers = viewControllers;
    return tabBarC;
}

@end
