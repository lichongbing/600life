//
//  ScanQRCodeViewController.h
//  kcc
//
//  Created by tomlu on 2019/5/16.
//  Copyright © 2019 com.luohaifang. All rights reserved.
//

#import "LLViewController.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanQRCodeViewController : LLViewController

@property(nonatomic,strong)NSString* infoLabText;

//扫码成功回调
@property (nonatomic,strong) void (^didSuccessScanCallBack)(NSString* content);

@end

NS_ASSUME_NONNULL_END
