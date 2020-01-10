//
//  ViewController2.m
//  600生活
//
//  Created by iOS on 2019/11/4.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "ViewController2.h"
#import "CategoryMainController.h"
#import "SearchHistoryViewController.h"
#import "LoginAndRigistMainVc.h"

@interface ViewController2 ()

@property(nonatomic,strong)CategoryMainController* categoryMainController;
@property (strong, nonatomic) IBOutlet UIView *navTitleView;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_prefersNavigationBarHidden = YES;
    _navTitleView.width = kScreenWidth;
    _navTitleView.height = kNavigationBarHeight;
    [self.view addSubview:_navTitleView];
    
    self.categoryMainController = [CategoryMainController new];
    [self addChildViewController:self.categoryMainController];
    self.categoryMainController.view.frame = CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight - kTabbarHeight);
    [self.view addSubview:self.categoryMainController.view];
}


#pragma mark - control action

- (IBAction)searchBtnAction:(id)sender {
    
    if([LLUserManager shareManager].currentUser == nil){
        __weak ViewController2* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    SearchHistoryViewController* vc = [SearchHistoryViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
