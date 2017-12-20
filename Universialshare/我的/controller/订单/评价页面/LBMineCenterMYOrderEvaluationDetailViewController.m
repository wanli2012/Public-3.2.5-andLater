//
//  LBMineCenterMYOrderEvaluationDetailViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/7.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterMYOrderEvaluationDetailViewController.h"
#import "LBMineCenterMYOrderEvaluationDetailTableViewCell.h"
#import "orderEvaluationModel.h"
#import "LBMyOrderlistHeaderFooterView.h"
#import "LBMineCenterMYOrderEvaluationDetailOneTableViewCell.h"
#import "LBMineCenterMYOrderEvaluationDetailTwoTableViewCell.h"


@interface LBMineCenterMYOrderEvaluationDetailViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,LBMineCenterMYOrderEvaluationDetailDelegete>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)NSMutableArray *dataArr;
@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation LBMineCenterMYOrderEvaluationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"评价";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.tableview.tableFooterView = [UIView new];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterMYOrderEvaluationDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterMYOrderEvaluationDetailTableViewCell"];
     [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterMYOrderEvaluationDetailOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterMYOrderEvaluationDetailOneTableViewCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterMYOrderEvaluationDetailTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterMYOrderEvaluationDetailTwoTableViewCell"];
    
    [self initdatasorce];
}

