//
//  GLIncomeManagerRecommendController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIncomeManagerRecommendController.h"
#import "GLIncomeManagerCell.h"
#import "HWCalendar.h"
#import "GLIncomeManagerModel.h"

@interface GLIncomeManagerRecommendController ()<UITableViewDataSource,UITableViewDelegate,HWCalendarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *searchBt;
@property (weak, nonatomic) IBOutlet UILabel *startLb;
@property (weak, nonatomic) IBOutlet UILabel *endLb;

@property (strong, nonatomic)NSString *startstr;
@property (strong, nonatomic)NSString *endStr;

@property (strong, nonatomic)LoadWaitView *loadV;
@property (assign, nonatomic)NSInteger page;//页数默认为0
@property (assign, nonatomic)BOOL refreshType;//判断刷新状态 默认为no
@property (strong, nonatomic)NSMutableArray *dataarr;

@property (weak, nonatomic) IBOutlet UILabel *total_money;
@property (weak, nonatomic) IBOutlet UILabel *oneLb;
@property (weak, nonatomic) IBOutlet UILabel *twoLb;
@property (weak, nonatomic) IBOutlet UILabel *threeLb;
@property (weak, nonatomic) IBOutlet UILabel *fourLb;

@property (strong, nonatomic)HWCalendar *Calendar;
@property (strong, nonatomic)UIView *CalendarView;
@property (assign, nonatomic)NSInteger timeBtIndex;//判断选择的按钮时哪一个
@end

static NSString *ID = @"GLIncomeManagerCell";

@implementation GLIncomeManagerRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _startstr = @"";
    _endStr = @"";
    _page = 1;
    _refreshType = NO;
    [self.tableview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
    
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadNewData];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf footerrefresh];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔 ..." forState:MJRefreshStateRefreshing];
    
    self.tableview.mj_header = header;
    self.tableview.mj_footer = footer;
    
    [self initdatasource];
    
    NSDate *data = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    self.endLb.text = [dateFormatter stringFromDate: data];
    _endStr =  [dateFormatter stringFromDate: data];
    [[UIApplication sharedApplication].keyWindow addSubview:self.CalendarView];
    
    self.CalendarView.hidden = YES;
    
    [self.CalendarView addSubview:self.Calendar];
    
    __weak typeof(self) weakself = self;
    _Calendar.returnCancel = ^(){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakself.CalendarView.hidden = YES;
        });
    };
}

-(void)initdatasource{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"type"] = @(1);
    dic[@"page"] = @(_page);
    if (self.startstr.length<=0) {
        dic[@"starttime"] = @"";
        dic[@"endtime"] = @"";
    }else{
        dic[@"starttime"] = self.startstr;
        dic[@"endtime"] = self.endStr;
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"User/getUserAchievement" paramDic:dic finish:^(id responseObject) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        
        if ([responseObject[@"code"] integerValue]==1) {
            
            self.total_money.text = [NSString stringWithFormat:@"%@",responseObject[@"money_total"]];
            self.oneLb.text = [NSString stringWithFormat:@"¥%@",responseObject[@"one"]];
            self.twoLb.text = [NSString stringWithFormat:@"¥%@",responseObject[@"two"]];
            self.threeLb.text = [NSString stringWithFormat:@"¥%@",responseObject[@"three"]];
            self.fourLb.text = [NSString stringWithFormat:@"¥%@",responseObject[@"four"]];
            
            if ([responseObject[@"recommend_one"] floatValue] >=10000) {
                self.oneLb.text = [NSString stringWithFormat:@"%.1f万",[responseObject[@"recommend_one"] floatValue]/10000];
            }
            if ([responseObject[@"recommend_two"] floatValue] >=10000) {
                self.twoLb.text = [NSString stringWithFormat:@"%.1f万",[responseObject[@"recommend_two"] floatValue]/10000];
            }
            if ([responseObject[@"recommend_three"] floatValue] >=10000) {
                self.threeLb.text = [NSString stringWithFormat:@"%.1f万",[responseObject[@"recommend_three"] floatValue]/10000];
            }
            if ([responseObject[@"recommend_four"] floatValue] >=10000) {
                self.fourLb.text = [NSString stringWithFormat:@"%.1f万",[responseObject[@"recommend_four"] floatValue]/10000];
            }
            
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
                
            }
            for (NSDictionary *dic in responseObject[@"data"]) {
                GLIncomeRecommendModel *model = [GLIncomeRecommendModel mj_objectWithKeyValues:dic];
                [self.dataarr addObject:model];
            }
            [self.tableview reloadData];
            
        }else if ([responseObject[@"code"] integerValue]==3){
            if (_refreshType == NO) {
                [self.dataarr removeAllObjects];
            }
            [self.view makeToast:responseObject[@"message"] duration:2.0 position:CSToastPositionCenter];
            [self.tableview reloadData];
        }else{
           [self.view makeToast:responseObject[@"message"] duration:2.0 position:CSToastPositionCenter];
            [self.tableview reloadData];
            
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        [self.view makeToast:error.localizedDescription duration:2.0 position:CSToastPositionCenter];
    }];
    
    
}

