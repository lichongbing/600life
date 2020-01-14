//
//  Utility.m
//  TomLu
//
//  Created by HaiFang Luo on 2018/1/13.
//  Copyright © 2018年 com.haifangluo. All rights reserved.
//

#import "Utility.h"

#import<AVFoundation/AVCaptureDevice.h> //相机权限
#import<AVFoundation/AVMediaFormat.h>   //相机权限

#import <Photos/Photos.h>              //相册权限
#import <AssetsLibrary/AssetsLibrary.h> //相册权限

#import <objc/runtime.h>


#define iOS10_Beyond ([[UIDevice currentDevice].systemVersion doubleValue]>=10.0)
#define iOS9_Beyond ([[UIDevice currentDevice].systemVersion doubleValue]>=9.0)

@implementation Utility

///获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentUserVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [Utility getCurrentVCFrom:rootViewController];
    return currentVC;
}

///
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

/// 拨打电话
+(void)callTel:(NSString *)telNumber{
    if (telNumber) {
        NSString* msg = [NSString stringWithFormat:@"拨打电话%@",telNumber];
        [self ShowAlert:msg message:nil buttonName:@[@"确定",@"取消"] sureAction:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",telNumber ]] options:@{} completionHandler:nil];
        } cancleAction:nil];
    }else{
        [self ShowAlert:@"无效的电话号码" message:nil buttonName:@[@"确定"] sureAction:nil cancleAction:nil];
    }
}

///发送短信
+(void)messageTel:(NSString*)telNumber
{
    if (telNumber) {
        NSString* msg = [NSString stringWithFormat:@"发送短信到%@",telNumber];
        [self ShowAlert:msg message:nil buttonName:@[@"确定",@"取消"] sureAction:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",telNumber ]] options:@{} completionHandler:nil];
        } cancleAction:nil];
    }else{
        [self ShowAlert:@"无效的电话号码" message:nil buttonName:@[@"确定"] sureAction:nil cancleAction:nil];
    }
}

/// alert
+(void)ShowAlert:(NSString *)title message:(NSString *)msg buttonName:(NSArray*)Name sureAction:(void(^)(void))tapaAction cancleAction:(void(^)(void))cacleAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (Name.count>1&&Name[1]) {
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:Name[1] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cacleAction) {
                cacleAction();
            }
        }];
        [alert addAction:cancle];
    }
    if (Name[0]) {
        UIAlertAction *sure = [UIAlertAction actionWithTitle:Name[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (tapaAction) {
                tapaAction();
            }
        }];
        [alert addAction:sure];
    }
    
    [[[[UIApplication sharedApplication]keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
}


//#import<AVFoundation/AVCaptureDevice.h> //相机权限
//#import<AVFoundation/AVMediaFormat.h>   //相机权限
///判断相机权限是否开启 ios11
+(void)judgeAVAuthorizationStatus :(void(^)(BOOL isAuthed))finished {
    
    //判断是否开启相机权限
    //ios11之后
    [AVCaptureDevice requestAccessForMediaType:(AVMediaTypeVideo) completionHandler:^(BOOL granted) {
        finished(granted);
        if( granted==NO ){
            //无相机权限
            NSString *titleStr = @"访问相机权限受限";
            NSString* msgStr = @"请在iPhone的“设置-隐私-相机”选项中，允许600生活访问你的相机";
            [Utility ShowAlert:titleStr message:msgStr buttonName:@[@"去设置",@"取消"] sureAction:^{
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            } cancleAction:nil];
        }else{
        }
    }];
}


//#import <Photos/Photos.h>              //相册权限
//#import <AssetsLibrary/AssetsLibrary.h> //相册权限
//判断相册权限是否开启  ios11
+(void)judgePhoteAuthorizationStatus :(void(^)(BOOL isAuthed))finished
{
 //ios 11之后
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {

        if(status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusNotDetermined){
            NSString *titleStr = @"访问照片权限受限";
            NSString* msgStr = @"请在iPhone的“设置-隐私-照片”选项中，允许600生活访问你的照片";
            [Utility ShowAlert:titleStr message:msgStr buttonName:@[@"去设置",@"取消"] sureAction:^{
                NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            } cancleAction:nil];
        } else {
            finished(YES);
        }
    }];
}


///判断是否是中文
+(BOOL)IsChinese:(NSString *)str
{
    NSInteger count = str.length;
    NSInteger result = 0;
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)//判断输入的是否是中文
        {
            result++;
        }
    }
    if (count == result) {//当字符长度和中文字符长度相等的时候
        return YES;
    }
    return NO;
}

