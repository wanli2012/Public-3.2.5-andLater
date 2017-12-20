//
//  LBMyOrderPendingRefundViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyOrderPendingRefundViewController.h"
#import "LBMyOrderListTableViewCell.h"
#import "LBMyOrderCheckUnsubscribeRecordViewController.h"

@interface LBMyOrderPendingRefundViewController ()<UITableViewDataSource,UITableViewDelegate,LBMyOrderListTableViewdelegete>
@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end

@implementation LBMyOrderPendingRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMyOrderListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMyOrderListTableViewCell"];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMyOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMyOrderListTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.payBt setTitle:@"取消退款" forState:UIControlStateNormal];
    cell.stauesLb.text = @"查看退款进度";
    cell.delegete = self;
    cell.index = indexPath.row;
    cell.deleteBt.hidden = YES;
    __weak typeof(self)  weakself = self;
    
    cell.retunpaybutton = ^(NSInteger index){
        
        
        
    };
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
//查看进度
-(void)clickTapgesture{
    LBMyOrderCheckUnsubscribeRecordViewController *vc=[[LBMyOrderCheckUnsubscribeRecordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];


}

@end
