//
//  HTTPServiceSession.m
//  NSURLSession
//
//  Created by Anker Xiao on 16/6/16.
//  Copyright © 2016年 Anker Xiao. All rights reserved.
//

#import "HTTPServiceSession.h"

@interface HTTPServiceSession ()

@property (nonatomic,copy) DataBlock myBlock;

@end

@implementation HTTPServiceSession

- (instancetype)initWithUrlStr:(NSString *)urlStr
{
    if(self = [super init])
    {
        //1.处理链接
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:urlStr];
        
        //2.创建请求类
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
        
        //3.创建session
        /*
         //缓存文件
         + (NSURLSessionConfiguration *)defaultSessionConfiguration;
         
         //放在内存中，不做缓存
         + (NSURLSessionConfiguration *)ephemeralSessionConfiguration;
         
         //后天下载
         + (NSURLSessionConfiguration *)backgroundSessionConfigurationWithIdentifier:(NSString *)identifier
         */
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        //这个参数代表我们的数据它的保存方式是什么样子的
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//        NSURLSession *session = [NSURLSession sharedSession];
        //4.设置任务类型
//        NSURLSessionDownloadTask //下载
//        NSURLSessionUploadTask //上传
//        NSURLSessionDataTask;  //获取数据
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(self.myBlock)
            {
                self.myBlock(data,error);
            }
        }];
        
        //5.启动任务 这个不能省略
        [dataTask resume];
        
        
    }
    return self;
}

+ (instancetype)serviceSessionWithUrlStr:(NSString *)urlStr andDataBlock:(DataBlock)block
{
    HTTPServiceSession *session = [[HTTPServiceSession alloc]initWithUrlStr:urlStr];
    session.myBlock = block;
    return session;
}

@end
