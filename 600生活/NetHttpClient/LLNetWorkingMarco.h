//
//  LLNetWorkingMarco.h
//  tomlu
//
//  Created by Tom lu on 2019/4/30.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#ifndef LLNetWorkingMarco_h
#define LLNetWorkingMarco_h

#define kTimeOutInterval 10.0

//#define kFirstUrl @"http://192.168.3.5/"     //本地测试服
//#define kFirstUrl @"https://test.lbshapp.com/"  //测试服
#define kFirstUrl @"https://api.lbshapp.com/"    //正式服

#define kBaseUrl kFirstUrl

#define kFullUrl(sub)  ([NSString stringWithFormat:@"%@%@",kBaseUrl,sub])//接口访问的完整地址

//返回状态码 0:失败。 1:成功。  10001:未登陆

//返回成功
#define kSuccessRes  (([res[@"code"] isKindOfClass:[NSNumber class]] && [res[@"code"] intValue] == 1)||([res[@"code"] isKindOfClass:[NSString class]] && [res[@"code"] isEqualToString:@"1"]))

//缓存的返回数据成功
#define kSuccessCache (([cacheData[@"code"] isKindOfClass:[NSNumber class]] && [cacheData[@"code"] intValue] == 1)||([cacheData[@"code"] isKindOfClass:[NSString class]] && [cacheData[@"code"] isEqualToString:@"1"]))

/**********************************注册登陆******************************************/

//获取手机号验证码
#define kGetValidateCode @"api/sms/send"

//登陆？注册
#define kLogin @"/api/user/login"

//注册隐私协议
#define kUserPrivccy @"api/common/userPrivccy"

//用户填写邀请码
#define kInviteCode @"api/user/invite"

//退出登录
//#define kLogOut @"/sso/userLogout"


#define kCHeckVersion @"api/public/version"


/**********************************主页******************************************/

#define kGetUserAllUnreadMessages @"api/user/unreadMessage" //获取用户全部未读消息数
#define kMessageList @"api/user/message"    //获取消息列表
#define kReadMessage @"api/user/readMessage"  //用户读取消息

#define kServiceQrcode @"api/public/serviceQrcode"  //专属客服微信和二维码

#define kHomePageMenu @"api/index/menu"    //首页商品分类菜单
#define kHomePageMain @"api/index/index"   //首页主要数据
#define kHomePageList @"api/index/goods"   //首页分页数据
#define kWelfareBuy @"api/goods/welfareBuy" //独家福利购
#define kBulkcoupon @"api/coupon/bulkcoupon"   //万券齐发
#define kBrandCategory  @"api/brand/category" //品牌好店分类
#define kBrandGoods  @"api/brand/goods"   //品牌好店 商品
#define kBrandDetail @"api/brand/detail"  //商店详情
#define kBrandDetailGoods @"api/brand/detailGoods" //商店商品列表
#define kWillCollectGood @"api/goods/collect"  //用户收藏一件商品
#define kWillUnCollectGood @"api/user/collect" //用户取消收藏一件商品



#define kBestGoods @"api/goods/best"     //好货严选商品列表

#define kHotsaleGoods @"api/goods/hotsales" //热销榜商品 该接口和 kGetActivityGoods(paihang)接口数据一样

#define kGuessLike @"api/goods/guesslike"  //猜你喜欢的商品

#define  kCategoryDetail @"api/goods/category"  //根据分类id 获取分类数据
#define  kGetGoodsTypeMain @"api/goods/type"    //商品分类 和上面这个借口数据一样 暂时没用到这个借口
#define  kGetGoodsCategorys @"api/public/category"  //活动商品中的分类数据

#define  kSearchGoods @"api/goods/list"   //商品搜索
#define kGetGoodDetail  @"api/goods/detail"    //商品详情 url后面加id参数
#define kGetRushTimelist @"api/public/timelist"  //限时抢购时间
#define kGetRushGoodsList  @"api/goods/flashsale"  //限时抢购商品
#define kGetActivityGoods @"api/goods/activityGoods" //获取活动商品


/**********************************个人中心******************************************/

#define kGetUserInfo @"api/user/profile"   //获取用户数据
#define kChangeUserIcon @"api/user/upload"  //切换用户头像
#define kChangeuserName kGetUserInfo  //修改用户名字
#define kChangeMobile @"api/user/updateMobile" //更改电话号码

