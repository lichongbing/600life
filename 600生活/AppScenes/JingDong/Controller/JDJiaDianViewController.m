//
//  JDJiaDianViewController.m
//  600生活
//
//  Created by iOS on 2020/1/9.
//  Copyright © 2020 灿男科技. All rights reserved.
//

#import "JDJiaDianViewController.h"

@interface JDJiaDianViewController ()

@end

@implementation JDJiaDianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"京东家电";
    self.tableview.top = 10;
    self.tableview.left = 0;
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight - self.tableview.top;
    __weak JDJiaDianViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself.tableview.mj_header beginRefreshing];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
