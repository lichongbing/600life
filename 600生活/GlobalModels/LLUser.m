//
//  LLUser.m
//  600生活
//
//  Created by iOS on 2019/11/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLUser.h"

@implementation LLUser

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    if ([propertyName isEqualToString:@"id"]){
        return NO;
    }
    return YES;
}

@end
