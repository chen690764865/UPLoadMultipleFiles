//
//  UPLoadManager.h
//  POST请求加强 - 上传多个文件
//
//  Created by chenchen on 16/8/8.
//  Copyright © 2016年 chenchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPLoadManager : NSObject

/**
 *  全局访问点
 *
*/
+ (instancetype)sharedManager;

/**
 *  上传多个文件
 */
- (void)uploadFileWithUrlString:(NSString*)urlString serverName:(NSString*)serverName filePaths:(NSArray<NSString*>*)filePaths parameters:(NSDictionary*)parameters completionHandler:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))completionHandler;

/**
 *  上传单个文件
 */
- (void)uploadFileWithUrlString:(NSString*)urlString serverName:(NSString*)serverName filePath:(NSString*)filePath parameters:(NSDictionary*)parameters completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*))completionHandler;
@end
