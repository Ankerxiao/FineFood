//
//  DataModelTarget.h
//  FineFood
//
//  Created by Anker Xiao on 16/7/16.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DataModelTarget : JSONModel
@property (nonatomic,copy) NSString <Optional> *banner_image_url;
@property (nonatomic,copy) NSString <Optional> *cover_image_url;
@property (nonatomic,copy) NSString <Optional> *created_at;
@property (nonatomic,copy) NSString <Optional> *identifier;
@property (nonatomic,copy) NSString <Optional> *posts_count;
@property (nonatomic,copy) NSString <Optional> *status;
@property (nonatomic,copy) NSString <Optional> *subtitle;
@property (nonatomic,copy) NSString <Optional> *title;
@property (nonatomic,copy) NSString <Optional> *updated_at;
@end
