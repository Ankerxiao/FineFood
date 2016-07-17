//
//  HTTPServiceSession.h
//  NSURLSession
//
//  Created by Anker Xiao on 16/6/16.
//  Copyright © 2016年 Anker Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DataBlock) (NSData *receiveData,NSError *error);

@interface HTTPServiceSession : NSObject
+ (instancetype)serviceSessionWithUrlStr:(NSString *)urlStr andDataBlock:(DataBlock)block;
@end
