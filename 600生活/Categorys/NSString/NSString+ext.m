//
//  NSString+ext.m
//  600生活
//
//  Created by iOS on 2019/11/4.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "NSString+ext.h"
#import <CommonCrypto/CommonDigest.h>  //系统方法

@implementation NSString (ext)

+(NSString*)safetyStringByObject:(id)unsafeObj
{
    if([unsafeObj isKindOfClass:[NSNull class]]){
        return @"";
    }
    
    //oc语法
    if([unsafeObj isEqual:[NSNull null]])
    {
        return @"";
    }
    //异常NSString
    if([unsafeObj isKindOfClass:[NSString class]]){  //(null)
        NSString* tempStr = (NSString*)unsafeObj;
        if(!tempStr ||  tempStr.length == 0  || [tempStr isEqualToString:@"<null>"] || [tempStr isEqualToString:@"(null)"]|| [tempStr isEqualToString:@"(null)"] || [tempStr isEqualToString:@""] || [tempStr isEqual:[NSNull null]]){
            return @"";
        }
        return tempStr;
    }
    return @"";
}

#pragma mark - 时间戳转时间
//年月日
+ (NSString *)getTimeWithTimeIntervalStr:(NSString *)timeStampStr
                           timeStampType:(timeStampType)timeStampType
{
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[timeStampStr doubleValue]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    if(timeStampType == timeStampTypeYMDHMS){
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else if (timeStampType == timeStampTypeYMD){
         [dateFormat setDateFormat:@"yyyy-MM-dd"];
    }else if (timeStampType == timeStampTypeHMS){
         [dateFormat setDateFormat:@"HH:mm:ss"];
    }
    
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [dateFormat setTimeZone:timeZone];
    return [dateFormat stringFromDate:currentDate];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize;
}

+ (NSString*) md5StrWith:(NSString*)input
{
    const char *cStr = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr,(unsigned int)strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

@end
