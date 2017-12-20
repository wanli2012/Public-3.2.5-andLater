//
//  LBMineCenterOrderDetailViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterOrderDetailViewController.h"
#import "LBMineCenterOrderDetailOneTableViewCell.h"
#import "LBMineCenterOrderDetailTwoTableViewCell.h"
#import "LBMineCenterOrderDetailThreeTableViewCell.h"
#import "LBMineCenterOrderDetailFiveTableViewCell.h"
#import "LBMineCenterOrderDetailSixTableViewCell.h"
#import "LBMineCenterOrderDetailSevenTableViewCell.h"
#import "LBMineCenterOrderDetailFourTableViewCell.h"

@interface LBMineCenterOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *cancelBt;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation LBMineCenterOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"订单详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterOrderDetailOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterOrderDetailOneTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterOrderDetailTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterOrderDetailTwoTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterOrderDetailThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterOrderDetailThreeTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterOrderDetailFiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterOrderDetailFiveTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterOrderDetailSixTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterOrderDetailSixTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterOrderDetailSevenTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterOrderDetailSevenTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterOrderDetailFourTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterOrderDetailFourTableViewCell"];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 60;
    }else if (indexPath.row == 1){
        return 70;
    }else if (indexPath.row == 2){
        return 80;
    }else if (indexPath.row == 3){
        return 180;
    }else if (indexPath.row == 4){
        return 44;
    }else if (indexPath.row == 5){
        return 44;
    }else if (indexPath.row == 6){
        return 70;
    }else if (indexPath.row == 7){
        return 70;
    }
    return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        LBMineCenterOrderDetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterOrderDetailOneTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexPath.row == 1){
        LBMineCenterOrderDetailTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterOrderDetailTwoTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.row == 2){
        LBMineCenterOrderDetailThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterOrderDetailThreeTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.row == 3){
        LBMineCenterOrderDetailFourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterOrderDetailFourTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.row == 4){
        LBMineCenterOrderDetailFiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterOrderDetailFiveTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.row == 5){
        LBMineCenterOrderDetailFiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterOrderDetailFiveTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.row == 6){
        LBMineCenterOrderDetailSixTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterOrderDetailSixTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.row == 7){
        LBMineCenterOrderDetailSevenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterOrderDetailSevenTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return [[UITableViewCell alloc]init];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

//取消订单
- (IBAction)cancelorder:(UIButton *)sender {
    
    
}


-(void)updateViewConstraints{

    [super updateViewConstraints];
    
    self.cancelBt.layer.cornerRadius = 3;
    self.cancelBt.clipsToBounds = YES;
    
    self.cancelBt.layer.borderColor = YYSRGBColor(198, 51, 14, 1).CGColor;
    self.cancelBt.layer.borderWidth = 1;

}

@end
