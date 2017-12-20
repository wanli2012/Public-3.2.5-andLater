//
//  LBMyOrderCheckUnsubscribeRecordViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyOrderCheckUnsubscribeRecordViewController.h"
#import "LBMineCenterFlyNoticeDetailOneTableViewCell.h"
#import "LBMyOrderUnsubscribeRecordTableViewCell.h"

@interface LBMyOrderCheckUnsubscribeRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;


@end

@implementation LBMyOrderCheckUnsubscribeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"退款记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableview.tableFooterView = [UIView new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterFlyNoticeDetailOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterFlyNoticeDetailOneTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMyOrderUnsubscribeRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMyOrderUnsubscribeRecordTableViewCell"];
    
    self.tableview.estimatedRowHeight = 70;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < 3) {
        return 50;
    }else{
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < 3) {
        LBMyOrderUnsubscribeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMyOrderUnsubscribeRecordTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.titleLb.text = @"订单编号:";
            cell.contentLb.text = @"";
            
        }else if (indexPath.row == 1){
            cell.titleLb.text = @"退款原因:";
            cell.contentLb.text = @"";
        
        }else if (indexPath.row == 2){
            cell.titleLb.text = @"退款进度:";
            cell.contentLb.text = @"";
            
        }
        
        return cell;
    }else{
        LBMineCenterFlyNoticeDetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterFlyNoticeDetailOneTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 3 ) {
            
            cell.lineview.hidden = YES;
        }else if(indexPath.row == 4){
            
            cell.bottomV.hidden = YES;
        }else{
            cell.lineview.hidden = NO;
            cell.bottomV.hidden = NO;
        }
        
        return cell;
    }
    
}


@end
