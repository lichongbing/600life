//
//  GoodStoreDetailViewController.m
//  600生活
//
//  Created by iOS on 2019/11/22.
//  Copyright © 2019 灿男科技. All rights reserved.
//
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "StoreDetailViewController.h"
#import "StoreDetailGoodCell.h"
#import "StroeDetailGoodModel.h"
#import "GoodDetailViewController.h"
#import "WebViewViewController.h"

@interface StoreDetailViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarTopCons;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *taobaoBtn;

@property (weak, nonatomic) IBOutlet UIImageView *storeIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;


@property(nonatomic,strong)NSString* brandId;
@property(nonatomic,strong)NSDictionary* brandData;//店铺数据

@end

@implementation StoreDetailViewController


-(id)initWithBrandId:(NSString*)brandId
{
    if(self = [super init]){
        self.brandId = brandId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.fd_prefersNavigationBarHidden = YES;
    
    self.navBarTopCons.constant = kStatusBarHeight;
    self.taobaoBtn.layer.borderWidth = 1;
    self.taobaoBtn.layer.borderColor = [UIColor colorWithHexString:@"#F54556"].CGColor;
    
    
    [self setupTableview];
    
    [self requestBrandDetail];
}


-(void)setupTableview
{
    self.headerView.width = kScreenWidth;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.tableHeaderView = self.headerView;
    
    self.tableview.top = kNavigationBarHeight ;
    self.tableview.height = kScreenHeight - self.tableview.top - kIPhoneXHomeIndicatorHeight;
    self.tableview.estimatedRowHeight = 278;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"StoreDetailGoodCell" bundle:nil] forCellReuseIdentifier:@"StoreDetailGoodCell"];
    [self addMJRefresh];
}

//获取商店信息
-(void)requestBrandDetail
{
    NSDictionary* param = @{
        @"id": self.brandId
    };
    [self GetWithUrlStr:kFullUrl(kBrandDetail) param:param showHud:YES resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [self handleBrandDetail: cacheData[@"data"]];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleBrandDetail: res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleBrandDetail:(NSDictionary*)data
{
    self.brandData = data;
    __weak StoreDetailViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        wself.nameLab.text = data[@"shop_title"];
        [wself.storeIcon sd_setImageWithURL:[NSURL URLWithString:data[@"shop_icon"]] placeholderImage:kPlaceHolderImg];
    });
}

//获取商店里的商品列表
-(void)requestBrandDetailGoods:(NSInteger)pageIndex
{
    NSDictionary* param = @{
        @"page": [NSNumber numberWithInteger:pageIndex],
        @"page_size":@"6",
        @"id":self.brandId
    };
    [self GetWithUrlStr:kFullUrl(kBrandDetailGoods) param:param showHud:YES resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [self handleBrandDetailGoods: cacheData[@"data"]];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleBrandDetailGoods: res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleBrandDetailGoods:(NSArray*)datas
{
   NSArray* goods_list = datas;
   NSMutableArray* mutArr = [NSMutableArray new];
   
      for(int i = 0; i < goods_list.count; i++){
          NSError* err = nil;
          StroeDetailGoodModel* stroeDetailGoodModel = [[StroeDetailGoodModel alloc]initWithDictionary:goods_list[i] error:&err];
          if(stroeDetailGoodModel){
              [mutArr addObject:stroeDetailGoodModel];
          } else {
              NSLog(@"福利购商品转换失败");
          }
      }
   [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    __weak StoreDetailViewController* wself = self;
    
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

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.datasource.count; i++){//self.datasource.count/2 是整数
        NSMutableArray* item = [NSMutableArray new];
        if(i%2 == 0) {
            //基数个 左边model
            StroeDetailGoodModel* modelLeft = nil;
            if(self.datasource.count > i){
                modelLeft = self.datasource[i];
            }else{
                modelLeft = [StroeDetailGoodModel new];
            }
            
            StroeDetailGoodModel* modelRight = nil;
            if(self.datasource.count > (i+1)){
                modelRight = self.datasource[i+1];
            }else{
                modelRight = [StroeDetailGoodModel new];
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
    StoreDetailGoodCell * cell = [tableView dequeueReusableCellWithIdentifier:@"StoreDetailGoodCell" forIndexPath:indexPath];
    
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < self.datasource.count; i++){//self.datasource.count/2 是整数
        NSMutableArray* item = [NSMutableArray new];
        if(i%2 == 0) {
            //基数个 左边model
            StroeDetailGoodModel* modelLeft = nil;
            if(self.datasource.count > i){
                modelLeft = self.datasource[i];
            }else{
                modelLeft = [StroeDetailGoodModel new];
            }
            
            StroeDetailGoodModel* modelRight = nil;
            if(self.datasource.count > (i+1)){
                modelRight = self.datasource[i+1];
            }else{
                modelRight = [StroeDetailGoodModel new];
            }
            
            [item addObject:modelLeft];
            [item addObject:modelRight];
            [mutArr addObject:item];
        }
    }
    
    NSArray* item = mutArr[indexPath.row];
    
    [cell fullDataWithLeftModel:item.firstObject rightModel:item.lastObject];
    
    __weak StoreDetailViewController* wself = self;
    cell.storeDetailGoodClickedCallback = ^(StroeDetailGoodModel * _Nonnull stroeDetailGoodModel) {
        if(stroeDetailGoodModel.item_id){
            GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:stroeDetailGoodModel.item_id];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}
#pragma mark - control action

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


//进入淘宝店铺
- (IBAction)enterTaoBaoBtnAction:(UIButton*)sender {
    if(self.brandData){
        NSString* shop_url_str = self.brandData[@"shop_url"];
        NSString* relationId = [LLUserManager shareManager].currentUser.relation_id;
        NSString* shop_url_full_str = [NSString stringWithFormat:@"%@&relationId=%@",shop_url_str,relationId];
//        NSURL* fullUrl = [NSURL URLWithString:shop_url_full_str];
        WebViewViewController* vc = [[WebViewViewController alloc]initWithUrl:shop_url_full_str title:@"店铺详情"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - helper
-(void)addMJRefresh
{
    __weak StoreDetailViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        wself.pageIndex=1;
        [wself requestBrandDetailGoods:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
         wself.pageIndex++;
         [wself requestBrandDetailGoods:wself.pageIndex];
        [wself impactLight];
    }];
    
    [self.tableview.mj_header beginRefreshing];
}
@end
