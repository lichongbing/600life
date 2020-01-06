//
//  IncomeViewController.m
//  600生活
//
//  Created by iOS on 2019/11/13.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "IncomeViewController.h"
#import "IncomeDetailsMainViewController.h" //收益明细
#import "LLBaseView.h"
#import "IncomeModel.h"  //收益模型

@interface IncomeViewController ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet LLBaseView *layoutButtomLine;

@property (weak, nonatomic) IBOutlet UILabel *allIncomesLab; //累计收益

@property (weak, nonatomic) IBOutlet UILabel *ramainLab; //余额

@property (weak, nonatomic) IBOutlet UILabel *lastMonthIncomeLab;//上月收益

@property (weak, nonatomic) IBOutlet UILabel *thisMonthIncomeLab; //本月收益
@property (weak, nonatomic) IBOutlet UILabel *todayIncomLab; //本日收益


@property (weak, nonatomic) IBOutlet UILabel *todayCountLab; //今日付款笔数

@property (weak, nonatomic) IBOutlet UILabel *todayOtherLab; //今日其他收益


@property (weak, nonatomic) IBOutlet UILabel *thisMonthIncomeEstablishLab;//本月预估收益
@property (weak, nonatomic) IBOutlet UILabel *thisMonthCountLab;//本月付款笔数

@property (weak, nonatomic) IBOutlet UILabel *thisMonthOtherLab;//本月其他收益



@property(nonatomic,strong)IncomeModel* incomeModel;

@end

@implementation IncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"淘宝收益";
    
    [self setNavRightItemWithTitle:@"收益明细" titleColor:[UIColor colorWithHexString:@"#666666"] selector:@selector(rightItemAction)];
    
    
    self.tableview.tableHeaderView = self.contentView;
    __weak IncomeViewController* wself = self;
    self.layoutButtomLine.viewDidLayoutNewFrameCallBack = ^(CGRect newFrame) {
        wself.contentView.height = newFrame.origin.y + newFrame.size.height;
        self.tableview.tableHeaderView = wself.contentView;
    };
    
    [self requestProfileEarnings];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - 网络请求

//我的收益
-(void)requestProfileEarnings
{

    [self GetWithUrlStr:kFullUrl(kProfileEarnings) param:nil showHud:YES resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [self handlekProfileEarnings:cacheData[@"data"]];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handlekProfileEarnings:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}
-(void)handlekProfileEarnings:(NSDictionary*)data
{
    IncomeModel* incomeModel = [[IncomeModel alloc]initWithDictionary:data error:nil];
    self.incomeModel = incomeModel;
    
    __weak IncomeViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        //全部收益
        wself.allIncomesLab.text = [NSString stringWithFormat:@"￥%@",incomeModel.total_earnings];
        
        //余额
        wself.ramainLab.text = [NSString stringWithFormat:@"账户余额(元):￥%@",incomeModel.balance];
        
        //上月结算收益
        wself.lastMonthIncomeLab.text = [NSString stringWithFormat:@"%@",incomeModel.last_month_settlement];
        
        //本月收益
        wself.thisMonthIncomeLab.text = [NSString stringWithFormat:@"%@",incomeModel.month_forecast];
        
        //今日预估
        wself.todayIncomLab.text = [NSString stringWithFormat:@"预估收益￥%@",incomeModel.today_forecast];
        
        //今日付款笔数
        wself.todayCountLab.text = [NSString stringWithFormat:@"%@",incomeModel.today_order_count];
        
        //今日推广收益
        wself.todayOtherLab.text = [NSString stringWithFormat:@"￥%@",incomeModel.today_other];
        
        //本月预估
        wself.thisMonthIncomeEstablishLab.text =  [NSString stringWithFormat:@"预估收益￥%@",incomeModel.month_forecast];
        
        //本月笔数
        wself.thisMonthCountLab.text = [NSString stringWithFormat:@"%@",incomeModel.month_order_count];
        
        //本月推广收益
        wself.thisMonthOtherLab.text = [NSString stringWithFormat:@"￥%@",incomeModel.month_other];
    });
}

#pragma mark - control action

-(void)rightItemAction
{
    IncomeDetailsMainViewController* vc = [IncomeDetailsMainViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//结算收入
- (IBAction)jiesuanBtnAction:(id)sender {
    [LLHudHelper alertTitle:@"结算收入" message:@"\n上个月内确认收获的订单收益，每月25 日结算后，将转入到余额中" cancel:@"我知道了"];
}

//预估收入
- (IBAction)yuguBtnAction:(id)sender {
     [LLHudHelper alertTitle:@"预估收入" message:@"\n本月内创建的所有订单预估收益" cancel:@"我知道了"];
}

@end
