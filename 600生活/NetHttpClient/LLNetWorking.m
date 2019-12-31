//
//  LLNetWorking.m
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#import "LLNetWorking.h"
#import "NSString+ext.h"

@interface LLNetWorking()
{
    AFHTTPSessionManager*  _manager;  //初始化后为子类PGNetAPIClient的对象
}

@end

@implementation LLNetWorking


+(LLNetWorking*_Nonnull)sharedWorking
{
    static LLNetWorking* working = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        working = [[LLNetWorking alloc]init];
        working.netStatu = 0xffff;  //初始化网络状态 默认值为网络正常
        [PGNetAPIClient baseUrl:kFirstUrl];
        [PGNetAPIClient policyWithPinningMode:0];
        [working configSessionManager]; //配置
        if ( [LLUserManager shareManager].currentUser.token.length > 0) {
            [working updataHttpHeaderWithToken:[LLUserManager shareManager].currentUser.token];
        }
    });
    
    return working;
}

//配置 sessionmanager
-(void)configSessionManager
{
    if(!_manager){
        _manager = [PGNetworkHelper manager];
        
        
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"json/text",@"multipart/form-data", nil];// @"text/json", @"text/javascript",@"text/html",@"text/plain",
        
        
        //设置超时， 貌似af3.0 超时代码必须放在上面代码的下面位置
        [_manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _manager.requestSerializer.timeoutInterval = kTimeOutInterval;
        [_manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        //SSL安全策略
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.validatesDomainName = NO;
        securityPolicy.allowInvalidCertificates = YES;
        _manager.securityPolicy = securityPolicy;
        
        
        //http header
        if(kIsIPhone()) {
             [_manager.requestSerializer setValue:@"ipad" forHTTPHeaderField:@"XX-Device-Type"];
        } else {
              [_manager.requestSerializer setValue:@"iphone" forHTTPHeaderField:@"XX-Device-Type"];
        }
    }
}

//更新 header
-(void)updataHttpHeaderWithToken:(NSString*)newTokenStr
{
    [_manager.requestSerializer setValue:newTokenStr forHTTPHeaderField:@"XX-Token"];
    [PGNetworkCache pathName:newTokenStr];//缓存绑定
}


//GET
-(NSURLSessionTask*_Nullable)GET:(NSString*_Nonnull)UrlStr
                           param:(id _Nullable )param
                        resCache:(void (^)( id cacheData))resCache
                         success:(void (^)(id res))success
                         failure:(void (^)(NSError *error))failure
{
    //网络异常
    if(self.netStatu <= 0){
        return nil;
    }
    
    //处理参数中的异常字符串
    NSDictionary* dic = param;
    NSMutableDictionary* mutDic = [NSMutableDictionary new];
    for(NSString* key in [dic allKeys]){
        [mutDic setObject:[NSString safetyStringByObject:dic[key]]  forKey:key];
    }
    
    //开始请求
    NSURLSessionTask* task = [PGNetworkHelper GET:UrlStr parameters:param cache:YES responseCache:^(id cacheData) {
        if (resCache != nil) {
            resCache(cacheData);
        }
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
        [self handleNetError];
    }];
    
    return task;
}

//POST
-(NSURLSessionTask*)Post:(NSString*)url
                   param:(id)param
                resCache:(void (^)( id cacheData))resCache
                 success:(void (^)(id res))success
                 failure:(void (^)(NSError *error))failure
{
    //网络异常
    if(self.netStatu <= 0){
        return nil;
    }

    //处理参数中的异常字符串
    NSDictionary* dic = param;
    NSMutableDictionary* mutDic = [NSMutableDictionary new];
    for(NSString* key in [dic allKeys]){
        if ([dic[key] isKindOfClass:[NSString class]]) {
            NSString* newValue = [NSString safetyStringByObject:dic[key]];
            [mutDic setObject:newValue forKey:key];
        } else {
            [mutDic setObject:dic[key] forKey:key];
        }
    }
    
    //开始请求
    NSURLSessionTask* task = [PGNetworkHelper POST:url parameters:mutDic cache:YES responseCache:^(id cacheData) {
        if(resCache != nil) {
            resCache(cacheData);
        }
    } success:^(id responseObject) {
        success( responseObject);
    } failure:^(NSError *error) {
        failure(error);
        [self handleNetError];
    }];
    return task;
}


//Delete
-(NSURLSessionTask*)Delete:(NSString*)url
                     param:(id)param
                 success:(void (^)(id res))success
                 failure:(void (^)(NSError *error))failure
{
    NSURLSessionDataTask* task = [_manager DELETE:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success( responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    return task;
}


///上传一组图片 (一组是 用户一次选取若干张图片的动作)
-(NSURLSessionDataTask* _Nullable)uploadOneGrounpImgWithURL:(NSString *_Nonnull)URL
                      parameters:(NSDictionary *_Nullable)parameters
                            name:(NSString *_Nullable)name
                          images:(NSArray *_Nonnull)images
                        progress:(HttpProgress _Nullable )progres
                         success:(HttpRequestSuccess _Nullable )success
                         failure:(HttpRequestFailed _Nullable )failure
{
  NSURLSessionDataTask* task =  [_manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
            long long totalMilliseconds = interval * 1000 ;
            NSString *fileName = [NSString stringWithFormat:@"%lld.png", totalMilliseconds];
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progres ? progres(uploadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    return task;
}

///上传两组图片 (一组是 用户一次选取若干张图片的动作)
-(NSURLSessionDataTask* _Nullable)uploadTwoGroupImgWithURL:(NSString *_Nonnull)URL
                     parameters:(NSDictionary *_Nullable)parameters
                          name1:(NSString *_Nullable)name1
                        images1:(NSArray *_Nonnull)images1
                          name2:(NSString *_Nullable)name2
                        images2:(NSArray *_Nonnull)images2
                       progress:(HttpProgress _Nullable )progres
                        success:(HttpRequestSuccess _Nullable )success
                        failure:(HttpRequestFailed _Nullable )failure
{
  NSURLSessionDataTask* task = [_manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [images1 enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
            long long totalMilliseconds = interval * 1000 ;
            NSString *fileName = [NSString stringWithFormat:@"%lld.png", totalMilliseconds];
            [formData appendPartWithFileData:imageData name:name1 fileName:fileName mimeType:@"image/jpeg"];
        }];
       
       [images2 enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
           NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
           NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
           long long totalMilliseconds = (interval+1) * 1000 ;
           NSString *fileName = [NSString stringWithFormat:@"%lld.png", totalMilliseconds];
           [formData appendPartWithFileData:imageData name:name2 fileName:fileName mimeType:@"image/jpeg"];
       }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progres ? progres(uploadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    return task;
}



//下载文件
-(void)downloadWithURL:(NSString *)URL
               fileDir:(NSString *)fileDir
              progress:(HttpProgress)progress
               success:(void(^)(NSString *filePath))success
               failure:(HttpRequestFailed)failure
{
    [PGNetworkHelper downloadWithURL:URL fileDir:fileDir progress:progress success:^(NSString *filePath) {
        success(filePath);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//取消全部网络操作
-(void)cancelAllNetOperations
{
    [PGNetworkHelper cancelAllOperations];
}

//处理网络错误
-(void)handleNetError
{
    
}

//辅助函数 打印token和userID
-(void)helper
{
    NSLog(@"当前用户token是:%@",[_manager.requestSerializer valueForHTTPHeaderField:@"XX-Token"]);
    NSLog(@"当前用户id是:%@",[LLUserManager shareManager].currentUser.id);
}



@end

