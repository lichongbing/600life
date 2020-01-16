//
//  RushGoodsViewController.m
//  600生活
//
//  Created by iOS on 2019/11/20.
//  Copyright © 2019 灿男科技. All rights reserved.
//  限时秒杀主界面

#import "RushGoodsViewController.h"
#import "LLBaseView.h"

#import "RushGoodModel.h"

#import "RushGoodTableViewCell.h"
#import "GoodDetailViewController.h"

@interface RushGoodsViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *colorBg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statuBarHeightCons; //状态栏高度

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet LLBaseView *layoutBottomLine;
@property (weak, nonatomic) IBOutlet UILabel *labNextStartTime;

@property(nonatomic,strong)NSArray* rushTimes;//开枪时间
@property(nonatomic,strong)NSString* currentClickedTime; //保存当前点击的开枪时间段
@property(atomic,strong) NSTimer* timer;  //秒杀倒计时
@property(nonatomic,assign) NSInteger timerCounter; //计数器  触发timer 初始为0
@property(nonatomic,strong) NSCalendar* calendar; //计算剩余时间
@property(nonatomic,assign) double double_nextStartTime; //下一场开始时间

@end

@implementation RushGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_prefersNavigationBarHidden = YES;
    [self setupTableview];
    [self requestTimeList];
}


//设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
     return UIStatusBarStyleLightContent; //白色文字
}

#pragma mark - 网络请求
-(void)requestTimeList
{
    __weak RushGoodsViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kGetRushTimelist) param:nil showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            NSDictionary* dic = res[@"data"];
            self.double_nextStartTime = [dic[@"next_start_time"]doubleValue];
            if([[dic allKeys]containsObject:@"time_list"]){
                [wself handleTimeList:dic[@"time_list"] addNextStartTime:self.double_nextStartTime];
            }
        }
    } falsed:^(NSError * _Nullable error) {
    }];
}

-(void)handleTimeList:(NSArray*)list addNextStartTime:(double )double_nextSartTime
{
    self.rushTimes = [[NSArray alloc]initWithArray:list];
    
    NSDate* endDate = [NSDate dateWithTimeIntervalSince1970:double_nextSartTime];
    NSDate* nowDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit type0 = NSCalendarUnitSecond;
    NSDateComponents *cmps0 = [calendar components:type0 fromDate:nowDate toDate:endDate options:0];
    NSInteger newSeconds = cmps0.second; //新的相差的秒数
    if(newSeconds > 0){
        self.timerCounter = newSeconds;
        __weak RushGoodsViewController* wself = self;
        //当前线程为主线程，timer操作放到子线程中去
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [wself deInitGlobalQueueTimer];
            [wself initTimer];
        });
    }else{
        __weak RushGoodsViewController* wself = self;
        //当前线程为主线程，timer操作放到子线程中去
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [wself deInitGlobalQueueTimer];
        });
    }
    
    
    __weak RushGoodsViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself setupTimeViewWithDatas:list];
    });
}

#pragma mark - getter setter

-(NSCalendar*)calendar
{
    if(_calendar == nil){
        _calendar = [NSCalendar currentCalendar];
    }
    return _calendar;
}
#pragma mark - timer
-(void)initTimer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
        [_timer fire];
    }
}

-(void)deInitGlobalQueueTimer
{
    if(_timer){
        [_timer invalidate];
          _timer = nil;
    }
}

-(void)timerAction:(NSTimer*)timer
{
    //action在子线程中
    if (self.timerCounter > 0) {
        self.timerCounter--;
        __weak RushGoodsViewController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDate* endDate = [NSDate dateWithTimeIntervalSince1970:wself.double_nextStartTime];
            NSDate* nowDate = [NSDate date];
            
            //时分秒的格式
            NSCalendarUnit type = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *cmps = [wself.calendar components:type fromDate:nowDate toDate:endDate options:0];
//            NSLog(@"%ld小时%ld分钟%ld秒",cmps.hour, cmps.minute, cmps.second);
            NSString* hStr = [NSString stringWithFormat:@"%ld",cmps.hour];
            if(hStr.length == 1){
                hStr = [NSString stringWithFormat:@"0%@",hStr];
            }
            
            NSString* mStr = [NSString stringWithFormat:@"%ld",cmps.minute];
            if(mStr.length == 1){
                mStr = [NSString stringWithFormat:@"0%@",mStr];
            }
            
            NSString* sStr = [NSString stringWithFormat:@"%ld",cmps.second];
            if(sStr.length == 1){
                sStr = [NSString stringWithFormat:@"0%@",sStr];
            }
            wself.labNextStartTime.text = [NSString stringWithFormat:@"距离结束 %@:%@:%@",hStr,mStr,sStr];
//            wself.rushEndH.text = hStr;
//            wself.rushEndM.text = mStr;
//            wself.rushEndS.text = sStr;
        });
    } else if (self.timerCounter == 0) {
        [self deInitGlobalQueueTimer]; //析构timer
    }
}

