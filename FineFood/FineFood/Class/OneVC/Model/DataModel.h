//
//  DataModel.h
//  FineFood
//
//  Created by Anker Xiao on 16/7/16.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DataModel : JSONModel
@property (nonatomic,copy) NSString <Optional> *identifier;//id
@property (nonatomic,copy) NSString <Optional> *image_url;
@property (nonatomic,copy) NSString <Optional> *order;
@property (nonatomic,copy) NSString <Optional> *status;
@property (nonatomic,copy) NSDictionary <Optional> *target;
@property (nonatomic,copy) NSString <Optional> *target_id;
@property (nonatomic,copy) NSString <Optional> *target_url;
@property (nonatomic,copy) NSString <Optional> *type;
@end
