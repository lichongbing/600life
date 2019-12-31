//
//  FeedBackViewController.m
//  600生活
//
//  Created by iOS on 2019/12/5.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *telTf;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"意见反馈";
    self.contentView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:self.contentView];
}

- (IBAction)sureBtnAction:(id)sender {
    if(!(self.textView.text.length > 0)){
        [[LLHudHelper sharedInstance]tipMessage:@"请填写问题描述"];
    }else{
        [self loading];
        
        __weak FeedBackViewController* wself = self;
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [wself stopLoading];
           [[LLHudHelper sharedInstance]tipMessage:@"提交成功"];
           [wself.navigationController popViewControllerAnimated:YES];
        });
    }
}

@end
