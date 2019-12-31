//
//  GoodStoreSubViewController.m
//  600生活
//
//  Created by iOS on 2019/11/21.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "GoodStoresSubViewController.h"
#import "GoodStoreItem3Cell.h"
#import "GoodStoreItem2Cell.h"
#import "GoodStoreItem1Cell.h"
#import "StoreDetailViewController.h"  //好店详情
#import "GoodStoreModel.h"    //好店模型
#import "GoodDetailViewController.h" //商品详情
#import "LoginAndRigistMainVc.h"


#define GoodStoreItem3CellHeight 272
#define GoodStoreItem2CellHeight 333
#define GoodStoreItem1CellHeight 210

@interface GoodStoresSubViewController ()

@property(nonatomic,strong)NSString* cid;

@end

@implementation GoodStoresSubViewController

-(id)initWithCid:(NSString*)cid
{
    if(self = [super init]){
        self.cid = cid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setupTableview];
    
    //第一个vc 的mj header 自动头部刷新后不会调用网络请求
    if([self.cid isEqualToString:@"0"]){
        [self loadDatasWhenUserDone];
    }
}

-(void)loadDatasWhenUserDone
{
    [self addMJRefresh];
}

#pragma mark - UI

-(void)setupTableview
{
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.height = kScreenHeight - kNavigationBarHeight - kIPhoneXHomeIndicatorHeight - 40 - 5;
    self.tableview.top = 5;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    [self.tableview registerNib:[UINib nibWithNibName:@"GoodStoreItem3Cell" bundle:nil] forCellReuseIdentifier:@"GoodStoreItem3Cell"];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"GoodStoreItem2Cell" bundle:nil] forCellReuseIdentifier:@"GoodStoreItem2Cell"];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"GoodStoreItem1Cell" bundle:nil] forCellReuseIdentifier:@"GoodStoreItem1Cell"];
}

#pragma mark - 网络请求

//获取品牌好店商品
-(void)requestkBrandGoodsWithPageIndex:(NSInteger)pageIndex
{
    NSDictionary* param = @{
        @"cid":self.cid,
        @"page":[NSNumber numberWithInteger:pageIndex],
        @"page_size":@"10"
    };
    [self GetWithUrlStr:kFullUrl(kBrandGoods) param:param showHud:NO resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleBrandGoods: res[@"data"] pageIndex:pageIndex];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleBrandGoods:(NSArray*)datas pageIndex:(NSInteger)pageIndex
{
    // GoodStoreModel
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < datas.count; i++){
        NSError* err = nil;
        GoodStoreModel* goodStoreModel = [[GoodStoreModel alloc]initWithDictionary:datas[i] error:&err];
        
        if(goodStoreModel){
            [mutArr addObject:goodStoreModel];
        }else{
            NSLog(@"品牌好店转换失败");
        }
    
        NSMutableArray* mutArr2 = [NSMutableArray new];
     
        for(int j = 0; j < goodStoreModel.goods_list.count;j++){
            err = nil;
            GoodStoreGoodModel* goodStoreGoodModel = [[GoodStoreGoodModel alloc]initWithDictionary:goodStoreModel.goods_list[j] error:&err];
            if(goodStoreModel){
                [mutArr2 addObject:goodStoreGoodModel];
            }
        }
        if(mutArr2.count > 0){
            goodStoreModel.goods_list = mutArr2;
        }
    }
    [self configDataSource:mutArr];
}

-(void)configDataSource:(NSArray*)tempArray
{
    
    __weak GoodStoresSubViewController* wself = self;
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
               [wself.tableview.mj_footer endRefreshingWithNoMoreData];
           });
       }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
           if(wself.datasource.count == 0){
               [Utility showTipViewOn:wself.tableview type:0 iconName:@"tipview未查到订单" msg:@"暂无店铺数据"];
           }else{
               [Utility dismissTipViewOn:wself.tableview];
           }
       });
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodStoreModel* goodStoreModel = [self.datasource objectAtIndex:indexPath.row];
    if(goodStoreModel.goods_list.count == 3){
        return GoodStoreItem3CellHeight;
    } else if(goodStoreModel.goods_list.count == 2){
        return GoodStoreItem2CellHeight;
    }else if(goodStoreModel.goods_list.count == 1){
        return GoodStoreItem1CellHeight;
    } else if(goodStoreModel.goods_list.count == 0){
        return GoodStoreItem1CellHeight;
    }
    return 0;
}

