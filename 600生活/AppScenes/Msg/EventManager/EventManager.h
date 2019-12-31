//
//  EventManager.h
//  600生活
//
//  Created by iOS on 2019/12/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventManager : NSObject

+(EventManager*_Nonnull)sharedManager;

//添加标题 时间到事件
-(void)writeWithTitle:(NSString*)title
                 time:(NSDate*)date
              success:(void (^_Nullable)(void))success
              failure:(void (^_Nullable)(NSError * _Nullable error))failure;
@end

NS_ASSUME_NONNULL_END
