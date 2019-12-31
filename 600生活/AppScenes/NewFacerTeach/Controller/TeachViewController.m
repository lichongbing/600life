//
//  TeachViewController.m
//  600生活
//
//  Created by iOS on 2019/12/2.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "TeachViewController.h"

@interface TeachViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic)  UIImageView *imageView;

@end

@implementation TeachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"新手教程";
    self.imageView = [UIImageView new];
    self.imageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.scrollView addSubview:self.imageView];
    [self requestTeach];
}

#pragma mark - 网络请求
-(void)requestTeach
{
    __weak TeachViewController* wself = self;
    [self loadingMessage:@"加载中"];
    [self GetWithUrlStr:kFullUrl(kNewTeach) param:nil showHud:YES resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself handleTeach:cacheData[@"data"]];
            });
        }
        [wself stopLoading];
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself handleTeach:res[@"data"]];
            });
        }
        [wself stopLoading];
    } falsed:^(NSError * _Nullable error) {
        [wself stopLoading];
    }];
}

-(void)handleTeach:(NSString*)data
{
    [self loadingMessage:@"加载中"];
      __weak TeachViewController* wself = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:data] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [wself stopLoading];
        if(image){
            CGFloat imageHeight = kScreenWidth * image.size.height /image.size.width ;
            wself.imageView.height = imageHeight;
            wself.scrollView.contentSize = CGSizeMake(kScreenWidth, imageHeight);
        }
    }];
}

@end
