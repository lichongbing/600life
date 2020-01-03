//
//  WanJuanViewController.m
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "WanJuanViewController.h"
#import "WanJuanTableViewCell.h"
#import "CouponGood.h"
#import "GoodDetailViewController.h"

@interface WanJuanViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *constLabBgView; //超值美券 背景

@end

@implementation WanJuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"万券齐发";
    [self setNavRightItemWithImage:[UIImage imageNamed:@"刷新"] selector:@selector(rightItemAction)];
    self.contentView.width = kScreenWidth;
    
    self.bgImageView.width = self.contentView.width;
    self.bgImageView.height = self.bgImageView.width * 175 / 375 ;
    
    
    //设置tableview的header
    self.constLabBgView.width = kScreenWidth;
    self.constLabBgView.height = 40;
    self.constLabBgView.left = 0;
    self.constLabBgView.top = self.bgImageView.bottom - 20; //向上移动40
    
    //设置table
    [self.contentView addSubview:self.tableview];
    self.tableview.left = 0;
    self.tableview.top = self.constLabBgView.bottom - 6; //6是圆角
    self.tableview.width = self.contentView.width;
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight - self.constLabBgView.height;
    self.contentView.height = self.tableview.bottom;
    
    self.scrollView.delegate = (id)self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:self.contentView];
    self.tableview.scrollEnabled = NO;  //初始状态下，先让scrollView可以滑动，tableview无法滑动
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.contentView.height );
    
    [self setupBottomTableView];
}

-(void)rightItemAction
{
    self.pageIndex = 1;
    [self requestBulkCouponWithPageIndex:self.pageIndex];
}

#pragma mark - 网络请求
-(void)requestBulkCouponWithPageIndex:(NSInteger)pageIndex
{
    NSDictionary* param = @{
        @"page" : [NSNumber numberWithInteger:pageIndex],
        @"page_size" : @"6"
    };
    
    __weak WanJuanViewController* wself = self;
    [self GetWithUrlStr:kFullUrl(kBulkcoupon) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        NSLog(@"%@",res);
        if(kSuccessRes){
            [wself handleBulkCouponWithPageIndex:pageIndex data:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {

    }];
}

-(void)handleBulkCouponWithPageIndex:(NSInteger)pageIndex data:(NSDictionary*)data
{
    NSString* bannerUrlStr = data[@"banner_img"];
    if(bannerUrlStr){
        __weak WanJuanViewController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.bgImageView sd_setImageWithURL:[NSURL URLWithString:bannerUrlStr] placeholderImage:[UIImage imageNamed:@"万券齐发_bg"]];
        });
    }
    
    NSArray* goods_list = data[@"goods_list"];
    NSMutableArray* mutArr = [NSMutableArray new];
    
    for(int i = 0; i < goods_list.count; i++){
        NSError* err = nil;

        CouponGood* couponGood = [[CouponGood alloc]initWithDictionary:goods_list[i] error:&err];
        if(couponGood){
            [mutArr addObject:couponGood];
        } else {

        }
    }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak WanJuanViewController* wself = self;
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
}

#pragma mark - UI

-(void)setupBottomTableView
{
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"WanJuanTableViewCell" bundle:nil] forCellReuseIdentifier:@"WanJuanTableViewCell"];
    [self addMJRefresh];
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.datasource.count; i++){//self.datasource.count/2 是整数
        NSMutableArray* item = [NSMutableArray new];
        if(i%2 == 0) {
            //基数个 左边model
            CouponGood* modelLeft = nil;
            if(self.datasource.count > i){
                modelLeft = self.datasource[i];
            }else{
                modelLeft = [CouponGood new];
            }
            
            CouponGood* modelRight = nil;
            if(self.datasource.count > (i+1)){
                modelRight = self.datasource[i+1];
            }else{
                modelRight = [CouponGood new];
            }
            
            [item addObject:modelLeft];
            [item addObject:modelRight];
            [mutArr addObject:item];
        }
    }
    return mutArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WanJuanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WanJuanTableViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.datasource.count; i++){//self.datasource.count/2 是整数
        NSMutableArray* item = [NSMutableArray new];
        if(i%2 == 0) {
            //基数个
            CouponGood* modelLeft = nil;
            if(self.datasource.count > i){
                modelLeft = self.datasource[i];
            }else{
                modelLeft = [CouponGood new];
            }
            
            CouponGood* modelRight = nil;
            if(self.datasource.count > (i+1)){
                modelRight = self.datasource[i+1];
            }else{
                modelRight = [CouponGood new];
            }
            
            [item addObject:modelLeft];
            [item addObject:modelRight];
            [mutArr addObject:item];
        }
    }
    
    NSArray* item = mutArr[indexPath.row];
    
    [cell fullDataWithLeftModel:item.firstObject rightModel:item.lastObject];
    
    cell.couponGoodClickedCallBack = ^(CouponGood * _Nonnull couponGood) {
        if(couponGood.item_id){
            GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:couponGood.item_id];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [[LLHudHelper sharedInstance]tipMessage:@"商品数据异常"];
        }
    };
    
    return cell;
}

#pragma mark -scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.scrollView){
        CGFloat constTop = self.constLabBgView.bottom;
        CGFloat scrollViewOffSetY = self.scrollView.contentOffset.y;
        
        if(scrollViewOffSetY >= constTop){
            self.scrollView.contentOffset = CGPointMake(0, 200);
            self.scrollView.scrollEnabled = NO;
            self.tableview.scrollEnabled = YES;
        }
        
        
        CGFloat oldWidth = kScreenWidth; // 图片原始宽度
        CGFloat oldHeight = kScreenWidth * 175 / 375 ; // 图片原始高度
        
        if (scrollViewOffSetY < 0) {
//           self.bgImageView.frame = CGRectMake(0, -scrollViewOffSetY, kScreenWidth , yOffset);
            CGFloat totalOffset = oldHeight + ABS(scrollViewOffSetY);
            CGFloat f = totalOffset / oldHeight; //背书
            self.bgImageView.frame = CGRectMake(- (oldWidth * f - oldWidth) / 2, scrollViewOffSetY, oldWidth * f, totalOffset);// 拉伸后的图片的frame应该是同比例缩放
        }
    }

    if(scrollView == self.tableview){
        CGFloat tableViewOffSetY = self.tableview.contentOffset.y;
        if(tableViewOffSetY <= 0){
            self.tableview.contentOffset = CGPointMake(0, 0);
            self.tableview.scrollEnabled = NO;
            self.scrollView.scrollEnabled = YES;
        }
    }
}

#pragma mark - helper

-(void)addMJRefresh
{
    __weak WanJuanViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        //获取评论数据
        wself.pageIndex=1;
        [wself requestBulkCouponWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        //获取评论数据
         wself.pageIndex++;
         [wself requestBulkCouponWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    [self.tableview.mj_header beginRefreshing];
}

@end