///json字典转字符串(含空元素处理)
+ (NSString*)stringWithJsonDictionary:(NSDictionary *)jsonDic
{
    if(!jsonDic){
        return nil;
    }
    
    //清空字典中的空值
    NSMutableDictionary* mutDic = [NSMutableDictionary new];
    for(NSString* key in [jsonDic allKeys]){
        [mutDic setObject:[NSString safetyStringByObject:jsonDic[key]]  forKey:key];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"转换失败:%@",error.description);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (NSString *)stringWithJsonArray:(NSArray *)jsonArray
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

///字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json转字典失败：%@",err.description);
        NSLog(@"%@",jsonString);
        return nil;
    }
    return dic;
}

///数组转字符串(含空元素处理)
+ (NSString *)StringWithArray:(NSArray *)array
{
    NSString *jsonStr = @"[";
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        NSString* itemStr = [NSString safetyStringByObject:array[i]];
        jsonStr = [jsonStr stringByAppendingString:itemStr];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    
    return jsonStr;
}

///字符串转数组
+ (NSArray*)arrayWithJsonString:(NSString*)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}

/*
 * 打印model 形参1是外部数据   形参2是自定义的名字
 */
+(void)printModelWithDictionary:(NSDictionary *)dict modelName:(NSString *)modelName
{
    printf("\n@interface %s :NSObject\n",modelName.UTF8String);
    for (NSString *key in dict) {
        NSString *type = ([dict[key] isKindOfClass:[NSNumber class]])?@"NSNumber":@"NSString";
        printf("@property (nonatomic,copy) %s *%s;\n",type.UTF8String,key.UTF8String);
    }
    printf("@end\n");
}

/**
 *返回 ￥6 这样的特殊金额展示富文本字符串
 *形参1 金额
 *形参2 颜色
 */
+(NSMutableAttributedString*)moneyAttrStrWithMoney:(int)moneyValue color:(UIColor*)moneyColor
{
    NSString* constStr = @"玩币";
    NSString* fullStr = [NSString stringWithFormat:@"%@%d",constStr,moneyValue];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:fullStr];
    [attrString addAttribute:NSForegroundColorAttributeName value:moneyColor range:[fullStr rangeOfString:fullStr]];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:[fullStr rangeOfString:constStr]];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[fullStr rangeOfString:constStr]];
    return attrString;
}




//绘制渐变色颜色
+ (void)addGradualChangingColorWithView:(UIView *)view fromColor:(UIColor*)fromColor toColor:(UIColor*)toColor orientation:(NSArray*)coordinateArr{
    
    //  CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    if (coordinateArr.count < 4) {
        NSAssert(coordinateArr.count < 4, @"数组异常");
        return;
    }
    int x0 = [coordinateArr[0] intValue];
    int y0 = [coordinateArr[1] intValue];
    int x1 = [coordinateArr[2] intValue];
    int y1 = [coordinateArr[3] intValue];
    gradientLayer.startPoint = CGPointMake(x0, y0);
    gradientLayer.endPoint = CGPointMake(x1, y1);
    
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    [view.layer addSublayer:gradientLayer];
}

