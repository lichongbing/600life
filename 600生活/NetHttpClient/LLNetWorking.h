//
//  LLNetWorking.h
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLNetWorkingMarco.h"
#import <PGNetworkHelper/PGNetworkHelper.h> //缓存框架

NS_ASSUME_NONNULL_BEGIN

@interface LLNetWorking : NSObject

/*
 *netStatu 保存网络的状态，外部使用这个值判断网络情况 -1未知异常  0无网络  1蜂窝网 2wifi
 */
@property(nonatomic,assign)AFNetworkReachabilityStatus netStatu; //当前网络状态


+(LLNetWorking*_Nonnull)sharedWorking;

//GET
-(NSURLSessionTask*_Nullable)GET:(NSString*_Nonnull)UrlStr
                           param:(id _Nullable )param
                        resCache:(void (^_Nullable)( id _Nullable cacheData))resCache
                         success:(void (^_Nullable)(id _Nullable res))success
                         failure:(void (^_Nullable)(NSError * _Nullable error))failure;

//POST
-(NSURLSessionTask*_Nullable)Post:(NSString*_Nullable)url
                            param:(id _Nullable )param
                         resCache:(void (^_Nullable)( id _Nullable cacheData))resCache
                          success:(void (^_Nullable)(id _Nullable res))success
                          failure:(void (^_Nullable)(NSError * _Nullable error))failure;

//Delete
-(NSURLSessionTask*)Delete:(NSString*)url
                     param:(id)param
                 success:(void (^)(id res))success
                   failure:(void (^)(NSError *error))failure;

///上传一组图片 (一组是 用户一次选取若干张图片的动作)
-(NSURLSessionDataTask* _Nullable)uploadOneGrounpImgWithURL:(NSString *_Nonnull)URL
                      parameters:(NSDictionary *_Nullable)parameters
                            name:(NSString *_Nullable)name
                          images:(NSArray *_Nonnull)images
                        progress:(HttpProgress _Nullable )progres
                         success:(HttpRequestSuccess _Nullable )success
                         failure:(HttpRequestFailed _Nullable )failure;

///上传两组图片 (一组是 用户一次选取若干张图片的动作)
-(NSURLSessionDataTask* _Nullable)uploadTwoGroupImgWithURL:(NSString *_Nonnull)URL
                     parameters:(NSDictionary *_Nullable)parameters
                          name1:(NSString *_Nullable)name1
                        images1:(NSArray *_Nonnull)images1
                          name2:(NSString *_Nullable)name2
                        images2:(NSArray *_Nonnull)images2
                       progress:(HttpProgress _Nullable )progres
                        success:(HttpRequestSuccess _Nullable )success
                        failure:(HttpRequestFailed _Nullable )failure;

//下载文件
-(void)downloadWithURL:(NSString *_Nonnull)URL
               fileDir:(NSString *_Nullable)fileDir
              progress:(HttpProgress _Nullable )progress
               success:(void(^_Nullable)(NSString * _Nullable filePath))success
               failure:(HttpRequestFailed _Nullable )failure;

//取消app全部网络操作
-(void)cancelAllNetOperations;


//更新 header
-(void)updataHttpHeaderWithToken:(NSString*)newTokenStr;

//辅助函数 打印token和userID
-(void)helper;

@end

NS_ASSUME_NONNULL_END

