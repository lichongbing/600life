//
//  MsgViewController.h
//  600生活
//
//  Created by iOS on 2019/11/18.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MsgViewController : LLViewController

/**unreadData
{
    "earnings_message_count" = 2;
    "earnings_message_title" = "\U60a8\U7684\U63d0\U73b0\U5df2\U5230\U5e10!";
    "system_message_count" = 4;
    "system_message_title" = "\U7cfb\U7edf\U901a\U77e504";
}
*/

-(id)initWithUnreadData:(NSDictionary*)unreadData;

@end

NS_ASSUME_NONNULL_END