/** view 边框阴影添加阴影
 * view:目标view
 * shadowColor: 阴影颜色
 * shadowOffset: 阴影偏移量(宽度)  exm: CGSizeMake(0.0f, 5.0f)
 * shadowOpacity: 阴影透明度 exm: 0.5
 * cornerRadius: 阴影圆角 exm: 5
 */
+(void)addShade:(UIView*)view shadowColor:(UIColor*)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity cornerRadius:(CGFloat)cornerRadius
{
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = shadowColor.CGColor;
    view.layer.shadowOffset = shadowOffset;
    view.layer.shadowOpacity = shadowOpacity;
    view.layer.shadowPath = shadowPath.CGPath;
}


//view 抖动
+ (void)addShakeAnimationForView:(UIView*)view orientation:(int)orientation
{
    // 获取到当前的View
    CALayer *viewLayer = view.layer;
    // 获取当前View的位置
    CGPoint position = viewLayer.position;
    
    // 移动的两个终点位置
    CGPoint x = CGPointZero;
    CGPoint y = CGPointZero;
    
    if (orientation == 0) {
        x = CGPointMake(position.x + 10, position.y);
        y = CGPointMake(position.x - 10, position.y);
    } else {
        x = CGPointMake(position.x, position.y + 10);
        y = CGPointMake(position.x, position.y - 10);
    }
    
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    // 设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    // 设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    // 设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    // 设置自动反转
    [animation setAutoreverses:YES];
    // 设置时间
    [animation setDuration:.08];
    // 设置次数
    [animation setRepeatCount:0];
    // 添加动画
    [viewLayer addAnimation:animation forKey:nil];
}

//view 创建圆形d
+(void)addBezierPathForView:(UIView*)view
{
    UIBezierPath *path = [UIBezierPath     bezierPathWithArcCenter:CGPointMake(view.width * 0.5, view.height * 0.5) radius:view.width * 0.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    CAShapeLayer *circleLLayer = [CAShapeLayer layer];
    circleLLayer.frame = view.bounds;
    circleLLayer.path = path.CGPath;
    [view.layer addSublayer:circleLLayer];
}


///根据距离字符串获取距离的描述 例如 :形参 distance = @"300" (单位米)
+(NSString *)getDistanceDesWithDistanceNumStrByMeter:(NSString *)meters
{
    NSString* kilometres = [NSString stringWithFormat:@"%f",[meters floatValue]*0.001]; //转化为公里
    
    NSString *distanceStrTwo = @" km";
    CGFloat divisor = 1;
    NSString *distanceStrOne = [NSString stringWithFormat:@"%.2f",[kilometres floatValue]/divisor];
    
    if([kilometres floatValue] < 1000/1000.0 ) {
        distanceStrTwo = @"km以内";
        distanceStrOne = @"1";
    }
    
    /*
    if ([kilometres floatValue] > 500/1000.0 && [kilometres floatValue] < 1000/1000.0) {
        distanceStrTwo = @" 米";
        divisor = 0.001;
        distanceStrOne = [NSString stringWithFormat:@"%.0f",[kilometres floatValue]/divisor];
    }
    
    else if ([kilometres floatValue] <= 500/1000.0)
    {
        distanceStrTwo = @"米以内";
        if([kilometres floatValue] <= 50/1000.0){
            distanceStrOne = @"50";
        }else if ( [kilometres floatValue] <= 100/1000.0 && [kilometres floatValue] > 50/1000.0){
            distanceStrOne = @"100";
        }else if ( [kilometres floatValue] <= 200/1000.0 && [kilometres floatValue] > 100/1000.0){
            distanceStrOne = @"200";
        }else if ( [kilometres floatValue] <= 500/1000.0 && [kilometres floatValue] > 200/1000.0){
            distanceStrOne = @"500";
        }
    }
     */
    
    else if([kilometres floatValue] >= 100)
    {
        distanceStrTwo = @"km以外";
        distanceStrOne = @"100";
    }
    
    NSString *distanceAllStr = [NSString stringWithFormat:@"%@%@", distanceStrOne, distanceStrTwo];
    return distanceAllStr;
}


/**
 *形参 "1234223349889"   “YY:MM:dd HH:mm:ss”
 *返回 2019:08:4  23:12:56
 */
+ (NSString*)getDateStrWithTimesStampNumber:(NSNumber*)stampNumber Format:(NSString*)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stampNumber.integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    NSString* dateStr = [formatter stringFromDate:date];
    return dateStr;
}

