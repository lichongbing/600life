//
//  CheckResultViewController.m
//  600生活
//
//  Created by iOS on 2019/11/19.
//  Copyright © 2019 灿男科技. All rights reserved.
//

#import "CheckResultViewController.h"
#import "LLBaseView.h"
#import "MyOrderTableViewCell.h"
#import "MyOrderModel.h" //将FindOrderModel转化成MyOrderModel;

@interface CheckResultViewController ()

@property (strong, nonatomic) IBOutlet UIView *noOrderView; //无订单

@property (strong, nonatomic) IBOutlet UIView *orderView;
@property (weak, nonatomic) IBOutlet LLBaseView *onOrderLayoutBottomLine;

@property(nonatomic,strong)FindOrderModel* findOrderModel;

@end

@implementation CheckResultViewController


-(id)initWithFindOrderModel:(FindOrderModel*)findOrderModel
{
    if(self = [super init]){
        self.findOrderModel = findOrderModel;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单查询";
    
    self.noOrderView.width = kScreenWidth;
    self.noOrderView.hidden = self.findOrderModel != nil;
    [self.view addSubview:self.noOrderView];
    
    self.orderView.width = kScreenWidth;
    MyOrderTableViewCell* cell = [[NSBundle mainBundle]loadNibNamed:@"MyOrderTableViewCell" owner:nil options:nil].firstObject;
    cell.frame = CGRectMake(0, 0, kScreenWidth, 145);
    [self.orderView addSubview:cell];
    self.orderView.hidden = !self.noOrderView.hidden;
    [self.view addSubview:self.orderView];
    
    
    
    if(self.findOrderModel) {
        
        MyOrderModel* myOrderModel = [MyOrderModel new];
        myOrderModel.item_img = _findOrderModel.item_img;
        myOrderModel.seller_shop_title = _findOrderModel.seller_shop_title;
        myOrderModel.pay_price = _findOrderModel.pay_price;
        myOrderModel.trade_id = _findOrderModel.trade_id;
        myOrderModel.tk_create_time = _findOrderModel.tk_create_time;
        myOrderModel.item_title = _findOrderModel.item_title;
        myOrderModel.uid_earnings = _findOrderModel.earnigns.toString;
        myOrderModel.tk_status = _findOrderModel.tk_status;
        [cell fullData:myOrderModel];
        [cell resetIncomeLabWithStatus:_findOrderModel.status];
    }
}


//重新查询
- (IBAction)recheckBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
