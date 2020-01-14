//
//  CheckOrderViewController.m
//  600生活
//
//  Created by iOS on 2019/11/19.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "CheckOrderViewController.h"
#import "LLBaseView.h"
#import "CheckResultViewController.h"
#import "FindOrderModel.h"


@interface CheckOrderViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *pinkBrotherView;  //渐变色
@property (weak, nonatomic) IBOutlet UITextField *inputTf;

@property (weak, nonatomic) IBOutlet LLBaseView *layoutBottomLine;

@property(nonatomic,assign)BOOL isPasteboardContainStr;  //系统粘贴板是否有值

@end

@implementation CheckOrderViewController

-(void)dealloc
{
    if(self.isPasteboardContainStr == NO){
        //如果没有值，应该清空值
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        board.strings = @[];
    }
}

-(id)init
{
    if(self = [super init]){
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        if (board.hasStrings) {
            //do nothing
            self.isPasteboardContainStr = YES;
        }else{
            self.isPasteboardContainStr = NO;
            //取本地值
            NSString* appLastClearStr = [[NSUserDefaults standardUserDefaults]valueForKey:kAppLastClearStr];
            board.string = appLastClearStr;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单查询";
    
    self.pinkBrotherView.width = kScreenWidth;
    self.pinkBrotherView.height = self.pinkBrotherView.width * 375 / 320;
    [Utility addGradualChangingColorWithView:self.pinkBrotherView fromColor:[UIColor colorWithHexString:@"#FDEEF1"] toColor:[UIColor whiteColor] orientation:@[@0,@0,@0,@1]];
    self.contentView.width = kScreenWidth;
    [self.scrollView addSubview:self.contentView];
    
    _layoutBottomLine.viewDidLayoutNewFrameCallBack = ^(CGRect newFrame) {
        self.contentView.height = newFrame.origin.y + newFrame.size.height;
        if(self.contentView.bottom > self.scrollView.height){
            self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.contentView.bottom);
        }else{
            self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.scrollView.height + 1);
        }
    };
}

//kFindOrder
#pragma mark - 网络请求

//查找一个订单
-(void)requestFindOrder:(NSString*)orderId
{
    NSDictionary* param = @{
        @"id" : orderId
    };
    
    [self GetWithUrlStr:kFullUrl(kFindOrder) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes) {
            [self handleFindOrderSuccess:res[@"data"] orderId:orderId];
        }else{
            [self handleFindOrderFalid];
        }
    } falsed:^(NSError * _Nullable error) {
        [self handleFindOrderFalid];
    }];
}

-(void)handleFindOrderSuccess:(NSDictionary*)orderInfo orderId:(NSString*)orderId
{
    NSError* err = nil;
    FindOrderModel* findOrderModel = [[FindOrderModel alloc]initWithDictionary:orderInfo error:&err];
    if(findOrderModel){
        findOrderModel.orderId = orderId;
        [[LLHudHelper sharedInstance]tipMessage:@"查询成功"];
        __weak CheckOrderViewController* wself = self;
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               CheckResultViewController* vc = [[CheckResultViewController alloc]initWithFindOrderModel:findOrderModel];
               vc.hidesBottomBarWhenPushed = YES;
               [wself.navigationController pushViewController:vc animated:YES];
           });
    }else{
        NSLog(@"查找订单模型转换失败");
    }
}

-(void)handleFindOrderFalid
{
    __weak CheckOrderViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        CheckResultViewController* vc = [[CheckResultViewController alloc]initWithFindOrderModel:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [wself.navigationController pushViewController:vc animated:YES];
    });
}

#pragma mark - control action

- (IBAction)checkBtnAction:(id)sender {
    if(_inputTf.text.length > 0){ //正确数据
        [self requestFindOrder:_inputTf.text];
    }else{
        [[LLHudHelper sharedInstance]tipMessage:@"请正确输入订单号"];
    }
    
}

@end
