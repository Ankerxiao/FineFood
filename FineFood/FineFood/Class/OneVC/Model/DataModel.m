//
//  DataModel.m
//  FineFood
//
//  Created by Anker Xiao on 16/7/16.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

+ (JSONKeyMapper *)keyMapper
{
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"identifier"}];
    return mapper;
}

@end
