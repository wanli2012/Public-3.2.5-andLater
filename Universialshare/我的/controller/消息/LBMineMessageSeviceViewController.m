//
//  LBMineMessageSeviceViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineMessageSeviceViewController.h"
#import "LBMineMesageServiceTableViewCell.h"

@interface LBMineMessageSeviceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation LBMineMessageSeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"客户服务";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableview.tableFooterView=[UIView new];
    self.automaticallyAdjustsScrollViewInsets = NO;

     [self.tableview registerNib:[UINib nibWithNibName:@"LBMineMesageServiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineMesageServiceTableViewCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMineMesageServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineMesageServiceTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
}

@end
