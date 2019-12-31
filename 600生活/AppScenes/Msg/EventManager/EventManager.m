//
//  EventManager.m
//  600生活
//
//  Created by iOS on 2019/12/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "EventManager.h"
#import <EventKit/EventKit.h>

@implementation EventManager

+(EventManager*_Nonnull)sharedManager
{
    static EventManager* man = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        man = [[EventManager alloc]init];
    });
    return man;
}

-(void)writeWithTitle:(NSString*)title
                 time:(NSDate*)date
              success:(void (^_Nullable)(void))success
              failure:(void (^_Nullable)(NSError * _Nullable error))failure;
{
    EKEventStore *store = [[EKEventStore alloc] init];
    if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        [store requestAccessToEntityType:(EKEntityTypeEvent) completion:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"添加失败，，错误了。。。");
                } else if (!granted) {
                    NSLog(@"不允许使用日历，没有权限");
                } else {
                    
                    EKEvent *event = [EKEvent eventWithEventStore:store];
                    event.title = title;
//                    event.location = @"这是一个 location";
                    // 提前一分钟开始
                    NSDate *startDate = [NSDate dateWithTimeInterval:-60 sinceDate:date];
//                    // 提前一分钟结束
                    NSDate *endDate = [NSDate dateWithTimeInterval:60 sinceDate:date];
                    event.startDate = startDate;//必须设置
                    event.endDate = endDate; //必须设置
                    event.allDay = NO;
                    
                    // 添加闹钟结合（开始前多少秒）若为正则是开始后多少秒。
                    EKAlarm *elarm2 = [EKAlarm alarmWithRelativeOffset:-20];
                    [event addAlarm:elarm2];
                    EKAlarm *elarm = [EKAlarm alarmWithRelativeOffset:-10];
                    [event addAlarm:elarm];
                    
                    [event setCalendar:[store defaultCalendarForNewEvents]];
                    
                    NSError *error = nil;
                    [store saveEvent:event span:EKSpanThisEvent error:&error];
                    if (!error) {
                        NSLog(@"添加时间成功");
                        success();
//                        //添加成功后需要保存日历关键字
//                        NSString *iden = event.eventIdentifier;
//                        // 保存在沙盒，避免重复添加等其他判断
//                        [[NSUserDefaults standardUserDefaults] setObject:iden forKey:@"my_eventIdentifier"];
//                        [[NSUserDefaults standardUserDefaults] synchronize];
                    } else {
                        failure(error);
                    }
                }
            });
        }];
    }
}

@end