-(void)initdatasorce{

    for (int i=0; i<self.arr.count; i++) {
        orderEvaluationModel *model = [[orderEvaluationModel alloc]init];
        model.isexpand = YES;
        model.imageurl = [NSString stringWithFormat:@"%@",self.arr[i][@"thumb"]];
        model.namelb = [NSString stringWithFormat:@"%@",self.arr[i][@"goods_name"]];
        model.order_goods_id = [NSString stringWithFormat:@"%@",self.arr[i][@"id"]];
        model.moneylb = [NSString stringWithFormat:@"%@",self.arr[i][@"goods_price"]];
        model.infolb = [NSString stringWithFormat:@"%@",self.arr[i][@"goods_info"]];
        model.sizelb = [NSString stringWithFormat:@"%@",self.arr[i][@"shop_name"]];
        model.mark = [NSString stringWithFormat:@"%@",self.arr[i][@"mark"]];
        model.is_comment = [NSString stringWithFormat:@"%@",self.arr[i][@"is_comment"]];
        model.reply = [NSString stringWithFormat:@"%@",self.arr[i][@"reply"]];
        model.conment = [NSString stringWithFormat:@"%@",self.arr[i][@"comment"]];
        model.goods_num = [NSString stringWithFormat:@"%@",self.arr[i][@"goods_num"]];
        [self.dataArr addObject:model];
    }
    [self.tableview reloadData];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
     return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    orderEvaluationModel *model = self.dataArr[section];
    
    return model.isexpand == YES ? 1:0;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    orderEvaluationModel *model = self.dataArr[indexPath.section];
    
    if ([model.is_comment integerValue] == 0) {
        return model.isexpand == YES ? 200:0;
    }else if ([model.is_comment integerValue] == 1){
        if (model.isexpand == YES) {
            self.tableview.estimatedRowHeight = 70;
            self.tableview.rowHeight = UITableViewAutomaticDimension;
            return UITableViewAutomaticDimension;
        }else{
            return 0;
        }
    }else if ([model.is_comment integerValue] == 2){
        if (model.isexpand == YES) {
            self.tableview.estimatedRowHeight = 105;
            self.tableview.rowHeight = UITableViewAutomaticDimension;
            return UITableViewAutomaticDimension;
        }else{
            return 0;
        }
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    orderEvaluationModel *model = self.dataArr[indexPath.section];

    if ([model.is_comment integerValue] == 0) {
        LBMineCenterMYOrderEvaluationDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterMYOrderEvaluationDetailTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.index=indexPath.section;
        cell.delegete = self;
        cell.orderEvaluationModel = model;
        return cell;
    }else if ([model.is_comment integerValue] == 1 ) {
        LBMineCenterMYOrderEvaluationDetailTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterMYOrderEvaluationDetailTwoTableViewCell" forIndexPath:indexPath];
        cell.starview.progress = [model.mark floatValue];
        cell.contentlb.text = model.conment;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if ([model.is_comment integerValue] == 2) {
        LBMineCenterMYOrderEvaluationDetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterMYOrderEvaluationDetailOneTableViewCell" forIndexPath:indexPath];
        cell.starview.progress = [model.mark floatValue];
        cell.contentlb.text = model.conment;
        cell.replayLb.text = model.reply;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
    return [[UITableViewCell alloc]init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 110;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LBMyOrderlistHeaderFooterView *headerview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LBMyOrderlistHeaderFooterView"];
    
    if (!headerview) {
        headerview = [[LBMyOrderlistHeaderFooterView alloc] initWithReuseIdentifier:@"LBMyOrderlistHeaderFooterView"];
        
    }
    headerview.index = section;
    orderEvaluationModel *model = self.dataArr[headerview.index];
    __weak typeof(self) weakself = self;
    headerview.orderName.text = model.namelb;
    headerview.orderinfo.text = model.infolb;
    headerview.orderstore.text = model.sizelb;
    [headerview.imagev sd_setImageWithURL:[NSURL URLWithString:model.imageurl] placeholderImage:[UIImage imageNamed:@"planceholder"]];
    if ([headerview.orderstore.text rangeOfString:@"null"].location != NSNotFound) {
        headerview.orderstore.text = @"暂无";
    }
    headerview.ordermoney.text = [NSString stringWithFormat:@"¥%@",model.moneylb];
    headerview.numlb.text = [NSString stringWithFormat:@"x%@",model.goods_num];
    
    if ([model.is_comment integerValue] == 0) {
        headerview.typelabel.text = @"发表评论";
        
    }else if ([model.is_comment integerValue] == 1 || [model.is_comment integerValue] == 2) {

        headerview.typelabel.text = @"已评论";
    }
    
    if (model.isexpand == YES) {

        headerview.imagevo.transform = CGAffineTransformIdentity;
        
    }else{
        
        CGAffineTransform cgaffine = CGAffineTransformMakeRotation(M_PI);
        headerview.imagevo.transform = cgaffine;
    }
    
    headerview.retrunshowsection = ^(NSInteger sectiona,LBMyOrderlistHeaderFooterView *headview){
        model.isexpand = !model.isexpand;
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:sectiona];
        [weakself.tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        
    };
    
    return headerview;
}


#pragma mark ---- LBMineCenterMYOrderEvaluationDetailDelegete

-(void)tapgestureshowmoreinfo:(NSInteger)index{

    orderEvaluationModel *model = self.dataArr[index];
    model.isexpand = !model.isexpand;
    [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
    //[self.tableview reloadData];
    
}

-(void)ishidekeyboard{
    [self.view endEditing:YES];
}

-(void)submitevaluationinfo:(NSInteger)index{
      [self.view endEditing:YES];
    orderEvaluationModel *model = self.dataArr[index];
    if (model.starValue == 0) {
        [MBProgressHUD showError:@"没有评分"];
        return;
    }
    if (model.conentlb.length <= 0) {
        [MBProgressHUD showError:@"请写点感受吧"];
        return;
    }
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    
    NSString *inputText = [model.conentlb stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [NetworkManager requestPOSTWithURLStr:@"Shop/saveUserComment" paramDic:@{@"uid":[UserModel defaultUser].uid , @"token":[UserModel defaultUser].token , @"mark" :[NSNumber numberWithFloat:model.starValue] , @"comment":inputText,@"order_goods_id":model.order_goods_id} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            model.is_comment = @"1";
            model.conment = model.conentlb;
            model.mark = [NSString stringWithFormat:@"%f",model.starValue];
            [MBProgressHUD showError:@"评论成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LBMyOrderPendingEvaluationViewController" object:nil userInfo:@{@"mark":model.mark,@"comment":model.conment,@"row":[NSNumber numberWithInteger:index]}];
            [self.tableview reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];

        }else if ([responseObject[@"code"] integerValue]==3){
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
        }else{
            
        }
                  [MBProgressHUD showError:responseObject[@"message"]];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

-(NSMutableArray*)dataArr{

    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    
    return _dataArr;

}

@end
