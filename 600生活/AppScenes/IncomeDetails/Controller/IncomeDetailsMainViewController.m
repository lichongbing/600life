//
//  IncomeDetailsViewController.m
//  600生活
//
//  Created by iOS on 2019/11/14.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "IncomeDetailsMainViewController.h"
#import "IncomeDetailTableViewCell.h"
#import "LeeDatePickerView.h"
#import "IncomeItemModel.h"
#import "IncomeDetailSubViewController.h"

@interface IncomeDetailsMainViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerDateLab;
@property (weak, nonatomic) IBOutlet UILabel *headerDesLab;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

//明细类型 0个人收益    1推广收益
@property(nonatomic,assign) int showType;
@property(nonatomic,strong) NSString* selectTimeStr;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//个人收益
@property(nonatomic,strong)IncomeDetailSubViewController* list1VC;
//推广收益
@property(nonatomic,strong)IncomeDetailSubViewController* list2VC;

@end

@implementation IncomeDetailsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"收益明细";
    [self setNavRightItemWithImage:[UIImage imageNamed:@"Income日历"] selector:@selector(rightItemAction)];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM"];
    NSString* dateStr = [formatter stringFromDate:[NSDate date]];
    self.selectTimeStr = dateStr;
    self.headerDateLab.text = [NSString stringWithFormat:@"日期：%@",dateStr];
    self.headerDesLab.text = [NSString stringWithFormat:@"%@月25日到账",dateStr];
    
    [self setupSubVCs];
}


#pragma mark - UI
-(void)setupSubVCs
{
    _list1VC = [[IncomeDetailSubViewController alloc]initWithType:0];
    _list2VC = [[IncomeDetailSubViewController alloc]initWithType:1];
    
    [self addChildViewController:_list1VC];
    [self addChildViewController:_list2VC];
    
    [self.scrollView addSubview:_list1VC.view];
    [self.scrollView addSubview:_list2VC.view];
    
    _list1VC.view.frame = CGRectMake(0, 0, kScreenWidth, _scrollView.height);
    _list2VC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, _scrollView.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, _scrollView.height);
    self.scrollView.delegate = (id)self;
}




#pragma mark - uiscrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/CGRectGetWidth(scrollView.bounds);
    if(index == 0){
        [self topBtnMoveToLeft];
    }else if(index == 1){
        [self topBtnMoveToRight];
    }
}

#pragma mark - control action

- (IBAction)leftBtnAction:(id)sender {
    [self topBtnMoveToLeft];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)rightBtnAction:(id)sender {
    [self topBtnMoveToRight];
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}


-(void)rightItemAction
{
    __weak IncomeDetailsMainViewController* wself= self;
    [LeeDatePickerView showLeeDatePickerViewWithStyle:LeeDatePickerViewStyle_Single formatterStyle:LeeDatePickerViewDateFormatterStyle_yMd block:^(NSArray<NSDate *> *dateArray) {
        NSDate* date = dateArray.firstObject;
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM"];
        NSString* timeStr = [formatter stringFromDate:date];
        wself.pageIndex = 1;
        wself.selectTimeStr = timeStr;
        self.headerDateLab.text = [NSString stringWithFormat:@"日期：%@",timeStr];
        wself.list1VC.time = timeStr;
        wself.list2VC.time = timeStr;
    }];
}

-(void)topBtnMoveToLeft
{
    __weak IncomeDetailsMainViewController* wself = self;
       [UIView animateWithDuration:0.3 animations:^{
          if(![wself.leftBtn.backgroundColor isEqual:[UIColor colorWithHexString:@"F54556"]]){
               wself.leftBtn.backgroundColor = [UIColor colorWithHexString:@"F54556"];
               [wself.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
               
               wself.rightBtn.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
               [wself.rightBtn setTitleColor:[UIColor colorWithHexString:@"898989"] forState:UIControlStateNormal];
              
              wself.showType = 0;
//              [wself requestEarningList:wself.pageIndex time:wself.selectTimeStr];
           }
       }];
}
-(void)topBtnMoveToRight
{
    __weak IncomeDetailsMainViewController* wself = self;
       [UIView animateWithDuration:0.3 animations:^{
           if(![wself.rightBtn.backgroundColor isEqual:[UIColor colorWithHexString:@"F54556"]]){
                 wself.rightBtn.backgroundColor = [UIColor colorWithHexString:@"F54556"];
                 [wself.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 
                 wself.leftBtn.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
                 [wself.leftBtn setTitleColor:[UIColor colorWithHexString:@"898989"] forState:UIControlStateNormal];
               
               wself.showType = 1;
//               [wself requestEarningList:wself.pageIndex time:wself.selectTimeStr];
             }
       }];
}

@end
