//
//  LLUser.h
//  600生活
//
//  Created by iOS on 2019/11/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLUser : JSONModel

/**
 *服务端登录注册接口返回user数据
 */

@property (nonatomic,copy) NSNumber *id;
@property (nonatomic,copy) NSString *invite_code;     //邀请码

@property (nonatomic,copy) NSNumber *last_login_time;    //上次登录时间
@property (nonatomic,copy) NSString *user_login;         //用户登录账号
@property (nonatomic,copy) NSNumber *create_time;        //注册时间
@property (nonatomic,copy) NSNumber *sex;
@property (nonatomic,copy) NSNumber *taobao_user_id;     //淘宝id
@property (nonatomic,copy) NSString *balance;             // 余额
@property (nonatomic,copy) NSString *user_nickname;
@property (nonatomic,copy) NSNumber *level;              //登记

@property (nonatomic,copy) NSString *last_month_settlement;  //上月结算收益
@property (nonatomic,copy) NSString *last_month_forecast; //上月预估收益

@property (nonatomic,copy) NSString *mobile;          //用户电话号码
@property (nonatomic,copy) NSNumber *user_status;     //用户状态0:禁用,1:正常
@property (nonatomic,copy) NSString *is_alipay;
@property (nonatomic,copy) NSString *today_earnings;   // 今日预估收益
@property (nonatomic,copy) NSString *avatar;            //头像
@property (nonatomic,copy) NSString *relation_id;        //淘宝关系id 淘宝授权后才有值
@property (nonatomic,copy) NSString *last_login_ip;      //上次登录ip
@property (nonatomic,copy) NSString *month_forecast;    //本月预估收益


/**
 服务端用户信息接口返回的数据(包括上面的所有字段和下面三个字段)
 */
@property (nonatomic,copy) NSNumber *is_bind_zfb; //是否绑定支付宝 1-绑定 0-未绑定
@property (nonatomic,copy) NSString *zfb_name; //支付宝名
@property (nonatomic,copy) NSString *zfb_no;   //支付宝号


/**
 *客户端自定义user数据
 */
@property(nonatomic,copy) NSNumber* expire_time; //token过期时间

/**
 是否填写邀请码1-填写 0-未填写 -1用户暂时不愿意填写  -1是客户端自定义添加值 0时会跳转到填写邀请码界面 其他都不会 服务端时 这是个bool 客户端当成int处理
 */
@property(nonatomic,copy) NSNumber* is_invite;

@property(nonatomic,copy) NSString* token;

@property(nonatomic,assign) BOOL isLogin; //是否登录

@end

NS_ASSUME_NONNULL_END