#pragma mark - 此处有回调
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GoodStoreModel* goodStoreModel = [self.datasource objectAtIndex:indexPath.row];
    
    if(goodStoreModel.goods_list.count == 3){
        GoodStoreItem3Cell * cell = [tableView dequeueReusableCellWithIdentifier:@"GoodStoreItem3Cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell fullData:self.datasource[indexPath.row]];
        __weak GoodStoresSubViewController* wself = self;
        cell.goodStoreGoodClickedCallBack = ^(GoodStoreGoodModel * _Nonnull goodStoreGoodModel) {
            if(goodStoreGoodModel.item_id){
                
                if([LLUserManager shareManager].currentUser == nil){
                    __strong GoodStoresSubViewController* sself = wself;
                    [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
                        LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
                        vc.hidesBottomBarWhenPushed = YES;
                        [sself.navigationController pushViewController:vc animated:YES];
                    } cancleAction:nil];
                    return;
                }
                
                GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:goodStoreGoodModel.item_id];
                vc.hidesBottomBarWhenPushed = YES;
                [wself.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
    }
    
    if(goodStoreModel.goods_list.count == 2){
        GoodStoreItem2Cell * cell = [tableView dequeueReusableCellWithIdentifier:@"GoodStoreItem2Cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell fullData:self.datasource[indexPath.row]];
        __weak GoodStoresSubViewController* wself = self;
        cell.goodStoreGoodClickedCallBack = ^(GoodStoreGoodModel * _Nonnull goodStoreGoodModel) {
            if(goodStoreGoodModel.item_id){
                
                if([LLUserManager shareManager].currentUser == nil){
                    __strong GoodStoresSubViewController* sself = wself;
                    [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
                        LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
                        vc.hidesBottomBarWhenPushed = YES;
                        [sself.navigationController pushViewController:vc animated:YES];
                    } cancleAction:nil];
                    return;
                }
                
                GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:goodStoreGoodModel.item_id];
                vc.hidesBottomBarWhenPushed = YES;
                [wself.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
    }
    
    if(goodStoreModel.goods_list.count == 1){
        GoodStoreItem1Cell * cell = [tableView dequeueReusableCellWithIdentifier:@"GoodStoreItem1Cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell fullData:self.datasource[indexPath.row]];
        __weak GoodStoresSubViewController* wself = self;
        cell.goodStoreGoodClickedCallBack = ^(GoodStoreGoodModel * _Nonnull goodStoreGoodModel) {
            if(goodStoreGoodModel.item_id){
                
                if([LLUserManager shareManager].currentUser == nil){
                    __strong GoodStoresSubViewController* sself = wself;
                    [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
                        LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
                        vc.hidesBottomBarWhenPushed = YES;
                        [sself.navigationController pushViewController:vc animated:YES];
                    } cancleAction:nil];
                    return;
                }
                
                GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:goodStoreGoodModel.item_id];
                vc.hidesBottomBarWhenPushed = YES;
                [wself.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
    }
    
    if(goodStoreModel.goods_list.count == 0){
        GoodStoreItem1Cell * cell = [tableView dequeueReusableCellWithIdentifier:@"GoodStoreItem1Cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell fullData:self.datasource[indexPath.row]];
        __weak GoodStoresSubViewController* wself = self;
        cell.goodStoreGoodClickedCallBack = ^(GoodStoreGoodModel * _Nonnull goodStoreGoodModel) {
            if(goodStoreGoodModel.item_id){
                
                if([LLUserManager shareManager].currentUser == nil){
                    __strong GoodStoresSubViewController* sself = wself;
                    [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
                        LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
                        vc.hidesBottomBarWhenPushed = YES;
                        [sself.navigationController pushViewController:vc animated:YES];
                    } cancleAction:nil];
                    return;
                }
                
                GoodDetailViewController* vc = [[GoodDetailViewController alloc]initWithItem_id:goodStoreGoodModel.item_id];
                vc.hidesBottomBarWhenPushed = YES;
                [wself.navigationController pushViewController:vc animated:YES];
            }
        };
        return cell;
    }
    
    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([LLUserManager shareManager].currentUser == nil){
        __weak GoodStoresSubViewController* wself = self;
        [Utility ShowAlert:@"尚未登录" message:@"\n是否登录" buttonName:@[@"好的,去登录",@"不用了,谢谢"] sureAction:^{
            LoginAndRigistMainVc* vc = [LoginAndRigistMainVc new];
            vc.hidesBottomBarWhenPushed = YES;
            [wself.navigationController pushViewController:vc animated:YES];
        } cancleAction:nil];
        return;
    }
    
    GoodStoreModel* goodStoreModel = [self.datasource objectAtIndex:indexPath.row];
    if(goodStoreModel.seller_id){
        StoreDetailViewController* vc = [[StoreDetailViewController alloc]initWithBrandId:goodStoreModel.seller_id];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [[LLHudHelper sharedInstance]tipMessage:@"商家信息异常"];
    }
    
}





#pragma mark - helper

-(void)addMJRefresh
{
    __weak GoodStoresSubViewController* wself = self;
    self.tableview.mj_header = [LLRefreshGifHeader headerWithRefreshingBlock:^{
        wself.isMJHeaderRefresh = YES; //重要代码
        //获取评论数据
        wself.pageIndex=1;
        [wself requestkBrandGoodsWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    
    self.tableview.mj_footer = [LLRefreshAutoGifFooter footerWithRefreshingBlock:^{
         wself.isMJFooterRefresh = YES;
        //获取评论数据
         wself.pageIndex++;
        [wself requestkBrandGoodsWithPageIndex:wself.pageIndex];
        [wself impactLight];
    }];
    [self.tableview.mj_header beginRefreshing];
}
@end
