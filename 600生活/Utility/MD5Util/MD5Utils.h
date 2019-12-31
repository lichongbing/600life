//
//  TalkBar
//
//  Created by AA on 13-8-2.
//  Copyright (c) 2013年 dengyilei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MD5Utils : NSObject {
    
}
/*****
 2011.09.15
 创建： shen
 MD5 加密
 *****/

+(NSString*) md5WithPath:(NSString*)path;
+(NSString *) md5: (NSData *) inPutText ;

+ (NSString *)md5WithString:(NSString *)str;
@end
