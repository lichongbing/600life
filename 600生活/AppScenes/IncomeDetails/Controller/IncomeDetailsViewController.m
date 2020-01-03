//
//  IncomeDetailsViewController.m
//  600生活
//
//  Created by iOS on 2019/11/14.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "IncomeDetailsViewController.h"
#import "IncomeDetailTableViewCell.h"
#import "LeeDatePickerView.h"
#import "IncomeItemModel.h"

@interface IncomeDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerDateLab;
@property (weak, nonatomic) IBOutlet UILabel *headerDesLab;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

//明细类型 0个人收益    1推广收益
@property(nonatomic,assign) int showType;
@property(nonatomic,strong) NSString* selectTimeStr;

@end

@implementation IncomeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"收益明细";
    [self setNavRightItemWithImage:[UIImage imageNamed:@"Income日历"] selector:@selector(rightItemAction)];
    [self setupTableView];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM"];
    NSString* dateStr = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@",dateStr);
    self.headerDateLab.text = [NSString stringWithFormat:@"日期：%@月",dateStr];
    self.headerDesLab.text = [NSString stringWithFormat:@"%@月25日到账",dateStr];
    
}


#pragma mark - UI
-(void)setupTableView
{
    self.tableview.top = 88;
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight - 88;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    self.tableview.estimatedRowHeight = 100;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerNib:[UINib nibWithNibName:@"IncomeDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"IncomeDetailTableViewCell"];
    self.tableview.backgroundColor = [UIColor whiteColor];
    [self addMJRefresh];
}


#pragma mark - 网络请求

//获取收益明细 time: 2019-11
-(void)requestEarningList:(NSInteger)pageIndex time:(NSString*)time
{
    NSDictionary* param = nil;
    if(time){
        param = @{
            @"page":[NSNumber numberWithInteger:pageIndex],
            @"page_size":@"10",
            @"time":time,
            @"is_spread" : self.showType == 0 ? @"0" : @"1"
        };
    }else{
        param = @{
            @"page":[NSNumber numberWithInteger:pageIndex],
            @"page_size":@"10",
            @"is_spread" : self.showType == 0 ? @"0" : @"1"
        };
    }
     
    [self GetWithUrlStr:kFullUrl(kEarningList) param:param showHud:YES resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [self handleEarningList:pageIndex datas:cacheData[@"data"]];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleEarningList:pageIndex datas:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleEarningList:(NSInteger)pageIndex datas:(NSArray*)list
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < list.count; i++){
        NSError* err = nil;
        IncomeItemModel* incomeItemModel = [[IncomeItemModel alloc]initWithDictionary:list[i] error:&err];
        if(incomeItemModel){
            [mutArr addObject:incomeItemModel];
        } else {
            NSLog(@"收益模型创建失败");
        }
    }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak IncomeDetailsViewController* wself = self;
    if (tempArray.count > 0) { //有数据
        if(self.pageIndex == 1){//头部刷新
            self.datasource = [[NSMutableArray alloc]initWithArray:tempArray];
        } else if(self.pageIndex > 1){ //尾部加载
            [self.datasource addObjectsFromArray:tempArray];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.tableview reloadData];
        });
    } else { //无数据
        self.pageIndex--; // 此时的pageIndex 取不到数据 应该-1
        dispatch_async(dispatch_get_main_queue(), ^{
            if(wself.datasource.count > 0){
                 [wself.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        });
    }
    
    if(self.datasource.count > 0){
        [Utility dismissTipViewOn:self.tableview];
    }else{
        [Utility dismissTipViewOn:self.tableview];
        NSString* str = self.showType == 0 ? @"没有个人收益明细哟!" : @"没有推广收益明细哟!";
        [Utility showTipViewOn:self.tableview type:0 iconName:@"tipview无浏览记录" msg:str];
    }
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IncomeDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IncomeDetailTableViewCell" forIndexPath:indexPath];
    [cell fullData:self.datasource[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - control action

- (IBAction)leftBtnAction:(id)sender {
    __weak IncomeDetailsViewController* wself = self;
    [UIView animateWithDuration:0.3 animations:^{
       if(![wself.leftBtn.backgroundColor isEqual:[UIColor colorWithHexString:@"F54556"]]){
            wself.leftBtn.backgroundColor = [UIColor colorWithHexString:@"F54556"];
            [wself.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            wself.rightBtn.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
            [wself.rightBtn setTitleColor:[UIColor colorWithHexString:@"898989"] forState:UIControlStateNormal];
           
           wself.showType = 0;
           [wself requestEarningList:wself.pageIndex time:wself.selectTimeStr];
        }
    }];
    
}


- (IBAction)rightBtnAction:(id)sender {
    __weak IncomeDetailsViewController* wself = self;
    [UIView animateWithDuration:0.3 animations:^{
        if(![wself.rightBtn.backgroundColor isEqual:[UIColor colorWithHexString:@"F54556"]]){
              wself.rightBtn.backgroundColor = [UIColor colorWithHexString:@"F54556"];
              [wself.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
              
              wself.leftBtn.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
              [wself.leftBtn setTitleColor:[UIColor colorWithHexString:@"898989"] forState:UIControlStateNormal];
            
            wself.showType = 1;
            [wself requestEarningList:wself.pageIndex time:wself.selectTimeStr];
          }
    }];
  
}

#pragma mark - helper

-(void)addMJRefresh
{
    __weak IncomeDetailsViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        wself.pageIndex=1;
        [wself requestEarningList:wself.pageIndex time:nil];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
        wself.isMJFooterRefresh = YES;
        wself.pageIndex++;
        [wself requestEarningList:wself.pageIndex time:nil];
        [wself impactLight];
    }];
    
    [self.tableview.mj_header beginRefreshing];
}

-(void)rightItemAction
{
    __weak IncomeDetailsViewController* wself= self;
    [LeeDatePickerView showLeeDatePickerViewWithStyle:LeeDatePickerViewStyle_Single formatterStyle:LeeDatePickerViewDateFormatterStyle_yMd block:^(NSArray<NSDate *> *dateArray) {
        NSDate* date = dateArray.firstObject;
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM"];
        NSString* timeStr = [formatter stringFromDate:date];
        wself.pageIndex = 1;
        wself.selectTimeStr = timeStr;
        [wself requestEarningList:self.pageIndex time:wself.selectTimeStr];
    }];
}
@end
