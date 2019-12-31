//
//  LLHudHelper.h
//  600生活
//
//  Created by iOS on 2019/11/4.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef void (^CommonVoidBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface LLHudHelper : NSObject

+ (LLHudHelper *)sharedInstance;

//alert
+ (void)alert:(NSString *)msg;
+ (void)alert:(NSString *)msg action:(CommonVoidBlock)action;
+ (void)alert:(NSString *)msg cancel:(NSString *)cancel;
+ (void)alert:(NSString *)msg cancel:(NSString *)cancel action:(CommonVoidBlock)action;
+ (void)alertTitle:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel;

+ (void)alertTitle:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancelStr sure:(NSString*)sureStr cancelAction:(CommonVoidBlock)cancelAction sureAction:(CommonVoidBlock)sureAction;

// loading
- (MBProgressHUD *)loading;
- (MBProgressHUD *)loading:(NSString *)msg;
- (MBProgressHUD *)loading:(NSString *)msg inView:(UIView *)view;


//tip
- (void)tipMessage:(NSString *)msg;
- (void)tipMessage:(NSString *)msg delay:(CGFloat)seconds;
- (void)tipMessage:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)())completion;
@end

NS_ASSUME_NONNULL_END