//下拉刷新
-(void)loadNewData{
    
    _refreshType = NO;
    _page=1;
    
    [self initdatasource];
}
//上啦刷新
-(void)footerrefresh{
    _refreshType = YES;
    _page++;
    
    [self initdatasource];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}



#pragma UITableviewDelegate UITableviewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataarr.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    GLIncomeManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataarr[indexPath.row];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 112;
    
}
//选择开始时间
- (IBAction)tapgestureStartTime:(UITapGestureRecognizer *)sender {
    
    _timeBtIndex = 1;
    self.CalendarView.hidden = NO;
    [_Calendar show];
    
}
//结束时间
- (IBAction)tapgestureEndTime:(UITapGestureRecognizer *)sender {
    _timeBtIndex = 2;
    self.CalendarView.hidden = NO;
    [_Calendar show];
    
}
//搜索
- (IBAction)searchEvent:(UIButton *)sender {
    
    if ([self.startstr isEqualToString:@""]) {
        [MBProgressHUD showError:@"还没选择时间区间"];
        return;
    }
    
    _page = 1;
    _refreshType = NO;
    
    NSDate *date1;
    NSDate *date2;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    date1 = [dateFormatter dateFromString:self.startstr];
    date2 = [dateFormatter dateFromString:self.endStr];
    
    //转成时间戳
    self.startstr = [NSString stringWithFormat:@"%ld", (long)[date1 timeIntervalSince1970]];
    self.endStr = [NSString stringWithFormat:@"%ld", (long)[date2 timeIntervalSince1970]];
    
    if ([[NSString stringWithFormat:@"%d",[self compareOneDay:date1 withAnotherDay:date2]] isEqualToString:@"1"]) {
        //NSLog(@"date1 > date2");
        
        [MBProgressHUD showError:@"请检查时间区间是否正确"];
        
    }else if ([[NSString stringWithFormat:@"%d",[self compareOneDay:date1 withAnotherDay:date2]] isEqualToString:@"-1"]){
        // NSLog(@"date1 < date2");
        [self initdatasource];
    }else{
        //NSLog(@"date1 = date2");
        [self initdatasource];
    }
}
#pragma mark - 时间比较大小
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //oneDay > anotherDay
        return 1;
    }
    else if (result == NSOrderedAscending){
        //oneDay < anotherDay
        return -1;
    }
    //oneDay = anotherDay
    return 0;
}

#pragma mark - HWCalendarDelegate
- (void)calendar:(HWCalendar *)calendar didClickSureButtonWithDate:(NSString *)date
{
    
    
    __weak typeof(self) weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakself.CalendarView.hidden = YES;
    });
    
    if (_timeBtIndex == 1) {
        
        self.startLb.text = date;
        self.startstr = date;
        
    }else if (_timeBtIndex == 2){
        
        self.endLb.text = date;
        self.endStr = date;
    }
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.searchBt.layer.cornerRadius = 4;
    self.startLb.layer.cornerRadius = 4;
    self.endLb.layer.cornerRadius = 4;
    
}
-(NSMutableArray *)dataarr{
    
    if (!_dataarr) {
        _dataarr=[NSMutableArray array];
    }
    
    return _dataarr;
}

-(HWCalendar*)Calendar{
    
    if (!_Calendar) {
        _Calendar=[[HWCalendar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT , SCREEN_WIDTH , (SCREEN_WIDTH * 0.8)/7 * 9.5)];
        _Calendar.delegate = self;
        _Calendar.showTimePicker = YES;
        
    }
    return _Calendar;
}
-(UIView*)CalendarView{
    
    if (!_CalendarView) {
        _CalendarView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _CalendarView.backgroundColor=YYSRGBColor(0, 0, 0, 0.2);
    }
    return _CalendarView;
}

@end
