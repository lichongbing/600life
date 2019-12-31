//
//
//  Created by AA on 13-8-2.
//  Copyright (c) 2013年 dengyilei. All rights reserved.
//

#import "MD5Utils.h"
#import "CommonCrypto/CommonDigest.h"

@implementation MD5Utils

+(NSString *) md5: (NSData *) inPutText


{
    const char *cStr = (const char*)[inPutText bytes];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (unsigned int)inPutText.length, result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+ (NSString *)md5WithString:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}


+(NSString*) md5WithPath:(NSString*)path
{
    NSData* data = [NSData dataWithContentsOfFile:path];
    return [self md5:data];
}
@end
