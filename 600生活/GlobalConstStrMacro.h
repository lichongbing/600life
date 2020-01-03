//
//  GlobalConstStrMacro.h
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#ifndef GlobalConstStrMacro_h
#define GlobalConstStrMacro_h



#pragma mark - userdefault ----------------

#define kFirstLaunch @"kFirstLaunch"    //是否首次加载
#define kCalendarUserSelectedFields @"kCalendarUserSelectedFields"  // 用户选取的区域
#define kDefaultUserIconName @"kDefaultUserIconName" //默认用户头像名
#define kDefaultImgName @"kDefaultImgName"            //默认图片名
#define kMasterRushedOrderId  @"kMasterRushedOrderId"  //导师抢到了订单
#define kIsTodaySenderMakeFreeOrder @"kIsTodaySenderMakeFreeOrder" //今天是否下过了免费单


#pragma mark - ViewTag

#define kTipViewTag 1001
#define kWindowTipViewTag 1002


#pragma mark - notifacation ----------------

// 网络状态变化通知
#define kNetStatuChangedNotification @"kNetStatuChangedNotification"

// 用户进入应用后检测粘贴板
#define kCheckUserPasteboardNofification @"kCheckUserPasteboardNofification"

//app变为活跃
#define kAppDidBecomeActiveNofification @"kAppDidBecomeActiveNofification"


#pragma mark - kvo kvc ----------------

#pragma mark - runtime ----------------

//首页 spPageMenu 加载多个子vc
#define kRunTimeViewController1SubVcShow @"kRunTimeViewController1SubVcShow"

//9块9包邮 spPageMenu 加载多个子vc
#define kRunTimeNinePointNineViewControllerSubVcShow @"kRunTimeNinePointNineViewControllerSubVcShow"

//品牌好店 spPageMenu 加载多个子vc
#define kRunTimeGoodStoreMainViewControllerSubVcShow @"kRunTimeGoodStoreMainViewControllerSubVcShow"

//我的订单 spPageMenu 加载多个子vc
#define kRunTimeOrderListViewControllerShow @"kRunTimeOrderListViewControllerShow"

//我的粉丝 spPageMenu 加载多个子vc
#define kRunTimeFansListViewControllerShow @"kRunTimeFansListViewControllerShow"

//京东Main spPageMenu 加载多个子vc
#define kRunTimeJDMainViewControllerShow @"kRunTimeJDMainViewControllerShow"

//京东特色购 spPageMenu 加载多个子vc
#define kRunTimeJDTeSeGouMainViewControllerShow @"kRunTimeJDTeSeGouMainViewControllerShow"


//faq 问题按钮绑定问题字符串
#define kRunTimeFAQQuestionButtomWithData @"kRunTimeFAQQuestionButtomWithData"



#pragma mark - open Url ----------------

//打开天猫店铺
#define kOpenTmallShop(shopId)  ([NSString stringWithFormat:@"tmall://page.tm/shop?shopId=%@",shopId])

//打开天猫商品
#define kOpenTmallGood(goodId)  ([NSString stringWithFormat:@"tmall://tmallclient/?{\"action\":\"item:id=%@\"",goodId])

//打开淘宝店铺
#define kOpenTaoBaoShop(shopId)  ([NSString stringWithFormat:@"taobao://shop.m.taobao.com/shop/shop_index.htm?shop_id=%@",shopId])

//打开淘宝商品
#define kOpenTaoBaoGood(goodId)  ([NSString stringWithFormat:@"taobao://item.taobao.com/item.htm?id=%@",goodId])


#endif /* GlobalConstStrMacro_h */
