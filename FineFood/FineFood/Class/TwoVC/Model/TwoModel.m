//
//  TwoModel.m
//  FineFood
//
//  Created by Anker Xiao on 16/7/18.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "TwoModel.h"

@implementation TwoModel
+ (JSONKeyMapper *)keyMapper
{
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"identifier"}];
    return mapper;
}
@end
