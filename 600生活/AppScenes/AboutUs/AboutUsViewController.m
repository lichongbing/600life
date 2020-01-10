//
//  AboutUsViewController.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "AboutUsViewController.h"
#import "WebViewViewController.h"
#import "LLWindowTipView.h"

@interface AboutUsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLab; //构建版本lab
@property (weak, nonatomic) IBOutlet UILabel *versionInfo;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"关于我们";
    self.versionLab.text = [NSString stringWithFormat:@"v%@",kAppBuildVersion];
    [self requestCheckVersion];
}

#pragma mark - 网络请求
-(void)requestCheckVersion
{
    NSDictionary* param = @{
        @"current_version" : @"1.0"
    };

    [[LLNetWorking sharedWorking]helper];
    __weak AboutUsViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kCHeckVersion) param:param showHud:NO resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [wself handleCheckVersion:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleCheckVersion:(NSDictionary*)data
{
    NSString* maxVersion = data[@"version"];
    NSString* currentVersion = kAppBuildVersion;
    [self checkWithMaxVersion:maxVersion currentVersion:currentVersion];
}

-(void)checkWithMaxVersion:(NSString*)maxVersion currentVersion:(NSString*)currentVersion
{
    NSArray* maxVersionArr = [maxVersion componentsSeparatedByString:@"."];
    NSArray* currentVersionArr = [currentVersion componentsSeparatedByString:@"."];
    
    NSString* item0Max = maxVersionArr.firstObject;
    NSString* item0 = currentVersionArr.firstObject;
    
    if(item0Max.intValue > item0.intValue){
        //需要更新
        [self updateVersion:maxVersion];
    }else{
        NSString* item1Max = maxVersionArr[1];
        NSString* item1 = currentVersionArr[1];
        if(item1Max.intValue > item1.intValue){
            //需要更新
            [self updateVersion:maxVersion];
        }else{
            NSString* item2Max = maxVersionArr[2];
            NSString* item2 = currentVersionArr[2];
            if(item2Max.intValue > item2.intValue){
                //需要更新
                [self updateVersion:maxVersion];
            }else{
                NSString* item3Max = maxVersionArr[3];
                NSString* item3 = currentVersionArr[3];
                if(item3Max.intValue > item3.intValue){
                    //需要更新
                    [self updateVersion:maxVersion];
                } else {
                    NSLog(@"全部通过");
                }
            }
        }
    }
}

-(void)updateVersion:(NSString*)maxVersion
{
    __weak AboutUsViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        wself.versionInfo.text = [NSString stringWithFormat:@"有新版本:v%@",maxVersion];
        LLWindowTipView* view = [[LLWindowTipView alloc]initWithType:WindowTipViewTypeNewVersion];
        __weak LLWindowTipView* wview = view;
        view.findNewVersionBtnAction = ^{
            NSURL* url = [NSURL URLWithString:kAppStoreLink];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            [wview dismiss];
        };
        [view show];
    });
}

//隐私政策
- (IBAction)yinsiBtnAction:(id)sender {
    NSString* url = kFullUrl(@"api/common/userPrivccy");
    WebViewViewController* vc = [[WebViewViewController alloc]initWithUrl:url title:@"隐私政策"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//用户注册服务协议
- (IBAction)zhuceBtnAction:(id)sender {
    NSString* url = kFullUrl(@"api/common/regServicePolicy");
    WebViewViewController* vc = [[WebViewViewController alloc]initWithUrl:url title:@"用户注册服务协议"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//平台服务协议和交易规则
- (IBAction)fuwuBtnAction:(id)sender {
    NSString* url = kFullUrl(@"api/common/agreementAndRule");
       WebViewViewController* vc = [[WebViewViewController alloc]initWithUrl:url title:@"平台服务协议和交易规则"];
       vc.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:vc animated:YES];
}

@end
