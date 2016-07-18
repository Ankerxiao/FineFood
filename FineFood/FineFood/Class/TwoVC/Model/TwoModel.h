//
//  TwoModel.h
//  FineFood
//
//  Created by Anker Xiao on 16/7/18.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TwoModel : JSONModel
@property (nonatomic,copy) NSString *cover_image_url;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *favorites_count;
@property (nonatomic,copy) NSString *identifier;
@end
