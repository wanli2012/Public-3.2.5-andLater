//
//  LBMineCenterPayPagesViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterPayPagesViewController.h"
#import "LBMineCenterPayPagesTableViewCell.h"
#import "LBIntegralMallViewController.h"
#import "GLOrderPayView.h"
#import "GLSet_MaskVeiw.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "LBPaysucessView.h"
#import "UMSocial.h"
#import <Social/Social.h>

@interface LBMineCenterPayPagesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    LoadWaitView *_loadV;
    GLSet_MaskVeiw *_maskV;
    GLOrderPayView *_contentView;
}

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *ricelb;

@property (weak, nonatomic) IBOutlet UIButton *sureBt;

@property (strong, nonatomic)  NSMutableArray *dataarr;
@property (strong, nonatomic)  NSMutableArray *selectB;
@property (assign, nonatomic)  NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet UILabel *orderType;
@property (weak, nonatomic) IBOutlet UILabel *ordercode;
@property (weak, nonatomic) IBOutlet UILabel *orderMoney;
@property (weak, nonatomic) IBOutlet UILabel *orderMTitleLb;

@property (nonatomic, strong)NSString *selectecTypeStr;//选中的支付方式
@property (nonatomic, strong)LBPaysucessView *paysucessView;
@property (nonatomic, strong)NSString *shareStr;//记录分享链接
@property(nonatomic ,assign)NSInteger paymethod;//支付方式

@end

@implementation LBMineCenterPayPagesViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"支付";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.selectIndex = -1;
    _paymethod = 0;
    self.tableview.tableFooterView = [UIView new];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterPayPagesTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterPayPagesTableViewCell"];
    
    self.ordercode.text = self.order_sn;
    self.orderMoney.text = [NSString stringWithFormat:@"%.2f",[self.orderPrice floatValue]];
    self.ricelb.text = [NSString stringWithFormat:@"%@",self.coupose];
    if (self.ricelb.text.length <= 0 || [self.ricelb.text rangeOfString:@"null"].location != NSNotFound) {
        self.ricelb.text = @"0";
    }

    if (self.payType == 1 || self.payType == 3) {
        self.orderMTitleLb.text = @"订单金额:";
        if (self.payType == 1) {
            self.orderType.text = @"消费订单";
        }else{
            self.orderType.text = @"面对面订单";
        }
        
    }else if(self.payType == 2){
        self.orderMTitleLb.text = @"订单米券:";
        self.orderType.text = @"米券订单";
    }else if(self.payType == 4){
        self.orderMTitleLb.text = @"订单金额:";
        self.orderType.text = @"商城订单";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRepuest:) name:@"input_PasswordNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Alipaysucess) name:@"Alipaysucess" object:nil];
    
    /**
     *微信支付成功 回调
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpaysucess) name:@"wxpaysucess" object:nil];
    /**
     *判断是否展示支付
     */
    [self isShowPayInterface];
    
    [self.view addSubview:self.paysucessView];
    self.paysucessView.hidden = YES;
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"iv_back"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(5, -5, 5, 25)];
    button.backgroundColor=[UIColor clearColor];
    [button addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = ba;
    
    //分享
    [self shareMmerchantIInfo];

}

// 分享
-(void)shareMmerchantIInfo{
    __weak typeof(self) wself = self;
    _paysucessView.weixinshre = ^{
        [wself shareTo:@[UMShareToWechatSession]];
    };
    _paysucessView.weiboshre = ^{
        [wself shareTo:@[UMShareToSina]];
    };
    _paysucessView.friendshre = ^{
        [wself shareTo:@[UMShareToWechatTimeline]];
    };
    
}

