//
//  LBMineCenterFlyNoticeViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterFlyNoticeViewController.h"
#import "LBMineCenterFlyNoticeTableViewCell.h"
#import "LBMinecenterSeverceNoticeHeaderView.h"
#import "LBMineCenterFlyNoticeDetailViewController.h"

@interface LBMineCenterFlyNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation LBMineCenterFlyNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"物流通知";
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.tableview.tableFooterView = [UIView new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterFlyNoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterFlyNoticeTableViewCell"];
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMineCenterFlyNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterFlyNoticeTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *viewIdentfier = @"LBMineCenterFlyNoticeTableViewCell";
    
    LBMinecenterSeverceNoticeHeaderView *sectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
    
    if(!sectionHeadView){
        
        sectionHeadView = [[LBMinecenterSeverceNoticeHeaderView alloc] initWithReuseIdentifier:viewIdentfier];
    }
    
    
    return sectionHeadView;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterFlyNoticeDetailViewController *vc=[[LBMineCenterFlyNoticeDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


@end
