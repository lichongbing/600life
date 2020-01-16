//
//  GuidenceViewController.m
//  600生活
//
//  Created by iOS on 2019/11/15.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "GuidenceViewController.h"
#import "AppDelegate.h"
#import "LLTabBarController.h"
#import "TeachAVPlayerViewController.h" //新手教程

@interface GuidenceViewController ()

@end

@implementation GuidenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if(kIsiPhoneX_Series){
        self.imageArray = @[@"guidence1_ipx",@"guidence2_ipx",@"guidence3_ipx"];
    }else{
        self.imageArray = @[@"guidence1",@"guidence2",@"guidence3"];
    }
    
    self.scrlView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    self.scrlView.pagingEnabled = YES;
    self.scrlView.showsHorizontalScrollIndicator = NO;
    self.scrlView.showsVerticalScrollIndicator = NO;
    self.scrlView.bounces = NO;
    self.scrlView.backgroundColor = [UIColor clearColor];
    self.scrlView.delegate = (id)self;
    [self.view addSubview:self.scrlView];
    NSInteger count = [self.imageArray count];
    for (int i = 0; i < count; i++)
    {
        NSString *imageName = [self.imageArray objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*CGRectGetWidth(self.scrlView.bounds), 0, CGRectGetWidth(self.scrlView.bounds), CGRectGetHeight(self.scrlView.bounds))];
        imageView.image = [UIImage imageNamed:imageName];
        
        imageView.userInteractionEnabled = YES;
        
        [self.scrlView addSubview:imageView];
        
        
        if (i != [self.imageArray count] -1) {
            [self setupSkipBtn:imageView];
        } else {
            [self setupEnterBtn:imageView];
        }
    }
    self.scrlView.contentSize = CGSizeMake(CGRectGetWidth(self.scrlView.bounds)*count, CGRectGetHeight(self.scrlView.bounds));
}

-(void)setupSkipBtn:(UIView*)superView
{
    UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    skipBtn.tag = 10;
    skipBtn .width = 46;
    skipBtn.height = 20;
    skipBtn.right = kScreenWidth  - 10;
    skipBtn.top = kStatusBarHeight + 20;
    skipBtn.layer.cornerRadius = 10;
    skipBtn.clipsToBounds = YES;
    skipBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    skipBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [skipBtn addTarget:self action:@selector(skipBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:skipBtn];
}

-(void)setupEnterBtn:(UIView*)superView
{
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enterBtn.tag = 10;
    enterBtn .width = 110;
    enterBtn.height = 35;
    enterBtn.centerX = superView.width * 0.5;
    CGFloat kSH = kScreenHeight;
    enterBtn.bottom =kSH - 30;
//    if(kIsiPhoneX_Series){
//        enterBtn.bottom = superView.height * 0.88;
//    }else{
//        enterBtn.bottom = superView.height * 0.91;
//    }
    
    enterBtn.layer.borderWidth = 1;
    enterBtn.layer.borderColor = [UIColor redColor].CGColor;
    enterBtn.backgroundColor = [UIColor whiteColor];
    [enterBtn setTitle:@"立刻体验" forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [enterBtn addTarget:self action:@selector(enterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:enterBtn];
}

#pragma mark - control action
-(void)skipBtnAction:(UIButton*)skipBtn
{
    [self finishGuidance:skipBtn];
}

-(void)enterBtnAction:(UIButton*)enterBtn
{
    [self finishGuidance:enterBtn];
}

#pragma mark -- scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/CGRectGetWidth(scrollView.bounds);
    self.pageControl.currentPage = index;
}

-(void)finishGuidance:(UIButton*)sender{
    NSInteger tag = sender.tag;
    if(tag == 10){
        LLTabBarController* rootTabbarVC = [LLTabBarController sharedController];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.rootViewController = rootTabbarVC;
        [window makeKeyAndVisible];
    }else if(tag == 11){
        //播放视频
        NSString *mp4Path = [[NSBundle mainBundle]pathForResource:@"qidong.mp4"ofType:nil];
        TeachAVPlayerViewController* vc = [[TeachAVPlayerViewController alloc]initWithFilePath:mp4Path];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
        vc.didClickedEnterMainCallBack = ^{
            LLTabBarController* rootTabbarVC = [[LLTabBarController alloc]init];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = rootTabbarVC;
            [window makeKeyAndVisible];
        };
    }
}

@end