- (void)shareTo:(NSArray *)type{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@",self.shareStr];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"大众团购";
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@",self.shareStr];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"大众团购";
    
    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = [NSString stringWithFormat:@"%@",self.shareStr];
    //    [UMSocialData defaultData].extConfig.sinaData.title = @"加入我们吧";
    
    UIImage *image=[UIImage imageNamed:@"mine_logo"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:type content:[NSString stringWithFormat:@"我在大众团购购买了商品，快来看看吧！(用safari浏览器打开)%@",[NSString stringWithFormat:@"%@",self.shareStr]] image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
        }
    }];
}
//分享链接
-(void)GetShareLinks{
    
    
    NSString *sharurl = [NSString stringWithFormat:@"%@%@?order_id=%@",URL_Base,@"Share/share",self.order_id];
    
    self.shareStr = [sharurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}


-(void)popself{
    if(self.pushIndex == 1){
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)isShowPayInterface{

    [NetworkManager requestPOSTWithURLStr:@"Shop/getPayTypeIsCloseByConfig" paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1) {
            
            if ([responseObject[@"data"][@"mz_pay"] integerValue] == 1) {
                
                if ([responseObject[@"data"][@"mq_pay"] integerValue] == 1) {
                    
                    if (self.payType == 2){
                        [self.dataarr addObject:@{@"image":@"支付米分",@"title":@"米券支付"}];
                    }
                    
                }

                if (self.payType == 1 || self.payType == 3) {
                    
                     [self.dataarr addObject:@{@"image":@"余额",@"title":@"米子支付"}];
                }
            
            }
            if ([responseObject[@"data"][@"wechat"] integerValue] == 1) {
                
                if (self.payType == 1 || self.payType == 3 || self.payType == 4) {
                    
                    [self.dataarr addObject:@{@"image":@"微信",@"title":@"微信支付"}];
                }
                
            }
            if ([responseObject[@"data"][@"alipay"] integerValue] == 1) {
                if (self.payType == 1 || self.payType == 3 || self.payType == 4) {
                    
                    [self.dataarr addObject:@{@"image":@"支付宝",@"title":@"支付宝支付"}];
                }
            }
            
            [self setPayType];
            
            [self.tableview reloadData];
            
        }
        
    } enError:^(NSError *error) {
        
    }];

}

- (void)setPayType {
    //米子 米卷都充足
    for (int i = 0 ; i < self.dataarr.count; i++) {
        if ([self.dataarr[i][@"title"] isEqualToString:@"米券支付"]) {
            [self.selectB addObject:@YES];
           
        }else{
            [self.selectB addObject:@NO];
        }
    }
}


-(void)wxpaysucess{
    
    _paysucessView.hidden = NO;
    self.baseView.hidden = YES;
    _paysucessView.pricelb.text = [NSString stringWithFormat:@"¥ %@",self.orderPrice];
    [self GetShareLinks];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCenterPayPagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterPayPagesTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.payimage.image = [UIImage imageNamed:_dataarr[indexPath.row][@"image"]];
    cell.paytitile.text = _dataarr[indexPath.row][@"title"];
    
    if([self.dataarr[indexPath.row][@"title"] isEqualToString:@"米子支付"]){
        
       cell.reuseScoreLabel.text = [NSString stringWithFormat:@"剩余:%@",[UserModel defaultUser].ketiBean];
        
    }
    
    if ([self.dataarr[indexPath.row][@"title"] isEqualToString:@"米券支付"]) {
        cell.selectimage.image = [UIImage imageNamed:@"支付选中"];
    }else{
        if ([self.selectB[indexPath.row] boolValue] == NO) {
            cell.selectimage.image = [UIImage imageNamed:@"支付未选中"];
        }else{
            cell.selectimage.image = [UIImage imageNamed:@"支付选中"];
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.dataarr[indexPath.row][@"title"] isEqualToString:@"米券支付"]){
        [self.view.window makeToast:@"默认选中" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    if (self.payType != 4) {
        if ([self.rice floatValue] <= 0) {
            [self.view.window makeToast:@"只需米券支付" duration:2.0 position:CSToastPositionCenter];
            return;
        }
    }
    
    [self choosePayType:indexPath.row];
    
    
    [self.tableview reloadData];
}

- (void)choosePayType:(NSInteger )index {
    
    if (self.selectIndex == -1) {
        
        BOOL a=[self.selectB[index] boolValue];
        [self.selectB replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!a]];
        self.selectIndex = index;
        
    }else{
        
        if (self.selectIndex == index) {
            return;
        }
        
        BOOL a=[self.selectB[index]boolValue];
        [self.selectB replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!a]];
        [self.selectB replaceObjectAtIndex:self.selectIndex withObject:[NSNumber numberWithBool:NO]];
        self.selectIndex = index;
        
    }
    
}


