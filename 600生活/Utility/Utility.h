//
//  Utility.h
//  TomLu
//
//  Created by HaiFang Luo on 2018/1/13.
//  Copyright © 2018年 com.haifangluo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "LLTipView.h" //全局提示view


@interface Utility : NSObject

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentUserVC;

//拨打电话
+(void)callTel:(NSString *)telNumber;

///发送短信
+(void)messageTel:(NSString*)telNumber;

//弹出框
+(void)ShowAlert:(NSString *)title message:(NSString *)msg buttonName:(NSArray*)Name sureAction:(void(^)(void))tapaAction cancleAction:(void(^)(void))cacleAction;

///判断相机权限是否开启 ios11
+(void)judgeAVAuthorizationStatus :(void(^)(BOOL isAuthed))finished;

//判断相册权限是否开启  ios11
+(void)judgePhoteAuthorizationStatus :(void(^)(BOOL isAuthed))finished;

//判断相册权限是否开启
+(BOOL)judgePhoteAuthorizationStatus;

//判断是否是中文
+(BOOL)IsChinese:(NSString *)str;

//字典转字符串(含空元素处理)
+ (NSString*)stringWithJsonDictionary:(NSDictionary *)jsonDic;

+ (NSString *)stringWithJsonArray:(NSArray *)jsonArray;

//字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//数组转字符串(含空元素处理)
+ (NSString *)StringWithArray:(NSArray *)array;

//字符串转数组
+ (NSArray*)arrayWithJsonString:(NSString*)jsonString;

///创建model类
+(void)printModelWithDictionary:(NSDictionary *)dict modelName:(NSString *)modelName;

/**
 *返回 ￥6 这样的特殊金额展示富文本字符串
 *形参1 金额
 *形参2 颜色
 */
+(NSMutableAttributedString*)moneyAttrStrWithMoney:(int)moneyValue color:(UIColor*)moneyColor;



//地图下单流程中错误状态提示
+(void)tipMapOrderErrWithCode:(int)errCode;


/**绘制渐变色颜色
 * coordinateArr:渐变方向 左上点为(0,0), 右下点为(1,1) 坐标数组@[x0,y0,x1,y1]   exm @[0,0,1,1]
 */
//绘制渐变色颜色
+ (void)addGradualChangingColorWithView:(UIView *)view fromColor:(UIColor*)fromColor toColor:(UIColor*)toColor orientation:(NSArray*)coordinateArr;

/** view 边框阴影添加阴影
 * view:目标view
 * shadowColor: 阴影颜色
 * shadowOffset: 阴影偏移量(宽度)  exm: CGSizeMake(0.0f, 5.0f)
 * shadowOpacity: 阴影透明度 exm: 0.5
 * cornerRadius: 阴影圆角 exm: 5
 */
+(void)addShade:(UIView*)view shadowColor:(UIColor*)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity cornerRadius:(CGFloat)cornerRadius;


/** view 抖动
 * orientation:抖动方向  0:左右  1上下
 */
+ (void)addShakeAnimationForView:(UIView*)view orientation:(int)orientation;

//view 创建圆形d
+(void)addBezierPathForView:(UIView*)view;

///根据距离字符串获取距离的描述 例如 :形参 distance = @"300" (单位米)
+(NSString *)getDistanceDesWithDistanceNumStrByMeter:(NSString *)meters;

+ (NSString*)getDateStrWithTimesStampNumber:(NSNumber*)stampNumber Format:(NSString*)format;

/*
 *形参:出生日期date  @"2012-2-5"  形参必须转成@"yyyy-MM-dd"格式
 *返回 @"xxx岁xxx月xxx天"
 */
+(NSString*)detailAgeStrWithBirthDate:(NSDate*)birthDate;

///根据月，日 获取星座 形参:int   返回:星座字符串
+ (NSString *)getConstellationWithMonth:(int)month day:(int)day;

///通过时间字符串获取时间描述 精确到分钟 形参@"2018-9-8 13:33:04"
///返回 @"4分钟"
+ (NSString*)getTimeMinutlyDescriptionWithTimeStr:(NSString*)timeStr;

///使用星座名 获取颜色
+(UIColor*)getColorWithConstellation:(NSString*)constellation;

///验证电话号码是否输入正确
+ (NSString *)valiMobile:(NSString *)mobileStr;

/// 设置状态栏背景颜色 (默认颜色是nil)
+ (void)setStatusBarBackgroundColor:(UIColor*)color;

//判断对象是否为空
+ (BOOL)isObjectNull:(id)unsafeObj;

/**展示全局提示图 配合dismissTipViewOn 方法一起使用
 type: 只有两种，一种图文 图示  一种是无网络重新加载提示
 iconName:提示图
 msg：提示信息
 */
+(void)showTipViewOn:(UIView*)superView type:(LLTipViewType)type iconName:(NSString*)iconName msg:(NSString*)msg;

//关闭全局提示图 配合上面方法一起使用
+(void)dismissTipViewOn:(UIView*)superView;



+ (void) shakeToShow:(UIView*)view;
@end
