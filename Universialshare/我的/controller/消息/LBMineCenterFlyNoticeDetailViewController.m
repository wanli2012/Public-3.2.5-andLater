//
//  LBMineCenterFlyNoticeDetailViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterFlyNoticeDetailViewController.h"
#import "LBMineCenterFlyNoticeDetailTableViewCell.h"
#import "LBMineCenterFlyNoticeDetailOneTableViewCell.h"


@interface LBMineCenterFlyNoticeDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)LoadWaitView *loadV;
@property (strong, nonatomic)NSDictionary *dataArr;

@end

@implementation LBMineCenterFlyNoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"物流详情";
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    self.tableview.tableFooterView = [UIView new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterFlyNoticeDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterFlyNoticeDetailTableViewCell"];
    
     [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterFlyNoticeDetailOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterFlyNoticeDetailOneTableViewCell"];
    
    if (self.codestr.length > 0 && [self.codestr rangeOfString:@"null"].location == NSNotFound) {
        [self initdatasorce];//数据请求
    }
    
}

-(void)initdatasorce{

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    // 加上这行代码，https ssl 验证。
   [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    //@"885288037507667815"
    NSDictionary  *dic =  @{@"number":self.codestr,@"type":@"auto",@"app_version":APP_VERSION,@"version":@"3"};
    
    [manager.requestSerializer setValue:@"APPCODE f92896288a5949088c46c166af190b2c" forHTTPHeaderField:@"Authorization"];
    
    [manager GET:logisticsUrl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [_loadV removeloadview];
        if ([dic[@"status"]integerValue] == 0) {
            self.dataArr = dic[@"result"];
            [self.tableview reloadData];
        }else if ([dic[@"status"]integerValue] == 205) {
            [MBProgressHUD showError:@"暂无物流信息"];
        }else if ([dic[@"status"]integerValue] == 201) {
            [MBProgressHUD showError:@"快递单号为空"];
        }else{
           [MBProgressHUD showError:@"快递公司识别失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_loadV removeloadview];
         [MBProgressHUD showError:@"订单单号异常,联系商家"];
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArr[@"list"] count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        return 60;
    }else{
        self.tableview.estimatedRowHeight = 70;
        self.tableview.rowHeight = UITableViewAutomaticDimension;
        return UITableViewAutomaticDimension;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row==0) {
        LBMineCenterFlyNoticeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterFlyNoticeDetailTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.codelb.text = [NSString stringWithFormat:@"%@",self.codestr];
        
        if ([cell.codelb.text rangeOfString:@"null"].location != NSNotFound || self.codestr.length <= 0) {
            cell.codelb.text = @"物流单号为空";
        }
        
        return cell;
    }else{
        LBMineCenterFlyNoticeDetailOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterFlyNoticeDetailOneTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 1 ) {
            cell.lineview.hidden = YES;
            cell.bottomV.hidden = NO;
        }else if(indexPath.row == [self.dataArr[@"list"] count] ){
            cell.lineview.hidden = NO;
            cell.bottomV.hidden = YES;
        }else{
           cell.lineview.hidden = NO;
          cell.bottomV.hidden = NO;
        }
        
        NSMutableString *str = [NSMutableString stringWithFormat:@"%@",self.dataArr[@"list"][indexPath.row - 1][@"status"]];
       NSString *str1 = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        cell.contentlb.text = str1;
         cell.timelb.text = [NSString stringWithFormat:@"%@",self.dataArr[@"list"][indexPath.row - 1][@"time"]];
        
        return cell;
    }
    
}

-(NSDictionary*)dataArr{

    if (!_dataArr) {
        _dataArr=[NSDictionary dictionary];
    }
    return _dataArr;
}

@end