- (void)dismiss{
    
    [_contentView.passwordF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    }completion:^(BOOL finished) {
        [_maskV removeFromSuperview];
    }];
}
- (IBAction)surebutton:(UIButton *)sender {
    
   
    for (int i = 0; i < self.selectB.count; i++) {
        
        if ([self.selectB[i] boolValue]) {
            
            if ([self.dataarr[i][@"title"] isEqualToString:@"米子支付"]) {
                _paymethod = 1;
            }else if ([self.dataarr[i][@"title"] isEqualToString:@"微信支付"]){
                if (self.payType == 4) {
                    _paymethod = 4;
                }else{
                    _paymethod = 2;
                }
            }else if ([self.dataarr[i][@"title"] isEqualToString:@"支付宝支付"]){
                if (self.payType == 4) {
                    _paymethod = 5;
                }else{
                    _paymethod = 3;
                }
            }
        }
    }
    
    if (self.payType == 4) {
        if ([self.orderPrice floatValue] <= 0) {
            [self.view.window makeToast:@"订单金额为0"duration:2.0f position:CSToastPositionCenter];
            return;
        }
        [self postRepuest:nil];
    }else{
        if ([self.rice floatValue] <= 0) {
            _paymethod = 0;
        }else{
            if (_paymethod == 0) {
                [self.view.window makeToast:@"暂无选择支付方式"duration:2.0f position:CSToastPositionCenter];
                return;
            }
        }
        CGFloat contentViewH = 300;
        CGFloat contentViewW = SCREEN_WIDTH;
        _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskV.bgView.alpha = 0.4;
        _contentView = [[NSBundle mainBundle] loadNibNamed:@"GLOrderPayView" owner:nil options:nil].lastObject;
        [_contentView.backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _contentView.layer.cornerRadius = 4;
        _contentView.layer.masksToBounds = YES;
        _contentView.priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.orderPrice];
        _contentView.frame = CGRectMake(0, SCREEN_HEIGHT, contentViewW, 0);
        [_maskV showViewWithContentView:_contentView];
        [UIView animateWithDuration:0.3 animations:^{
            _contentView.frame = CGRectMake(0, SCREEN_HEIGHT - contentViewH, contentViewW, contentViewH);
            [_contentView.passwordF becomeFirstResponder];
        }];
    }
    
    
}

