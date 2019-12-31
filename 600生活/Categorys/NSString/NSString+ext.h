//
//  NSString+ext.h
//  600生活
//
//  Created by iOS on 2019/11/4.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ext)

/*
 *不安全的字符串转换为安全字符串
 */
+(NSString*)safetyStringByObject:(id)unsafeObj;


#pragma mark - 时间戳转时间
/*
 *时间戳 转时间
 */
typedef enum  {
    timeStampTypeYMDHMS  = 0,   //年月日时分秒
    timeStampTypeYMD,           //年月日
    timeStampTypeHMS,            //时分秒
    timeStampTypeHM    //时
} timeStampType;

+ (NSString *)getTimeWithTimeIntervalStr:(NSString *)timeStampStr
                           timeStampType:(timeStampType)timeStampType;

/*
 *获取字符串的宽高
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/*
 *md5
 */
+ (NSString*) md5StrWith:(NSString*)input;

@end

NS_ASSUME_NONNULL_END
