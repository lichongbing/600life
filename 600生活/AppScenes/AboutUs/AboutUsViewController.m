//
//  AboutUsViewController.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "AboutUsViewController.h"
#import "WebViewViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"关于我们";
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
