//
//  LLTableViewController.h
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#import "LLBaseViewController.h"
//#import "LLNetWorking.h"
//#import "Utility.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLTableViewController : LLBaseViewController

@property(nonatomic,strong)UITableView* _Nullable tableview;
//数据源
@property(nonatomic,strong)NSMutableArray* _Nullable datasource;
//分页
@property(nonatomic,assign)NSInteger pageIndex;
//是否支持mj header刷新
@property(nonatomic,assign)BOOL isMJHeaderRefresh;
//是否支持mj footer刷新
@property(nonatomic,assign)BOOL isMJFooterRefresh;

#pragma mark - 网络请求
-(void)GetWithUrlStr:(NSString*_Nullable)urlStr
               param:(NSDictionary*_Nullable)para
             showHud:(BOOL)showHud
            resCache:(void (^_Nullable)( id _Nullable cacheData))resCache
             success:(void(^_Nonnull)(id _Nullable res))successBlock
              falsed:(void(^_Nonnull)(NSError *_Nullable error))falsedBlock;

-(void)PostWithUrlStr:(NSString*_Nullable)urlStr
                param:(NSDictionary*_Nullable)para
              showHud:(BOOL)showHud
             resCache:(void (^_Nullable)( id _Nullable cacheData))resCache
              success:(void(^_Nonnull)(id _Nullable res))successBlock
               falsed:(void(^_Nonnull)(NSError *_Nullable error))falsedBlock;

//取消当前控制器正在进行的网络请求
-(void)forceStopVCNetWorkings;

//vc需要重新网络请求(在token过期处理结束后，当前vc调用这个虚函数)
-(void)shouldReloadData;


//streamDic 必须是   string:data 这种数据
//-(void)uploadStreamFilePostWithUrl:(NSString*)subUrlStr streamFiles:(NSDictionary*)streamFilesDic otherParams:(NSDictionary*)params;

/////上传一组图片 (一组是 用户一次选取若干张图片的动作)
-(void)uploadOneGrounpImgWithURL:(NSString *_Nonnull)URL
                      parameters:(NSDictionary *_Nullable)parameters
                            name:(NSString *_Nullable)name
                          images:(NSArray *_Nonnull)images
                        progress:(HttpProgress _Nullable )progres
                         success:(HttpRequestSuccess _Nullable )success
                         failure:(HttpRequestFailed _Nullable )failure;

/////上传两组图片 (一组是 用户一次选取若干张图片的动作)
//-(void)uploadTwoGroupImgWithURL:(NSString *_Nonnull)URL
//                     parameters:(NSDictionary *_Nullable)parameters
//                          name1:(NSString *_Nullable)name1
//                        images1:(NSArray *_Nonnull)images1
//                          name2:(NSString *_Nullable)name2
//                        images2:(NSArray *_Nonnull)images2
//                       progress:(HttpProgress _Nullable )progres
//                        success:(HttpRequestSuccess _Nullable )success
//                        failure:(HttpRequestFailed _Nullable )failure;


-(void)loading;

-(void)loadingMessage:(NSString*)msg;

-(void)stopLoading;

@end

NS_ASSUME_NONNULL_END
