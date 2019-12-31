//
//  TeachAVPlayerViewController.h
//  600生活
//
//  Created by iOS on 2019/11/15.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TeachAVPlayerViewController : AVPlayerViewController

//文件路径
-(id)initWithFilePath:(NSString*)filePath;

//点击了进入app后回调
@property (nonatomic, strong) void(^didClickedEnterMainCallBack)(void);

@end

NS_ASSUME_NONNULL_END
