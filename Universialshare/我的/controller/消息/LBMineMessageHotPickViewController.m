//
//  LBMineMessageHotPickViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineMessageHotPickViewController.h"
#import "LBMineMessageHotPickTableViewCell.h"
#import "LBMineCenterHotPickModelF.h"
#import "LBMineCenterHotPickModel.h"
#import "LBMinecenterSeverceNoticeHeaderView.h"
#import "LBMineMessageHotPickOneTableViewCell.h"

@interface LBMineMessageHotPickViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation LBMineMessageHotPickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"热卖精选";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableview.tableFooterView = [UIView new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineMessageHotPickTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineMessageHotPickTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineMessageHotPickOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineMessageHotPickOneTableViewCell"];

    
    NSArray *arr=[LBMineCenterHotPickModel getIndustryModels:@[@{@"count":@1},@{@"count":@2},@{@"count":@1}]];
    NSArray *arrf=[LBMineCenterHotPickModelF getIndustryModels:arr];
    [self.dataArr addObjectsFromArray:arrf];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataArr.count;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
         return 2;
    }else{
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    LBMineCenterHotPickModelF *modelf = self.dataArr[indexPath.row];
//    
//    return modelf.cellH;
    
    if (indexPath.row == 0) {
        
        return 160;
        
    }else{
        return 80;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.row == 0) {
        LBMineMessageHotPickTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineMessageHotPickTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //cell.MineCenterHotPickModelF = self.dataArr[indexPath.row];
        
        return cell;
       
        
    }else{
        LBMineMessageHotPickOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineMessageHotPickOneTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //cell.MineCenterHotPickModelF = self.dataArr[indexPath.row];
        
        return cell;
    }
   
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *viewIdentfier = @"LBMinecenterSeverceNoticeHeaderView";
    
    LBMinecenterSeverceNoticeHeaderView *sectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
    
    if(!sectionHeadView){
        
        sectionHeadView = [[LBMinecenterSeverceNoticeHeaderView alloc] initWithReuseIdentifier:viewIdentfier];
    }
    
    
    return sectionHeadView;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

-(NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr=[[NSMutableArray alloc]init];
    }
    return _dataArr;
}
@end
