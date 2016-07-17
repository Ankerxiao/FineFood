//
//  DataModelTarget.m
//  FineFood
//
//  Created by Anker Xiao on 16/7/16.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import "DataModelTarget.h"

@implementation DataModelTarget
+ (JSONKeyMapper *)keyMapper
{
    JSONKeyMapper *mapper = [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"identifier"}];
    return mapper;
}
@end