/*
 *形参:出生日期date  @"2012-2-5"
 *返回 @"xxx岁xxx月xxx天"
 */
+(NSString*)detailAgeStrWithBirthDate:(NSDate*)birthDate
{
    //获得当前系统时间
    NSDate *currentDate = [NSDate date];
    //创建日历(格里高利历)
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //设置component的组成部分
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ;
    //按照组成部分格式计算出生日期与现在时间的时间间隔
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDate toDate:currentDate options:0];
    
    //判断年龄大小,以确定返回格式
    if( [date year] > 0){
        return [NSString stringWithFormat:(@"%ld岁%ld月%ld天"),(long)[date year],(long)[date month],(long)[date day]];
    }else if([date month] >0){
        return [NSString stringWithFormat:(@"%ld月%ld天"),(long)[date month],(long)[date day]];
    }else if([date day]>0){
        return [NSString stringWithFormat:(@"%ld天"),(long)[date day]];
    }else{
        return @"0天";
    }
}

///根据月，日 获取星座
+ (NSString *)getConstellationWithMonth:(int)month day:(int)day
{
    NSString * astroString = @"摩羯座水瓶座双鱼座白羊座金牛座双子座巨蟹座狮子座处女座天秤座天蝎座射手座摩羯座";
    NSString * astroFormat = @"102123444543";
    NSString * result = nil;
    result = [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*3-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*3, 3)]];
    return result;
}


///通过时间字符串获取时间描述 精确到分钟 形参@"2018-9-8 13:33:04"
///返回 @"4分钟"
+ (NSString*)getTimeMinutlyDescriptionWithTimeStr:(NSString*)timeStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //目标Date 字符串
    NSString* theDateStr = timeStr;
    //当前Date 字符串
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];
    //目标日期和此刻的时间差(秒)
    NSInteger duringSeconds = [[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDateStr]];
    
    //分钟
    NSInteger duringMinutes = duringSeconds % 60;
    //小时
    NSInteger duringHours = duringMinutes % 60;
    //天
    NSInteger duringDays = duringHours % 24;
    //月
    NSInteger duringMonths = duringDays % 30;
    //年
    NSInteger duringYears = duringMonths % 12;
    if(duringMinutes == 0) {
        return @"刚刚"; //一分钟内
    } else if (0 < duringMinutes && duringMinutes < 60) {
         return [NSString stringWithFormat:@"%lu分钟前",duringMinutes];
    } else if (0 < duringHours && duringHours < 24 ) {
        return [NSString stringWithFormat:@"%lu小时前",duringHours];
    } else if (0 < duringDays && duringDays < 30 ) {
        return [NSString stringWithFormat:@"%lu天前",duringDays];
    } else if (0 < duringMonths && duringMonths < 12 ) {
        return [NSString stringWithFormat:@"%lu个月前",duringMonths];
    } else {
        return [NSString stringWithFormat:@"%lu年前",duringYears];
    }
}