-(void)requestGoodsListWithTime:(NSString*)time pageIndex:(NSInteger)pageIndex
{
    if (pageIndex ==1) {
            self.datasource=[NSMutableArray new];
            [self.tableview reloadData];
    }
    NSDictionary* param = @{
        @"page":[NSNumber numberWithInteger:pageIndex],
        @"page_size":[NSNumber numberWithInteger:10],
        @"t":time
    };
    
    __weak RushGoodsViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kGetRushGoodsList) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            NSArray* datas = res[@"data"];
            if (datas.count<=0) {
                [[LLHudHelper sharedInstance]tipMessage:@"没有商品哦！" delay:2.0];
            }else{
                [wself GoodsListWithDatas:datas pageIndex:pageIndex];
            }
        }
    } falsed:^(NSError * _Nullable error) {
    }];
}

-(void)GoodsListWithDatas:(NSArray*)datas pageIndex:(NSInteger)pageIndex
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < datas.count; i++){
        NSError* err = nil;
        RushGoodModel* rushGoodModel = [[RushGoodModel alloc]initWithDictionary:datas[i] error:&err];
        if(!rushGoodModel) {
            NSLog(@"RushGoodModel转换失败");
        }else{
            [mutArr addObject:rushGoodModel];
        }
    }
    if(mutArr.count>0){
        [self configDataSource:mutArr];
    }
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak RushGoodsViewController* wself = self;
    if (tempArray.count > 0) { //有数据
        if(self.pageIndex == 1){//头部刷新
            self.datasource = [[NSMutableArray alloc]initWithArray:tempArray];
        } else if(self.pageIndex > 1){ //尾部加载
            [self.datasource addObjectsFromArray:tempArray];
        }
        __weak RushGoodsViewController* wself = self;
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(wself.datasource.count == 0){
            [Utility showTipViewOn:wself.tableview type:0 iconName:@"tipview无商品" msg:@"无商品!"];
        }else{
            [Utility dismissTipViewOn:wself.tableview];
        }
    });
}

#pragma mark - UI

-(void)setupTableview
{
    self.scrollView.delegate = (id)self;
    self.tableview.tableHeaderView = self.headerView;
    _statuBarHeightCons.constant = kStatusBarHeight;
    self.tableview.top = -kStatusBarHeight;
    
    __weak RushGoodsViewController* wself = self;
    self.layoutBottomLine.viewDidLayoutNewFrameCallBack = ^(CGRect newFrame) {
        wself.headerView.height = newFrame.origin.y + newFrame.size.height;
        wself.tableview.tableHeaderView = wself.headerView;
    };
    
    
    self.colorBg.width = kScreenWidth;
    self.colorBg.height = kNavigationBarHeight + self.scrollView.height;
    [Utility addGradualChangingColorWithView:self.colorBg fromColor:[UIColor colorWithHexString:@"#F54556"] toColor:[UIColor colorWithHexString:@"#F78144"] orientation:@[@0,@0,@0,@1]];
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"RushGoodTableViewCell" bundle:nil] forCellReuseIdentifier:@"RushGoodTableViewCell"];
    [self addMJRefresh];
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RushGoodTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RushGoodTableViewCell" forIndexPath:indexPath];
    [cell fullData:self.datasource[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RushGoodModel* rushGoodModel = [self.datasource objectAtIndex:indexPath.row];
    if(rushGoodModel.item_id){
        GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:rushGoodModel.item_id];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [[LLHudHelper sharedInstance]tipMessage:@"商品数据异常"];
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark - control action

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cellTapAction:(UITapGestureRecognizer*)tap
{
    UIView* cell = tap.view;
    for(int i = 0; i < self.scrollView.subviews.count; i++){
        UIView* cell = [self.scrollView viewWithTag:(i+10)];
        [self celarCell:cell];
    }
    [self rushTimeBeginWithCell:cell];
}

#pragma mark - helper

-(void)addMJRefresh
{
    __weak RushGoodsViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码

        if(wself.currentClickedTime != nil){
            wself.pageIndex=1;
            [wself requestGoodsListWithTime:wself.currentClickedTime pageIndex:wself.pageIndex];
            [wself impactLight];
        }
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
        wself.isMJFooterRefresh = YES;
        if(wself.currentClickedTime != nil){
            wself.pageIndex++;
            [wself requestGoodsListWithTime:wself.currentClickedTime pageIndex:wself.pageIndex];
            [wself impactLight];
        }
    }];
    
    if(wself.currentClickedTime != nil){
        [self.tableview.mj_header beginRefreshing];
    }
}