//支付请求
- (void)postRepuest:(NSNotification *)sender {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"orderId"] = self.order_id;
    dict[@"order_type"] = @(self.payType);
    dict[@"order_id"] =[RSAEncryptor encryptString:[NSString stringWithFormat:@"%@_%@_%@",self.order_sh,self.order_id,self.order_sn] publicKey:public_RSA];
    if (self.payType != 4) {
         dict[@"password"] = [RSAEncryptor encryptString:[sender.userInfo objectForKey:@"password"] publicKey:public_RSA];
    }
    switch (self.paymethod) {
        case 0://米劵
        {
            
            dict[@"is_rmb"] = @0;
            dict[@"is_mark"] = @3;
            
        }
            break;
        case 1://米劵米子
        {
            
            dict[@"is_rmb"] = @0;
            dict[@"is_mark"] = @6;
            
        }
            break;
        case 2://米劵+微信
        {
            dict[@"pay_type"] = @2;
            dict[@"is_rmb"] = @1;
            dict[@"is_mark"] = @3;
            
        }
            break;
        case 3://米劵+支付宝
        {
            dict[@"pay_type"] = @1;
            dict[@"is_rmb"] = @1;
            dict[@"is_mark"] = @3;
            
        }
            break;
        case 4://微信
        {
            dict[@"pay_type"] = @2;
            dict[@"is_rmb"] = @1;
            dict[@"is_mark"] = @0;
            
        }
            break;
        case 5://支付宝
        {
            dict[@"pay_type"] = @1;
            dict[@"is_rmb"] = @1;
            dict[@"is_mark"] = @0;
            
        }
            break;
            
        default:
            break;
    }
    
    NSLog(@"%@",dict);
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:@"Shop/getPayType" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self dismiss];
        
        if ([responseObject[@"code"] integerValue] == 1){
            
            switch (self.paymethod) {//没有现金
                case 1:
                case 0://米劵
                {
                    _paysucessView.hidden = NO;
                    self.baseView.hidden = YES;
                    _paysucessView.pricelb.text = [NSString stringWithFormat:@"¥ %@",self.orderPrice];
                    
                }
                    break;
                    
                case 2 ://带有微信
                case 4 ://带有微信
                {
                    [MBProgressHUD showError:responseObject[@"message"]];
                    
                    //调起微信支付
                    PayReq* req = [[PayReq alloc] init];
                    req.openID=responseObject[@"data"][@"weixinpay"][@"appid"];
                    req.partnerId = responseObject[@"data"][@"weixinpay"][@"partnerid"];
                    req.prepayId = responseObject[@"data"][@"weixinpay"][@"prepayid"];
                    req.nonceStr = responseObject[@"data"][@"weixinpay"][@"noncestr"];
                    req.timeStamp = [responseObject[@"data"][@"weixinpay"][@"timestamp"] intValue];
                    req.package = responseObject[@"data"][@"weixinpay"][@"package"];
                    req.sign = responseObject[@"data"][@"weixinpay"][@"sign"];
                    [WXApi sendReq:req];
                    
                }
                    break;
                    
                case 3://带有支付宝
                case 5://带有支付宝
                {
                    [[AlipaySDK defaultService]payOrder:responseObject[@"data"][@"alipay"][@"url"] fromScheme:@"univerAlipay" callback:^(NSDictionary *resultDic) {
                        
                        NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
                        if (orderState==9000) {
                            _paysucessView.hidden = NO;
                            self.baseView.hidden = YES;
                            _paysucessView.pricelb.text = [NSString stringWithFormat:@"¥ %@",self.orderPrice];
                            
                            
                        }else{
                            NSString *returnStr;
                            switch (orderState) {
                                case 8000:
                                    returnStr=@"订单正在处理中";
                                    break;
                                case 4000:
                                    returnStr=@"订单支付失败";
                                    break;
                                case 6001:
                                    returnStr=@"订单取消";
                                    break;
                                case 6002:
                                    returnStr=@"网络连接出错";
                                    break;
                                    
                                default:
                                    break;
                            }
                            
                            [MBProgressHUD showError:returnStr];
                            
                        }
                        
                    }];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [MBProgressHUD showError:error.localizedDescription];
        [_loadV removeloadview];
        
    }];

}


//支付宝客户端支付成功之后 发送通知
-(void)Alipaysucess{
    
    _paysucessView.hidden = NO;
    self.baseView.hidden = YES;
    _paysucessView.pricelb.text = [NSString stringWithFormat:@"¥ %@",self.orderPrice];
    [self GetShareLinks];
    
}

-(NSMutableArray*)dataarr{

    if (!_dataarr) {
   
        _dataarr = [NSMutableArray array];
    }

    return _dataarr;
}

-(NSMutableArray*)selectB{

    if (!_selectB) {
        _selectB=[NSMutableArray array];
    }
    
    return _selectB;

}
-(LBPaysucessView*)paysucessView{
    
    if (!_paysucessView) {
        if (self.payType == 4) {
              _paysucessView = [[LBPaysucessView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64 ) isHiddeShareView:YES];
        }else{
            
              _paysucessView = [[LBPaysucessView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64 ) isHiddeShareView:NO];
        }
        _paysucessView.backgroundColor = [UIColor whiteColor];
        _paysucessView.pricelb.text = @"¥ 0";
        
    }
    
    return _paysucessView;
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.sureBt.layer.cornerRadius = 4;
    self.sureBt.clipsToBounds = YES;

}

@end
