//
//  UPLoadManager.m
//  POST请求加强 - 上传多个文件
//
//  Created by chenchen on 16/8/8.
//  Copyright © 2016年 chenchen. All rights reserved.
//

#import "UPLoadManager.h"

@implementation UPLoadManager

+ (instancetype)sharedManager
{

    static UPLoadManager* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UPLoadManager alloc] init];
    });

    return instance;
}

/**
 *  上传单个文件
 *
 *  @param urlString         上传文件的url地址
 *  @param serverName        服务器名称
 *  @param filePath          所有文件路径的数组
 *  @param parameters        文字信息参数的数组
 *  @param completionHandler 请求的回调
 */
- (void)uploadFileWithUrlString:(NSString*)urlString serverName:(NSString*)serverName filePath:(NSString*)filePath parameters:(NSDictionary*)parameters completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))completionHandler
{

    //上传单个文件直接调用上传多个文件的方法,把当个文件以数组的形式传过去就可以了
    [self uploadFileWithUrlString:urlString serverName:serverName filePaths:@[ filePath ] parameters:parameters completionHandler:completionHandler];
}

/**
 *  上传多个文件
 *
 *  @param urlString  上传文件的url地址
 *  @param serverName 服务器名称
 *  @param filePaths  所有文件路径的数组
 *  @param parameters 文字信息参数的字典
 *  @param completionHandler 请求的回调
 */
- (void)uploadFileWithUrlString:(NSString*)urlString serverName:(NSString*)serverName filePaths:(NSArray<NSString*>*)filePaths parameters:(NSDictionary*)parameters completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))completionHandler
{

    //URL
    NSURL* url = [NSURL URLWithString:urlString];

    //可变的请求
    NSMutableURLRequest* requestM = [NSMutableURLRequest requestWithURL:url];
    //设置请求方式 使用POST请求
    requestM.HTTPMethod = @"POST";

    //设置请求头
    [requestM setValue:@"multipart/form-data; boundary=chenchen" forHTTPHeaderField:@"Content-Type"];
    //设置请求体
    requestM.HTTPBody = [self httpbodyWithServerName:serverName filePaths:filePaths parameters:parameters];

    //发送请求
    [NSURLConnection sendAsynchronousRequest:requestM queue:[NSOperationQueue mainQueue] completionHandler:completionHandler];
}

/**
 *  设置请求体
 */
- (NSData*)httpbodyWithServerName:(NSString*)serverName filePaths:(NSArray<NSString*>*)filePaths parameters:(NSDictionary*)parameters
{

    //初始化可变二进制数据,用于拼接二进制数据
    NSMutableData* dataM = [NSMutableData data];

    //遍历文件路径进行拼接
    [filePaths enumerateObjectsUsingBlock:^(NSString* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        //初始化可变字符串
        NSMutableString* stringM = [NSMutableString string];
        //1.开始的边界 边界开头的\r\n不能少
        [stringM appendString:@"\r\n--chenchen\r\n"];
        //2.Content-Disposition: form-data
        [stringM appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", serverName, [obj lastPathComponent]];
        //3.Content-Type 告诉服务器上传的数据类型
        [stringM appendString:@"Content-Type: application/octet-stream\r\n"];
        //4.单纯的回车换行
        [stringM appendString:@"\r\n"];
        //5.把可变字符串转换为二进制数据,拼接到可变的二进制数据里面
        NSData* data = [stringM dataUsingEncoding:NSUTF8StringEncoding];
        [dataM appendData:data];
        //6.和图片的二进制数据进行拼接
        [dataM appendData:[NSData dataWithContentsOfFile:obj]];
    }];

    //拼接一个文字信息
    //遍历parameters
    //    for (NSDictionary* content in parameters) {

    //遍历数组得到的是每一个内容的字典
    //block遍历字典,得到key和value
    NSLog(@"文字内容是:%@", parameters);
    [parameters enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL* _Nonnull stop) {

        //初始化可变字符串
        NSMutableString* stringM = [NSMutableString string];

        //1.拼接边界
        [stringM appendString:@"\r\n--chenchen\r\n"];
        //2.拼接Content-Disposition
        [stringM appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
        //3.拼接单独的换行
        [stringM appendString:@"\r\n"];
        //4.拼接文字内容
        [stringM appendFormat:@"%@\r\n", obj];
        //5.把拼接的字符串转换为二进制数据拼接到可变的二进制数据里面
        [dataM appendData:[stringM dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    //    }
    //拼接结尾
    [dataM appendData:[@"--chenchen--" dataUsingEncoding:NSUTF8StringEncoding]];

    //返回拼接好的二进制数据
    return [dataM copy];
}

@end
