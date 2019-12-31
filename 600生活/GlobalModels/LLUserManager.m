//
//  LLUserManager.m
//  600生活
//
//  Created by iOS on 2019/11/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLUserManager.h"

#import <FMDB/FMDB.h>
#import "NSString+ext.h"

@implementation LLUserManager
{
    FMDatabase *_db;
}

+ (instancetype)shareManager
{
    static dispatch_once_t once;
    static LLUserManager *man;
    dispatch_once(&once, ^ {
        man = [[LLUserManager alloc] init];
        if([man open]){
            [man createTables];
        }
    });
    
    return man;
}

- (BOOL)open
{
    NSString *dbDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [dbDir stringByAppendingPathComponent:@"LLUser.db"];
    _db = [FMDatabase databaseWithPath:dbPath] ;
    return [_db open];
}


/**
 integer 整型
 real 浮点数
 text 文本字符串
 blob 二进制数据
 */

- (void)createTables
{
    NSString *const USER_TABLE_CREATE_SQL = @" CREATE TABLE IF NOT EXISTS user(\
    id integer primary key,\
    invite_code text,\
    last_month_forecast text,\
    last_login_time integer,\
    user_login text,\
    create_time integer,\
    sex integer,\
    taobao_user_id integer,\
    balance text,\
    user_nickname text,\
    level integer,\
    last_month_settlement text,\
    mobile text,\
    user_status integer,\
    is_alipay text,\
    today_earnings text,\
    avatar text,\
    relation_id text,\
    last_login_ip text,\
    month_forecast text,\
    is_bind_zfb integer,\
    zfb_name text,\
    zfb_no text,\
    expire_time integer,\
    is_invite integer,\
    token text,\
    isLogin integer\
    );" ;
    
    if (![_db executeUpdate:USER_TABLE_CREATE_SQL]) {
        NSLog(@"fmdb创建或访问失败!");
    }else{
        NSLog(@"fmdb创建或访问成功，db文件路径:%@/User.db",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    }
}

- (void)close
{
    [_db close];
}

- (LLUser *)getLastLoginUser
{
    NSArray<LLUser*>* users = [self getAllRecordUsers];
    for(LLUser* tempUser in users){
        if(tempUser.id && tempUser.isLogin){
            [LLUserManager shareManager].currentUser = tempUser;
            return tempUser;
        }else{
            continue;
        }
    }
    return nil;
    
//    FMResultSet *rs = [_db executeQuery:@"Select * From user limit ((select count(id) from user)-1),1;"];
//    LLUser *user = [LLUser new];
//    if([rs next]){
//
//        user.id = [NSNumber numberWithInteger:[rs longForColumn:@"id"]];
//        user.invite_code = [NSString safetyStringByObject:[rs stringForColumn:@"invite_code"]];
//        user.last_month_forecast = [NSString safetyStringByObject:[rs stringForColumn:@"last_month_forecast"]];
//        user.user_login = [NSString safetyStringByObject:[rs stringForColumn:@"user_login"]];
//        user.create_time = [NSNumber numberWithInteger:[rs longForColumn:@"create_time"]];
//        user.sex = [NSNumber numberWithInteger:[rs intForColumn:@"sex"]];
//        user.taobao_user_id = [NSNumber numberWithInteger:[rs longForColumn:@"taobao_user_id"]];
//        user.balance = [NSString safetyStringByObject:[rs stringForColumn:@"balance"]];
//        user.user_nickname = [NSString safetyStringByObject:[rs stringForColumn:@"user_nickname"]];
//        user.level = [NSNumber numberWithInteger:[rs intForColumn:@"level"]];
//        user.last_month_settlement = [NSString safetyStringByObject:[rs stringForColumn:@"last_month_settlement"]];
//        user.mobile = [NSString safetyStringByObject:[rs stringForColumn:@"mobile"]];
//        user.user_status = [NSNumber numberWithInteger:[rs intForColumn:@"user_status"]];
//        user.is_alipay = [NSString safetyStringByObject:[rs stringForColumn:@"is_alipay"]];
//        user.today_earnings = [NSString safetyStringByObject:[rs stringForColumn:@"today_earnings"]];
//        user.avatar = [NSString safetyStringByObject:[rs stringForColumn:@"avatar"]];
//        user.relation_id = [NSString safetyStringByObject:[rs stringForColumn:@"relation_id"]];
//        user.last_login_ip = [NSString safetyStringByObject:[rs stringForColumn:@"last_login_ip"]];
//        user.month_forecast = [NSString safetyStringByObject:[rs stringForColumn:@"month_forecast"]];
//
//        user.expire_time = [NSNumber numberWithInteger:[rs longForColumn:@"expire_time"]];
//        user.is_invite = [NSNumber numberWithInteger:[rs intForColumn:@"is_invite"]];
//        user.token = [NSString safetyStringByObject:[rs stringForColumn:@"token"]];
//
//        user.isLogin = [rs intForColumn:@"isLogin"];
//
//        if (user.id != nil && user.isLogin == 1) {
//            NSLog(@"获取最后一次登录用户数据");
//            return user;
//        }
//    }
//    NSLog(@"未能获取最后一次已登录用户数据");
//    return nil ;
}

//获取全部历史用户
-(NSArray<LLUser*>*)getAllRecordUsers
{
    NSMutableArray<LLUser*> *mutArr = [[NSMutableArray alloc] init];
    FMResultSet *rs = [_db executeQueryWithFormat:@"SELECT * FROM user ;"];
    while([rs next]){
        LLUser* user = [LLUser new];
       
        user.id = [NSNumber numberWithInteger:[rs longForColumn:@"id"]];
        user.invite_code = [NSString safetyStringByObject:[rs stringForColumn:@"invite_code"]];
        user.last_month_forecast = [NSString safetyStringByObject:[rs stringForColumn:@"last_month_forecast"]];
        user.user_login = [NSString safetyStringByObject:[rs stringForColumn:@"user_login"]];
        user.create_time = [NSNumber numberWithInteger:[rs longForColumn:@"create_time"]];
        user.sex = [NSNumber numberWithInteger:[rs intForColumn:@"sex"]];
        user.taobao_user_id = [NSNumber numberWithInteger:[rs longForColumn:@"taobao_user_id"]];
        user.balance = [NSString safetyStringByObject:[rs stringForColumn:@"balance"]];
        user.user_nickname = [NSString safetyStringByObject:[rs stringForColumn:@"user_nickname"]];
        user.level = [NSNumber numberWithInteger:[rs intForColumn:@"level"]];
        user.last_month_settlement = [NSString safetyStringByObject:[rs stringForColumn:@"last_month_settlement"]];
        user.mobile = [NSString safetyStringByObject:[rs stringForColumn:@"mobile"]];
        user.user_status = [NSNumber numberWithInteger:[rs intForColumn:@"user_status"]];
        user.is_alipay = [NSString safetyStringByObject:[rs stringForColumn:@"is_alipay"]];
        user.today_earnings = [NSString safetyStringByObject:[rs stringForColumn:@"today_earnings"]];
        user.avatar = [NSString safetyStringByObject:[rs stringForColumn:@"avatar"]];
        user.relation_id = [NSString safetyStringByObject:[rs stringForColumn:@"relation_id"]];
        user.last_login_ip = [NSString safetyStringByObject:[rs stringForColumn:@"last_login_ip"]];
        user.month_forecast = [NSString safetyStringByObject:[rs stringForColumn:@"month_forecast"]];
         
        user.is_bind_zfb = [NSNumber numberWithInteger:[rs intForColumn:@"is_bind_zfb"]];
        user.zfb_name = [NSString safetyStringByObject:[rs stringForColumn:@"zfb_name"]];
        user.zfb_no = [NSString safetyStringByObject:[rs stringForColumn:@"zfb_no"]];
        
        user.expire_time = [NSNumber numberWithInteger:[rs longForColumn:@"expire_time"]];
        user.is_invite = [NSNumber numberWithInteger:[rs intForColumn:@"is_invite"]];
        user.token = [NSString safetyStringByObject:[rs stringForColumn:@"token"]];
        
        user.isLogin = [rs intForColumn:@"isLogin"];
        
        [mutArr addObject:user];
    }
    return mutArr;
}

//根据id 切换app用户
-(BOOL)switchUserWithId:(NSString*)uerId
{
    if (!uerId) {
        NSLog(@"切换用户失败，无用户id");
        return NO;
    }
    
    FMResultSet *rs = [_db executeQueryWithFormat:@"SELECT * FROM user WHERE id = '%@' ;",uerId];
    LLUser* user = [LLUser new];
    if([rs next]){
        
        user.id = [NSNumber numberWithInteger:[rs longForColumn:@"id"]];
        user.invite_code = [NSString safetyStringByObject:[rs stringForColumn:@"invite_code"]];
        user.last_month_forecast = [NSString safetyStringByObject:[rs stringForColumn:@"last_month_forecast"]];
        user.user_login = [NSString safetyStringByObject:[rs stringForColumn:@"user_login"]];
        user.create_time = [NSNumber numberWithInteger:[rs longForColumn:@"create_time"]];
        user.sex = [NSNumber numberWithInteger:[rs intForColumn:@"sex"]];
        user.taobao_user_id = [NSNumber numberWithInteger:[rs longForColumn:@"taobao_user_id"]];
        user.balance = [NSString safetyStringByObject:[rs stringForColumn:@"balance"]];
        user.user_nickname = [NSString safetyStringByObject:[rs stringForColumn:@"user_nickname"]];
        user.level = [NSNumber numberWithInteger:[rs intForColumn:@"level"]];
        user.last_month_settlement = [NSString safetyStringByObject:[rs stringForColumn:@"last_month_settlement"]];
        user.mobile = [NSString safetyStringByObject:[rs stringForColumn:@"mobile"]];
        user.user_status = [NSNumber numberWithInteger:[rs intForColumn:@"user_status"]];
        user.is_alipay = [NSString safetyStringByObject:[rs stringForColumn:@"is_alipay"]];
        user.today_earnings = [NSString safetyStringByObject:[rs stringForColumn:@"today_earnings"]];
        user.avatar = [NSString safetyStringByObject:[rs stringForColumn:@"avatar"]];
        user.relation_id = [NSString safetyStringByObject:[rs stringForColumn:@"relation_id"]];
        user.last_login_ip = [NSString safetyStringByObject:[rs stringForColumn:@"last_login_ip"]];
        user.month_forecast = [NSString safetyStringByObject:[rs stringForColumn:@"month_forecast"]];
               
        user.is_bind_zfb = [NSNumber numberWithInteger:[rs intForColumn:@"is_bind_zfb"]];
        user.zfb_name = [NSString safetyStringByObject:[rs stringForColumn:@"zfb_name"]];
        user.zfb_no = [NSString safetyStringByObject:[rs stringForColumn:@"zfb_no"]];
        
        user.expire_time = [NSNumber numberWithInteger:[rs longForColumn:@"expire_time"]];
        user.is_invite = [NSNumber numberWithInteger:[rs intForColumn:@"is_invite"]];
        user.token = [NSString safetyStringByObject:[rs stringForColumn:@"token"]];

        user.isLogin = [rs intForColumn:@"isLogin"];
        
        if(user.id != nil){
            [LLUserManager shareManager].currentUser = user;
            NSLog(@"切换用户成功,id=%@",user.id);
            return YES;
        }
    }
    return  NO;
}

//插入或更新用户
- (BOOL)insertOrUpdateCurrentUser:(LLUser*)user
{
    if(!user){
        NSLog(@"无用户数据,停止sql插入");
        return NO;
    }
    NSString* updateStatement = [NSString stringWithFormat:@"INSERT OR REPLACE INTO user(\
     id ,\
    invite_code ,\
    last_month_forecast ,\
    last_login_time ,\
    user_login ,\
    create_time ,\
    sex ,\
    taobao_user_id ,\
    balance ,\
    user_nickname ,\
    level ,\
    last_month_settlement ,\
    mobile ,\
    user_status ,\
    is_alipay ,\
    today_earnings ,\
    avatar ,\
    relation_id ,\
    last_login_ip ,\
    month_forecast ,\
    is_bind_zfb ,\
    zfb_name ,\
    zfb_no  ,\
    expire_time ,\
    is_invite ,\
    token ,\
    isLogin\
    ) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%d');",
                                 user.id,
                                 user.invite_code,
                                 user.last_month_forecast,
                                 user.last_login_time,
                                 user.user_login,
                                 user.create_time,
                                 user.sex,
                                 user.taobao_user_id,
                                 user.balance,
                                 user.user_nickname,
                                 user.level,
                                 user.last_month_settlement,
                                 user.mobile,
                                 user.user_status,
                                 user.is_alipay,
                                 user.today_earnings,
                                 user.avatar,
                                 user.relation_id,
                                 user.last_login_ip,
                                 user.month_forecast,
                                 user.is_bind_zfb,
                                 user.zfb_name,
                                 user.zfb_no,
                                 user.expire_time,
                                 user.is_invite,
                                 user.token,
                                 user.isLogin
                                 ];
    if([_db executeStatements:updateStatement]){
        _currentUser = user;
        NSLog(@"用户表更新/插入新成功");
        NSLog(@"当前用户id=%@",user.id);
        NSLog(@"当前用户token=%@",user.token);
        return YES;
    }else{
        NSLog(@"用户表更新/插入失败");
        return NO;
    }
}

//删除用户
-(void)deleteUserWithId:(NSString*)userId
{
    NSString* statement = [NSString stringWithFormat:@"DELETE FROM user WHERE id = '%@';",userId];
    if([_db executeStatements:statement]){
        NSLog(@"删除用户成功");
    }else{
        NSLog(@"删除用户失败");
    }
}
@end
