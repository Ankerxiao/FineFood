//
//  CreateTabBar.h
//  CommonFunction
//
//  Created by Anker Xiao on 16/7/1.
//  Copyright © 2016年 Anker Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CreateTabBar : NSObject

+ (UITabBarController *)createTabBarControllerWithTitle:(NSArray *)titleArray andClassNameArray:(NSArray *)classNameArray andImageArray:(NSArray *)imageArray andSuffix:(NSString *)str;

@end