///使用星座名 获取颜色
+(UIColor*)getColorWithConstellation:(NSString*)constellation
{
    if ([constellation isEqualToString:@"白羊座"]){
        return RGB(255, 73, 73);
    }else if ([constellation isEqualToString:@"金牛座"]){
        return RGB(74, 162, 233);
    }else if ([constellation isEqualToString:@"双子座"]){
        return RGB(255, 149, 3);
    }else if ([constellation isEqualToString:@"巨蟹座"]){
        return RGB(76, 201, 72);
    }else if ([constellation isEqualToString:@"狮子座"]){
        return RGB(231, 186, 7);
    }else if ([constellation isEqualToString:@"处女座"]){
        return RGB(87, 152, 68);
    }else if ([constellation isEqualToString:@"天蝎座"]){
        return RGB(87, 36, 175);
    }else if ([constellation isEqualToString:@"射手座"]){
        return RGB(88, 233, 235);
    }else if ([constellation isEqualToString:@"摩羯座"]){
        return RGB(13, 110, 191);
    }else if ([constellation isEqualToString:@"水瓶座"]){
        return RGB(67, 191, 255);
    }else if ([constellation isEqualToString:@"双鱼座"]){
        return RGB(255, 204, 0);
    }else if ([constellation isEqualToString:@"天秤座"]){
        return RGB(208, 0, 80);
    };
    return [UIColor blackColor];
}

///验证电话号码是否输入正确
+ (NSString *)valiMobile:(NSString *)mobileStr {
    if (mobileStr.length != 11) {
        return @"手机号长度只能是11位";
    } else {
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(17[0-9])|(18[2-4,7-8]))\\d{8}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[0-9])|(18[5,6]))\\d{8}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(17[0-9])|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobileStr];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobileStr];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobileStr];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return nil;
        } else {
            return @"请输入正确的电话号码";
        }
    }
    return nil;
}

/// 设置状态栏背景颜色 (默认颜色是nil)
+ (void)setStatusBarBackgroundColor:(UIColor*)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


//判断对象是否为空
+ (BOOL)isObjectNull:(id)unsafeObj
{
    if (unsafeObj == nil) {
        return YES;
    }
    
    if([unsafeObj isKindOfClass:[NSNull class]]){
        return YES;
    }
    
    //oc语法
    if([unsafeObj isEqual:[NSNull null]])
    {
        return YES;
    }
    
    //异常NSString
    if([unsafeObj isKindOfClass:[NSString class]]){  //(null)
        NSString* tempStr = (NSString*)unsafeObj;
        if(!tempStr ||  tempStr.length == 0  || [tempStr isEqualToString:@"<null>"] || [tempStr isEqualToString:@"(null)"]|| [tempStr isEqualToString:@"(null)"]  || [tempStr isEqual:[NSNull null]]){ //[tempStr isEqualToString:@""] 没有判断
            return YES;
        }
    }
    return NO;
}

#pragma mark - --------------全局提示view-----------
+(void)showTipViewOn:(UIView*)superView type:(LLTipViewType)type iconName:(NSString*)iconName msg:(NSString*)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        LLTipView* oldTipView = (LLTipView*)[superView viewWithTag:kTipViewTag];
        if (!oldTipView) {  //没有
            LLTipView* newTipView = [[LLTipView alloc] initWithType:type iconName:iconName msg:msg superView:superView];
            [superView addSubview:newTipView];
        
        } else {  //有
            if (oldTipView.type != type) { //类型不一致
                oldTipView.type = type;
            } else {
                //do nothing
            }
        }
    });
}

+(void)dismissTipViewOn:(UIView*)superView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        LLTipView* oldTipView = [superView viewWithTag:kTipViewTag];
        if (oldTipView) {
            [oldTipView removeFromSuperview];
        }
    });
}


+ (void) shakeToShow:(UIView*)view
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1.0;// 动画时间
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    
    // 这三个数字，我只研究了前两个，所以最后一个数字我还是按照它原来写1.0；前两个是控制view的大小的；
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    animation.values = values;
    animation.repeatCount = 0;
    [view.layer addAnimation:animation forKey:nil];
}

/**
 *字符串是否全是数字0-9组成
 */
+(BOOL)isNumWithString:(NSString*)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:str];
}

@end
