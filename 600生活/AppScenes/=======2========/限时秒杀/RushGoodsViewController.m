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

@property(nonatomic,strong)NSArray* rushTimes;//开枪时间
@property(nonatomic,strong)NSString* currentClickedTime; //保存当前点击的开枪时间段

@end

@implementation RushGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableview];
    [self requestTimeList];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenNavigationBarWithAnimation:animated];
    self.fd_prefersNavigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self showNavigationBarWithAnimation:animated];
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
            if([[dic allKeys]containsObject:@"time_list"]){
                [wself handleTimeList:dic[@"time_list"]];
            }
        }
    } falsed:^(NSError * _Nullable error) {
    }];
}

-(void)handleTimeList:(NSArray*)list
{
 
    self.rushTimes = [[NSArray alloc]initWithArray:list];
    
    __weak RushGoodsViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself setupTimeViewWithDatas:list];
    });
}

-(void)requestGoodsListWithTime:(NSString*)time pageIndex:(NSInteger)pageIndex
{
    NSDictionary* param = @{
        @"page":[NSNumber numberWithInteger:pageIndex],
        @"page_size":[NSNumber numberWithInteger:10],
        @"t":time
    };
    
    __weak RushGoodsViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kGetRushGoodsList) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            NSArray* datas = res[@"data"];
            [wself GoodsListWithDatas:datas pageIndex:pageIndex];
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
            [wself.tableview.mj_footer endRefreshingWithNoMoreData];
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
