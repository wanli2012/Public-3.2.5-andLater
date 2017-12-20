//
//  LBMineCenterserviceNoticeViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/29.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterserviceNoticeViewController.h"
#import "LBMineCenterseverceNoticeTableViewCell.h"
#import "LBMinecenterSeverceNoticeHeaderView.h"

@interface LBMineCenterserviceNoticeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation LBMineCenterserviceNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"服务通知";
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.tableview.tableFooterView = [UIView new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterseverceNoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterseverceNoticeTableViewCell"];
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
    
    
    LBMineCenterseverceNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterseverceNoticeTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
   
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    static NSString *viewIdentfier = @"headView";
    
    LBMinecenterSeverceNoticeHeaderView *sectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
    
    if(!sectionHeadView){
        
        sectionHeadView = [[LBMinecenterSeverceNoticeHeaderView alloc] initWithReuseIdentifier:viewIdentfier];
    }
    
    
    return sectionHeadView;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

@end
