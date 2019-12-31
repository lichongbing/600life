//
//  CategoryMainController.m
//  600生活
//
//  Created by iOS on 2019/11/8.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "CategoryMainController.h"
#import "HomePageMenuModel.h" //分类就是菜单
#import "SPButton.h"

#import "GoodItemCollectionViewCell.h"//collectionViewCell
#import "SearchResultListController.h"  //搜索结果 不用这个了

#import "CategoryGoodListViewController.h"  //分类商品商品列表

#define kControlSpaceTop  10 + 12  //上边
#define kControlSpaceLeft 12     //左边
#define kControlSpaceV 20       // 竖直 距离
#define kControlSpaceH 20       // 水平 距离
#define kColumns      3         //列数（行数根据列数计算而来）

@interface CategoryMainController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *leftTableview;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,assign) NSInteger currentTableViewCellIndex; //当前被点击的table cell的 index

@end

@implementation CategoryMainController

-(id)init
{
    if(self = [super init]){
        self.currentTableViewCellIndex = -1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    
    self.leftTableview.height = kScreenHeight - kNavigationBarHeight - kTabbarHeight;
    self.leftTableview.width = kScreenWidth * 80 / 320;
    self.leftTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leftTableview.delegate = (id)self;
    self.leftTableview.dataSource = (id)self;
    self.leftTableview.backgroundColor = kAppBackGroundColor;
    
    CGFloat collectionViewleft = kScreenWidth * 80 / 320;
    CGFloat collectionViewleftWidth = kScreenWidth * 240 / 320;
    
    self.collectionView.frame = CGRectMake(collectionViewleft, 0, collectionViewleftWidth, self.leftTableview.height);
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.itemSize = CGSizeMake(80, 90);
    layout.minimumInteritemSpacing = 0; //列间距
    layout.minimumLineSpacing = 0;  //行间距
    
    [self.collectionView setCollectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GoodItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"GoodItemCollectionViewCell"];
    self.collectionView.delegate = (id)self;
    self.collectionView.dataSource = (id)self;
    
    //请求scrollView的数据
    [self requestHomePageMenuDatas];
}

#pragma mark - 网络请求

//获取分类对应的菜单数据 有缓存
-(void)requestHomePageMenuDatas
{
    [self GetWithUrlStr:kFullUrl(kHomePageMenu) param:nil showHud:YES resCache:^(id  _Nullable cacheData) {
        if(kSuccessCache){
            [self handleHomePageMenuDatas: cacheData[@"data"]];
        }
    } success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleHomePageMenuDatas: res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
        
    }];
}

-(void)handleHomePageMenuDatas:(NSArray*)dataList
{
    NSMutableArray* mutArr = [NSMutableArray new];
    for(int i = 0; i < dataList.count; i++){
        NSError* err = nil;
        HomePageMenuModel* homePageMenuModel = [[HomePageMenuModel alloc]initWithDictionary:dataList[i] error:&err];
        
        if(homePageMenuModel.id.intValue <= 0){
            continue;//如果id小于0 说明是精选或者猜你喜欢
        }
        
        //创建homePageMenuModel的child数组
        NSDictionary* data = dataList[i];
        NSArray* child = data[@"child"];
        NSMutableArray* mutChild = [NSMutableArray new];
        for(int j = 0; j < child.count; j++){
            err = nil;
            HomePageMenuCategoryChild* homePageMenuCategoryChild = [[HomePageMenuCategoryChild alloc]initWithDictionary:child[j] error:&err];
            if(homePageMenuCategoryChild){
                [mutChild addObject:homePageMenuCategoryChild];
            }
        }
        
        if(mutChild.count > 0){
            homePageMenuModel.child = mutChild;
        }
        
        if( homePageMenuModel ){
            [mutArr addObject:homePageMenuModel];
        } else {
            NSLog(@"转换菜单模型失败");
        }
    }
    
    if(mutArr.count > 0){
        self.datasource = [[NSMutableArray alloc]initWithArray:mutArr];
    }else{
        [[LLHudHelper sharedInstance]tipMessage:@"获取数据失败"];
        return;
    }
    
    if(self.datasource.count > 0){
        __weak CategoryMainController* wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.leftTableview reloadData];
            
            //点击第一个cell
            [wself clearAllTableViewCell];
            UITableViewCell* cell = [self.leftTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.backgroundColor = [UIColor whiteColor];
            UILabel* lab = [cell viewWithTag:1];
            lab.textColor = [UIColor colorWithHexString:@"#F54556"];
            wself.currentTableViewCellIndex = 0;
        });
    }
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [UITableViewCell new];
    cell.backgroundColor = RGB(246, 246, 246);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    UILabel* lab = [UILabel new];
    [cell addSubview:lab];
    lab.frame = CGRectMake(0, 0, kScreenWidth * 94 / 375, 44);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor colorWithHexString:@"#333333"];
    lab.text = ((HomePageMenuModel*)(self.datasource[indexPath.row])).name;
    lab.font = [UIFont systemFontOfSize:15];
    lab.tag = 1;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self clearAllTableViewCell];
    UITableViewCell* cell = [self.leftTableview cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel* lab = [cell viewWithTag:1];
    lab.textColor = [UIColor colorWithHexString:@"#F54556"];
    
    self.currentTableViewCellIndex = indexPath.row;
}

#pragma mark - collection View delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.currentTableViewCellIndex >= 0){
         
        HomePageMenuModel* homePageMenuModel= [self.datasource objectAtIndex:self.currentTableViewCellIndex];
        if(homePageMenuModel){
            return homePageMenuModel.child.count;
        }
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodItemCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodItemCollectionViewCell" forIndexPath:indexPath];
    
    if(self.currentTableViewCellIndex >= 0){
        HomePageMenuModel* homePageMenuModel= [self.datasource objectAtIndex:self.currentTableViewCellIndex];
        if(indexPath.row < homePageMenuModel.child.count){
            HomePageMenuCategoryChild* homePageMenuCategoryChild = [homePageMenuModel.child objectAtIndex:indexPath.row];
            [cell fullImageUrlStr:homePageMenuCategoryChild.icon titleName:homePageMenuCategoryChild.name];
        }
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    HomePageMenuModel* homePageMenuModel= [self.datasource objectAtIndex:self.currentTableViewCellIndex];
    if(indexPath.row < homePageMenuModel.child.count){
        HomePageMenuCategoryChild* homePageMenuCategoryChild = [homePageMenuModel.child objectAtIndex:indexPath.row];
        NSString* keywords = homePageMenuCategoryChild.cid;
        
        if(keywords.length > 0){
            
            CategoryGoodListViewController* vc = [[CategoryGoodListViewController alloc]initWithCategoryId:homePageMenuModel.cid.toString CategoryName:keywords];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [[LLHudHelper sharedInstance]tipMessage:@"分类数据异常"];
        }
    }
}


#pragma mark - setter  helper

-(void)setCurrentTableViewCellIndex:(NSInteger)currentTableViewCellIndex
{
    _currentTableViewCellIndex = currentTableViewCellIndex;
    [self.collectionView reloadData];
}

-(void)clearAllTableViewCell
{
    for(int i = 0; i < self.datasource.count; i++){
        UITableViewCell* cell = [self.leftTableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.backgroundColor = RGB(246, 246, 246);
        UILabel* lab = [cell viewWithTag:1];
        lab.textColor = [UIColor colorWithHexString:@"#333333"];
    }
}

@end
