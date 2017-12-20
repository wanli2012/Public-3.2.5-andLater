//
//  LBMineMessageViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineMessageViewController.h"
#import "LBMineCenterMessageTableViewCell.h"
#import "LBMineMessageSeviceViewController.h"
#import "LBMineMessageHotPickViewController.h"
#import "LBMineCenterserviceNoticeViewController.h"
#import "LBMineCenterFlyNoticeViewController.h"
#import "LBMineMessageSetupViewController.h"
#import "LBMineSystemMessageViewController.h"

@interface LBMineMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSArray *titleArr;
@property (strong, nonatomic)NSArray *imagearr;
@property (strong, nonatomic)NSMutableArray *detailArr;

@end

@implementation LBMineMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"消息中心";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imagearr = @[@"客户服务",@"热卖精选",@"服务通知",@"物流通知",@"矢量智能对象2"];
    self.detailArr = [NSMutableArray arrayWithObjects:@"单击查看更多详情信息",@"单击查看更多详情信息",@"单击查看更多详情信息",@"单击查看更多详情信息",@"单击查看更多详情信息", nil];
    
    self.tableview.tableFooterView = [UIView new];
    
     [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterMessageTableViewCell"];
    
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"LB设置"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(5, 13, 5, -5)];
    button.backgroundColor=[UIColor clearColor];
    [button addTarget:self action:@selector(infomationSetUp) forControlEvents:UIControlEventTouchUpInside];
    
    //UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    //self.navigationItem.rightBarButtonItem = ba;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 0;
    }else if (indexPath.row == 1){
        return 0;
        
    }else if (indexPath.row == 2){
        return 0;
        
    }else if (indexPath.row == 3){
        return 0;
        
    }else{
        return 60;
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LBMineCenterMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterMessageTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.namelb.text=[NSString stringWithFormat:@"%@",self.titleArr[indexPath.row]];
    
    if (indexPath.row == 0) {
        cell.timelb.hidden = YES;
        cell.hidden = YES;
    }else if (indexPath.row == 1){
        cell.timelb.hidden = YES;
        cell.hidden = YES;
    }else if (indexPath.row == 2){
        cell.timelb.hidden = YES;
        cell.hidden = YES;
        
    }else if (indexPath.row == 3){
        cell.timelb.hidden = YES;
        cell.hidden = YES;
        
    }else if (indexPath.row == 4){
        cell.timelb.hidden = YES;
        cell.hidden = NO;
        
    }
    
    cell.detaillb.text = [NSString stringWithFormat:@"%@",self.detailArr[indexPath.row]];
    cell.image.image =[UIImage imageNamed:self.imagearr[indexPath.row]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        self.hidesBottomBarWhenPushed = YES;
        LBMineMessageSeviceViewController *vc=[[LBMineMessageSeviceViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1){
        self.hidesBottomBarWhenPushed = YES;
        LBMineMessageHotPickViewController *vc=[[LBMineMessageHotPickViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 2){
        self.hidesBottomBarWhenPushed = YES;
        LBMineCenterserviceNoticeViewController *vc=[[LBMineCenterserviceNoticeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 3){
        
        self.hidesBottomBarWhenPushed = YES;
        LBMineCenterFlyNoticeViewController *vc=[[LBMineCenterFlyNoticeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

        
    }else if (indexPath.row == 4){
        
        self.hidesBottomBarWhenPushed = YES;
        LBMineSystemMessageViewController *vc=[[LBMineSystemMessageViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }


}

-(void)infomationSetUp{

    self.hidesBottomBarWhenPushed = YES;
    LBMineMessageSetupViewController *vc=[[LBMineMessageSetupViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];


}


-(NSArray*)titleArr{

    if (!_titleArr) {
        _titleArr=[NSArray arrayWithObjects:@"客户服务",@"热卖精选",@"服务通知",@"物流通知",@"系统消息", nil];
    }
    
    return _titleArr;

}

@end
