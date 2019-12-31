//
//  ClearCacheTool.h
//  600生活
//
//  Created by iOS on 2019/11/14.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage.h> //清理SDWebImage的缓存

NS_ASSUME_NONNULL_BEGIN

/*
 //1.获取沙盒数据容器根目录
    NSString *homePath = NSHomeDirectory();
    NSLog(@"home根目录:%@", homePath);
 //2.获取Documents路径
     NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"documens路径:%@", documentPath);
//3.获取Library路径
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"libaray路径:%@", libraryPath);
//4.获取tmp路径
    NSString *tmpPath = NSTemporaryDirectory();
    NSLog(@"tmp路径：%@", tmpPath);
*/

@interface ClearCacheTool : NSObject

/*s*
 *  获取path路径下文件夹的大小
 *
 *  @param path 要获取的文件夹 路径
 *
 *  @return 返回path路径下文件夹的大小
 */
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path;
 
/**
 *  清除path路径下文件夹的缓存
 *
 *  @param path  要清除缓存的文件夹 路径
 *
 *  @return 是否清除成功
 */
+ (BOOL)clearCacheWithFilePath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
