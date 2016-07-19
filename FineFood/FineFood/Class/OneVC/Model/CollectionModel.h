//
//  CollectionModel.h
//  FineFood
//
//  Created by Anker Xiao on 16/7/17.
//  Copyright © 2016年 AnkerXiao. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CollectionModel : JSONModel
@property (nonatomic,copy) NSString <Optional> *content_url;
@property (nonatomic,copy) NSString <Optional> *cover_image_url;
@property (nonatomic,copy) NSString <Optional> *created_at;
@property (nonatomic,copy) NSString <Optional> *likes_count;
@property (nonatomic,copy) NSString <Optional> *title;
@property (nonatomic,copy) NSString <Optional> *identifier;
@property (nonatomic,copy) NSString <Optional> *url;
@end
