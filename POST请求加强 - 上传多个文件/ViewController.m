//
//  ViewController.m
//  POST请求加强 - 上传多个文件
//
//  Created by chenchen on 16/8/7.
//  Copyright © 2016年 chenchen. All rights reserved.
//

#import "UPLoadManager.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{

    [self demo];
    //    [self uploadFileWithServerName:@"userfile[]" filePaths:filePaths parameters:dict];
}

- (void)demo
{

    //获取图片路径
    NSString* path1 = [[NSBundle mainBundle] pathForResource:@"lswzdbdaa4ASU4uy97Y.jpg" ofType:nil];
    NSString* path2 = [[NSBundle mainBundle] pathForResource:@"eb34bcc379310a5541a83380b54543a98226103c.jpg" ofType:nil];

    //URL地址
    NSString* urlString = @"http://127.0.0.1/myWeb/php/upload/upload-m.php";

    //使用数组保存图片路径
    NSArray* filePaths = @[ path1, path2 ];

    //文字内容
    NSDictionary* dict = @{ @"status" : @"剑圣" };

    //服务器名称
    NSString* serverName = @"userfile[]";

    //上传单个文件
    [[UPLoadManager sharedManager] uploadFileWithUrlString:urlString serverName:serverName filePath:path1 parameters:dict completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError) {

        //判断请求失败
        if (connectionError != nil || data.length == 0) {
            NSLog(@"请求数据失败 %@", connectionError);
            return;
        }
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"请求数据成功 %@", result);

    }];

    //上传多个文件
    //    //获取文件管理类的单例对象
    //    [[UPLoadManager sharedManager] uploadFileWithUrlString:urlString serverName:serverName filePaths:filePaths parameters:dict completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError) {
    //
    //        //判断请求失败
    //        if (connectionError != nil || data.length == 0) {
    //            NSLog(@"请求数据失败 %@", connectionError);
    //            return;
    //        }
    //        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    //        NSLog(@"请求数据成功 %@", result);
    //    }];
}

//- (void)uploadFileWithServerName:(NSString*)serverName filePaths:(NSArray<NSString*>*)filePaths parameters:(NSDictionary*)parameters
//{
//
//    //URL地址
//    NSURL* url = [NSURL URLWithString:@"http://127.0.0.1/myWeb/php/upload/upload-m.php"];
//
//    //可变的请求
//    NSMutableURLRequest* requestM = [NSMutableURLRequest requestWithURL:url];
//    //设置请求方式 使用POST请求
//    requestM.HTTPMethod = @"POST";
//
//    //设置请求头
//    [requestM setValue:@"multipart/form-data; boundary=chenchen" forHTTPHeaderField:@"Content-Type"];
//    //设置请求体
//    requestM.HTTPBody = [self httpbodyWithServerName:serverName filePaths:filePaths parameters:parameters];
//
//    //发送请求
//    [NSURLConnection sendAsynchronousRequest:requestM queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError) {
//
//        //判断请求失败
//        if (connectionError != nil || data.length == 0) {
//            NSLog(@"请求数据失败 %@", connectionError);
//            return;
//        }
//        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//        NSLog(@"请求数据成功 %@", result);
//
//    }];
//}

/**
 *  设置请求体
 */
//- (NSData*)httpbodyWithServerName:(NSString*)serverName filePaths:(NSArray<NSString*>*)filePaths parameters:(NSDictionary*)parameters
//{
//
//    //初始化可变二进制数据,用于拼接二进制数据
//    NSMutableData* dataM = [NSMutableData data];
//
//    //遍历文件路径进行拼接
//    [filePaths enumerateObjectsUsingBlock:^(NSString* _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
//        //初始化可变字符串
//        NSMutableString* stringM = [NSMutableString string];
//        //1.开始的边界 边界开头的\r\n不能少
//        [stringM appendString:@"\r\n--chenchen\r\n"];
//        //2.Content-Disposition: form-data
//        [stringM appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", serverName, [obj lastPathComponent]];
//        //3.Content-Type 告诉服务器上传的数据类型
//        [stringM appendString:@"Content-Type: application/octet-stream\r\n"];
//        //4.单纯的回车换行
//        [stringM appendString:@"\r\n"];
//        //5.把可变字符串转换为二进制数据,拼接到可变的二进制数据里面
//        NSData* data = [stringM dataUsingEncoding:NSUTF8StringEncoding];
//        [dataM appendData:data];
//        //6.和图片的二进制数据进行拼接
//        [dataM appendData:[NSData dataWithContentsOfFile:obj]];
//    }];
//
//    //拼接一个文字信息
//    //遍历parameters
//    //    for (NSDictionary* content in parameters) {
//
//    //遍历数组得到的是每一个内容的字典
//    //block遍历字典,得到key和value
//    NSLog(@"文字内容是:%@",parameters);
//    [parameters enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL* _Nonnull stop) {
//
//        //初始化可变字符串
//        NSMutableString* stringM = [NSMutableString string];
//
//        //1.拼接边界
//        [stringM appendString:@"\r\n--chenchen\r\n"];
//        //2.拼接Content-Disposition
//        [stringM appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
//        //3.拼接单独的换行
//        [stringM appendString:@"\r\n"];
//        //4.拼接文字内容
//        [stringM appendFormat:@"%@\r\n", obj];
//        //5.把拼接的字符串转换为二进制数据拼接到可变的二进制数据里面
//        [dataM appendData:[stringM dataUsingEncoding:NSUTF8StringEncoding]];
//    }];
//    //    }
//    //拼接结尾
//    [dataM appendData:[@"--chenchen--" dataUsingEncoding:NSUTF8StringEncoding]];
//
//    //返回拼接好的二进制数据
//    return [dataM copy];
//}

@end
