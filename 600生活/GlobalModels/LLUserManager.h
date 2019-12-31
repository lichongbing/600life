//
//  LLUserManager.h
//  600生活
//
//  Created by iOS on 2019/11/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface LLUserManager : NSObject

@property(nonatomic,copy) LLUser* currentUser;

#pragma mark - sql操作 在场景中不要调用sql相关方法

- (BOOL)open;
- (void)close;
- (void)createTables;

+ (LLUserManager*)shareManager;

//获取最后一次登录的用户
- (LLUser *)getLastLoginUser;

//获取全部历史用户
-(NSArray<LLUser*>*)getAllRecordUsers;

//根据id 切换app用户 成功返回YES
-(BOOL)switchUserWithId:(NSString*)uerId;

//插入或更新用户
- (BOOL)insertOrUpdateCurrentUser:(LLUser*)user;

//删除用户
-(void)deleteUserWithId:(NSString*)userId;


@end

NS_ASSUME_NONNULL_END