#define kTbAuth @"api/user/tbAuth"       //淘宝授权
#define kTbUnAuth  @"api/user/cancelTbAuth" //解除淘宝授权

#define kBindZfb @"api/user/bindZfb"     //绑定支付宝 name alipay_no
#define kUnBindZfb @"api/user/unbindZfb"     //解除绑定支付宝

#define  kVerifyMobile @"api/user/verifyMobile" //修改手机号前 验证手机号
#define kParentUsrCodeInfo @"api/user/parent"    //我的上级用户邀请码信息

#define kCashOut @"api/user/cashout"  //用户提现
#define kCashoutLog @"api/user/cashoutLog" //提现历史记录

#define  kInviteUser @"api/public/inviteUser" //邀请好友
#define  kProfileEarnings @"api/user/profileEarnings" //我的淘宝收益
#define kEarningList @"api/user/earnings"  //收益明细

#define kGetFansCount @"api/user/fansCount"//粉丝数 废弃api
#define  kGetFans @"api/user/fans" //粉丝分类查询
#define kNewTeach @"api/public/newTeach"  //新手教程
#define  kFindOrder @"api/order/find"  //查找一个订单
#define kGoodsLog @"api/user/goodsLog"        //浏览过的商品足迹
#define kClearTrack @"api/user/clearTrack"    //清空足迹
#define kSimilarGoods @"api/goods/similar"      //相似商品

#define kCollectgoods @"api/user/collectgoods/"   //获取用户收藏的商品数据
//用户取消请求一件商品用的是 kWillUnCollectGood

#define kGoodSelect @"api/goods/select"   //精选（收藏里面调用）
#define kMyOrders @"api/user/order"   //获取用户全部订单
#define kFAQ @"api/question/list"    //常见问题

#define kGetShareData @"api/goods/qrcodePic" //获取分享数据(准备分享)
#define kShareGood @"api/goods/share"  //分享商品

#define kSearchAssociate @"api/goods/associate"  //搜索时输入联想
#define kTeamTop @"api/user/teamTop"  //用户团队收益排行


/**********************************京东******************************************/
#define kJDCategory @"api/goods/jdCategory" //京东分类数据
#define  kJDHomePage  kGetActivityGoods    //京东首页数据(精选) 用的是商品中的活动商品这个接口
#define kJDActivity @"api/goods/jdActivity"  //京东活动 (好卷商品，为你推荐，特价9.9，品牌好货)
#define kJDGoodsSearch  @"api/goods/jdGoodsSearch"  //京东商品搜索，用在京东分类数据中了
#define kJDGoodDetail @"api/goods/jdGoodsDetail"   //京东商品详情
#endif /* LLNetWorkingMarco_h */


/**
 http头加上 "XX-Device-Type"  字段和 "XX-Token"字段  其中XX-Token 为下面参数
 mobile
 android
 iphone
 ipad
 web
 pc
 mac
 wxapp
 */


/** kSearchGoods 商品搜索 sort值:
 1：综合排序
 2：佣金比例由大到小
 3：预估收益由高到低
 4：价格由大到小
 5：价格由小到大
 6：月销量由大到小
 7：月销量由小到大
 */

 
 /** kCategoryDetail 商品分类数据sort:
  1：综合
  2：收益由高到低
  3:佣金比例由大到小
  4:价格由高到低
  5:价格由低到高
  6:销量由高到低
  7:销量由低到高
  8:最新
  */




/** kGetActivityGoods  activity_type 字段
爆 款：baokun
9.9包 邮：nine
超级大牌：pinpai
销 量 榜：paihang
聚 划 算：juhuasuan
天猫超市：tmall
天猫国际：tmallguoji
人气宝贝：bestsales
高佣精选：gaoyong
拼 多 多：pinduoduo //暂未使用
*/

/**
 *阿里百川 对应后台应用 灿男600生活ios
 *对应包名 com.cannan.goodlife
 *AppKey:28159852
 *AppSecret:054f4299aa52e62ac76ca4a6a15b2e83
 */



/**
 // 订单状态 3：订单结算，12：订单付款， 13：订单失效，14：订单成功',
 */
