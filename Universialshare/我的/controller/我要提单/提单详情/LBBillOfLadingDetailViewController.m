//
//  LBBillOfLadingDetailViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/8.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBBillOfLadingDetailViewController.h"
#import "LBBillOfLadingdetailTableViewCell.h"
#import "LBBillOfLadingSendViewController.h"

@interface LBBillOfLadingDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *submitbt;
@property (weak, nonatomic) IBOutlet UIImageView *imagev;
@property (nonatomic, strong)NSMutableArray *models;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrat;

@end
static NSString *ID = @"LBBillOfLadingdetailTableViewCell";

@implementation LBBillOfLadingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"详情";
    self.tableview.estimatedRowHeight = 50;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    [self.tableview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    self.tableview.tableFooterView = [UIView new];
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_model.xfpz_pic]];
    
    if (_model.xfpz_pic.length  <=0 || [_model.xfpz_pic rangeOfString:@"null"].location != NSNotFound) {
        self.tableview.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        self.tableview.tableHeaderView.hidden = YES;
    }else{
         self.tableview.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 150);
        self.tableview.tableHeaderView.hidden = NO;
    }
    
}
//提单
- (IBAction)submitEvnt:(UIButton *)sender {
    
    NSMutableArray *imagearr = [NSMutableArray array];
    if (self.model.isImage) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"key"] = _model.line_id;
        dic[@"value"] = _model.imagev;
        [imagearr addObject:dic];
    }else{
        if ([self.model.line_money floatValue] > [[UserModel defaultUser].line_money floatValue]) {
            [MBProgressHUD showError:@"请上传消费凭证"];
        }
    }
    self.hidesBottomBarWhenPushed = YES;
    LBBillOfLadingSendViewController *vc=[[LBBillOfLadingSendViewController alloc]init];
    vc.idstr = _model.line_id;
    vc.imageArr = imagearr;
    vc.toatlMoney = [_model.line_money floatValue];
    [self.navigationController pushViewController:vc animated:YES];

    
}

#pragma  UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBBillOfLadingdetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.labelone.text = self.models[indexPath.row][@"one"];
    cell.labelTwo.text = self.models[indexPath.row][@"two"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.submitbt.layer.cornerRadius = 4;
    self.submitbt.clipsToBounds = YES;
    
    if (self.isbutton == YES) {
        self.bottomConstrat.constant = 0;
        self.submitbt.hidden = YES;
    }
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray arrayWithObjects:@{@"one":[NSString stringWithFormat:@"用户ID:%@",_model.user_name],
                                                                                        @"two":[NSString stringWithFormat:@"用户名:%@",_model.truename]},
                                                                                    @{@"one":[NSString stringWithFormat:@"奖励模式:%@",_model.rlmodel_type],
                                                                                          @"two":[NSString stringWithFormat:@"奖励金额:¥%@",_model.rl_money]},
                                                                                  @{@"one":[NSString stringWithFormat:@"订单号:%@",_model.order_num],
                                                                                       @"two":[NSString stringWithFormat:@"商品金额:%@",_model.line_money]},
                                                                                  @{@"one":[NSString stringWithFormat:@"商品名:%@",_model.goods_name],
                                                                                       @"two":[NSString stringWithFormat:@"商品数量:%@",_model.goods_total]},
                                                                                  @{@"one":[NSString stringWithFormat:@"电话号码:%@",_model.phone],
                                                                                        @"two":[NSString stringWithFormat:@"时间:%@",_model.addtime]},nil];
    }
    return _models;
}

@end