-(void)setupTimeViewWithDatas:(NSArray*)times
{
    if(times){
        for(UIView* subView in self.scrollView.subviews){
            [subView removeFromSuperview];
        }
    }
    
    CGFloat left = 10;
    CGFloat space = ((kScreenWidth - 12 * 2) - 75 * 5) / 4;
    for(int i = 0; i < times.count; i++){
        UIView* cell = [UIView new];
        cell.tag = (10+i);
        cell.width = 75;
        cell.height = 45;
        
        
        //10:00
        UILabel* timeLab = [UILabel new];
        [cell addSubview:timeLab];
        timeLab.tag = 1;
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = [UIFont systemFontOfSize:16];
        timeLab.textColor = [UIColor whiteColor];
        timeLab.width = cell.width;
        timeLab.height = 18;
        timeLab.left =  0;
        timeLab.top = 8;
        timeLab.text = times[i][@"time"];
        
        //已开抢
        UILabel* desLab = [UILabel new];
        desLab.tag = 2;
        [cell addSubview:desLab];
        desLab.textAlignment = NSTextAlignmentCenter;
        desLab.font = [UIFont systemFontOfSize:12];
        desLab.textColor = [UIColor whiteColor];
        desLab.width = cell.width;
        desLab.height = 15;
        desLab.left = 0;
        desLab.bottom = 40;
        desLab.text = times[i][@"desc"];
        
        [self.scrollView addSubview:cell];
        cell.left = left;
        cell.top = 0;
        left = cell.right + space;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTapAction:)];
        cell.userInteractionEnabled = YES;
        [cell addGestureRecognizer:tap];
        
        if(left > self.scrollView.width){
            self.scrollView.contentSize = CGSizeMake(left, self.scrollView.height);
        }
        
        if([times[i][@"check"] intValue] == 1){ //如果check字段是1说明正在抢
            [self rushTimeBeginWithCell:cell];
        }
    }
}

-(void)rushTimeBeginWithCell:(UIView*)cell
{
    cell.backgroundColor = [UIColor whiteColor];
    UILabel* timeLab = [cell viewWithTag:1];
    timeLab.textColor = [UIColor colorWithHexString:@"#F54556"];
    UILabel* desLab = [cell viewWithTag:2];
    desLab.textColor = [UIColor colorWithHexString:@"#F54556"];
    cell.layer.cornerRadius = 4;
    cell.clipsToBounds = YES;
    
    //数据相关
    int index = ((int)cell.tag - 10);
    NSString* time = self.rushTimes[index][@"t"];
    self.currentClickedTime = time;
    self.pageIndex = 1;
    [self requestGoodsListWithTime:self.currentClickedTime pageIndex:self.pageIndex];
}

-(void)celarCell:(UIView*)cell
{
    cell.backgroundColor = [UIColor clearColor];
    UILabel* timeLab = [cell viewWithTag:1];
    timeLab.textColor = [UIColor whiteColor];
    UILabel* desLab = [cell viewWithTag:2];
    desLab.textColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 0;
    cell.clipsToBounds = NO;
}
@end
