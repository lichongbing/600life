//
//  SearchHistoryViewController.m
//  600生活
//
//  Created by iOS on 2019/11/11.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "SearchHistoryViewController.h"
#import "PYSearchViewController.h" //三方搜索
#import "SearchResultListController.h" //搜索结果页


@interface SearchHistoryViewController ()<PYSearchViewControllerDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)PYSearchViewController* pyVC;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarTrailingCons;

//@property (weak, nonatomic) IBOutlet UIButton *searchRightBtn; //搜索右边按钮

//高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarTopConstraint;

//输入联想
@property(nonatomic,strong)UITableView* associateTableView;

@end

@implementation SearchHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _navBarHeightConstraint.constant = kNavigationBarHeight;
    _navBarTopConstraint.constant = -kStatusBarHeight;
    
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    NSArray *hotSeaches = @[@"家居", @"潮流", @"彩妆",@"饮料",@"酒水",@"食品", @"女装", @"母婴",@"儿童玩具", @"护理", @"手机",@"户外", @"配饰",@"数码家电"];
    
    self.pyVC = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"请输入优惠券" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
       
    }];
    
    CGFloat searchTitleViewHeight = 103+ kNavigationBarHeight;
    CGFloat pvViewHeight = kScreenHeight - searchTitleViewHeight;
   
    self.pyVC.delegate = (id)self;
    self.pyVC.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    [self.pyVC setSearchBar:_searchBar];
    UITextField *searchTextField = nil;
    if(kIsIOS13()){
        searchTextField = _searchBar.searchTextField;
    } else {
        searchTextField = [_searchBar valueForKey:@"_searchField"];
    }
    searchTextField.font = [UIFont systemFontOfSize:15];
    _searchBar.delegate = (id)self;
    self.pyVC.view.frame = CGRectMake(0, searchTitleViewHeight + 5, kScreenWidth, pvViewHeight);
    [self addChildViewController:self.pyVC];
    [self.view addSubview:self.pyVC.view];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self hiddenNavigationBarWithAnimation:animated];
    self.fd_prefersNavigationBarHidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNavigationBarWithAnimation:animated];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

}

-(UIStatusBarStyle)preferredStatusBarStyle {
    if(kIsIOS13()){
        return UIStatusBarStyleDarkContent;
    }else{
        return UIStatusBarStyleDefault;//黑色文字
    }
}

#pragma mark pySearch delegate

/**
 Called when search begain.
 
 @param searchViewController    search view controller
 @param searchBar               search bar
 @param searchText              text for search
 */
- (void)searchViewController:(PYSearchViewController *)searchViewController
      didSearchWithSearchBar:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText
{
    //搜索已经存在的字段(包括热门和历史)
    if(![searchBar.text isEqualToString:searchText]){
        searchBar.text = searchText;
    }
    
    if(searchBar.text.length > 0){
        [self gotoSearchVCWithKeywords:searchBar.text];
    }
}

#pragma mark - searchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchBar.text.length > 0){
        [self requestAssociateInfoWithKeyword:searchBar.text];
    }else{
        [self.associateTableView removeFromSuperview];
        self.associateTableView = nil;
    }
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_pyVC saveSearchCacheAndRefreshView];
    [self gotoSearchVCWithKeywords:searchBar.text];
}

//取消或搜索按钮被点击
- (IBAction)serachRightBtnAction:(UIButton*)sender {
    if([sender.titleLabel.text isEqualToString:@"取消"]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self gotoSearchVCWithKeywords:_searchBar.text];
    }
}

//return 被点击
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//左边返回按钮被点击
- (IBAction)leftBackBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 网络请求
-(void)requestAssociateInfoWithKeyword:(NSString*)keyword
{
    NSDictionary* param = @{
        @"keyword":keyword
    };
    [self GetWithUrlStr:kFullUrl(kSearchAssociate) param:param showHud:YES resCache:nil success:^(id  _Nullable res) {
        if(kSuccessRes){
            [self handleAssociateInfoWithKeyword:keyword datas:res[@"data"]];
        }
    } falsed:^(NSError * _Nullable error) {
    }];
}

-(void)handleAssociateInfoWithKeyword:(NSString*)keyword datas:(NSArray*)datas
{
    self.datasource = [[NSMutableArray alloc]initWithArray:datas];
    __weak SearchHistoryViewController* wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wself.associateTableView reloadData];
    });
}


#pragma mark - helper


////搜索
//-(void)showRightBtnSearch
//{
//    [_searchRightBtn setTitle:@"搜索" forState:UIControlStateNormal];
//    [_searchRightBtn setTitleColor:RGB(47, 124,276) forState:UIControlStateNormal];
//}

////取消
//-(void)showRightBtnCancel
//{
//    [_searchRightBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [_searchRightBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
//}

//跳转到搜索主界面
-(void)gotoSearchVCWithKeywords:(NSString*)keywords
{
    SearchResultListController* vc = [[SearchResultListController alloc]initWithKeyWords:keywords];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


-(UITableView*)associateTableView
{
    if(_associateTableView == nil){
        _associateTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight) style:UITableViewStylePlain];
        [self.view addSubview:_associateTableView];
        [self.view bringSubviewToFront:_associateTableView];
        _associateTableView.delegate = (id)self;
        _associateTableView.dataSource = (id)self;
        _associateTableView.tableFooterView = [UIView new];
    }
    return _associateTableView;
}


#pragma mark - tableview delegat
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [UITableViewCell new];
    cell.textLabel.text = self.datasource[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.associateTableView removeFromSuperview];
    self.associateTableView = nil;
    
    [_pyVC saveSearchCacheAndRefreshView];
    
    SearchResultListController* vc = [[SearchResultListController alloc]initWithKeyWords:self.datasource[indexPath.row]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
