//
//  LLHudHelper.m
//  600生活
//
//  Created by iOS on 2019/11/4.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "LLHudHelper.h"

static LLHudHelper *_instance = nil;

@implementation LLHudHelper

+ (LLHudHelper *)sharedInstance
{
    @synchronized(_instance)
    {
        if (_instance == nil)
        {
            _instance = [[LLHudHelper alloc] init];
        }
        return _instance;
    }
}

+ (void)alert:(NSString *)msg
{
    [LLHudHelper alert:msg cancel:@"确定"];
}

+ (void)alert:(NSString *)msg action:(CommonVoidBlock)action
{
    [LLHudHelper alert:msg cancel:@"确定" action:action];
}

+ (void)alert:(NSString *)msg cancel:(NSString *)cancel
{
    [LLHudHelper alertTitle:@"提示" message:msg cancel:cancel];
}

+ (void)alert:(NSString *)msg cancel:(NSString *)cancel action:(CommonVoidBlock)action
{
    [LLHudHelper alertTitle:@"提示" message:msg cancel:cancel sure:nil cancelAction:action sureAction:nil];
}

+(void)alertTitle:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancel
{
    [self alertTitle:title message:msg cancel:cancel sure:nil cancelAction:^{
    } sureAction:nil];
}

+ (void)alertTitle:(NSString *)title message:(NSString *)msg cancel:(NSString *)cancelStr sure:(NSString*)sureStr cancelAction:(CommonVoidBlock)cancelAction sureAction:(CommonVoidBlock)sureAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (cancelStr) {
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelAction) {
                cancelAction();
            }
        }];
        [alert addAction:cancle];
    }
    if (sureStr) {
        UIAlertAction *sure = [UIAlertAction actionWithTitle:sureStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (sureAction) {
                sureAction();
            }
        }];
        [alert addAction:sure];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
         [[[[UIApplication sharedApplication]keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
    });
}




//超时停止loading

- (MBProgressHUD *)loading
{
    return [self loading:nil];
}

- (MBProgressHUD *)loading:(NSString *)msg
{
    return [self loading:msg inView:nil];
}

- (MBProgressHUD *)loading:(NSString *)msg inView:(UIView* )view
{
    UIView *inView = view ? view : [UIApplication sharedApplication].keyWindow;
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:inView animated:YES] ;
    hud.removeFromSuperViewOnHide = YES ;
    hud.userInteractionEnabled = NO ;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (msg.length > 0)
        {
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.label.text = msg;
        }
        
        [hud showAnimated:YES];
        // 超时自动消失
         [hud hideAnimated:YES afterDelay:kTimeOutInterval];
    });
    return hud;
}


- (void)tipMessage:(NSString *)msg
{
     [self tipMessage:msg delay:1.0];
}

- (void)tipMessage:(NSString *)msg delay:(CGFloat)seconds
{
    [self tipMessage:msg delay:seconds completion:nil];
}

- (void)tipMessage:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)())completion
{
    if (!msg)
    {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES] ;
        hud.removeFromSuperViewOnHide = YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = msg;
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:seconds];
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (completion)
            {
                completion();
            }
        });
    });
}

@end
