//
//  LBShowSaleManAndBusinessViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/23.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBShowSaleManAndBusinessViewController.h"
#import "LBMySalesmanListViewController.h"
#import "LBMyBusinessListViewController.h"
#import "LBMySalesmanListDeatilViewController.h"
#import "LBMyBusinessListDetailViewController.h"
#import "LBSaleManPersonInfoViewController.h"
#import "LBViewProtocolViewController.h"
#import <MapKit/MapKit.h>
#import "LBMySalesmanListAuditViewController.h"
#import "LBMySalesmanListFaildViewController.h"
#import "CommonMenuView.h"
#import "UIView+AdjustFrame.h"
#import "LBSavaTypeModel.h"

@interface LBShowSaleManAndBusinessViewController ()
{
    NSArray *_dataArray;
}
@property (nonatomic,assign) BOOL flag;
@property (nonatomic,assign) int itemCount;
@property (weak, nonatomic) IBOutlet UIView *navigationV;
@property (weak, nonatomic) IBOutlet UIView *buttonv;
@property (weak, nonatomic) IBOutlet UIButton *saleBt;
@property (weak, nonatomic) IBOutlet UIButton *businessBt;
@property (weak, nonatomic) IBOutlet UIButton *shenheZBt;

@property (strong, nonatomic)LBMySalesmanListAuditViewController *AuditVc;
@property (strong, nonatomic)LBMySalesmanListViewController *scuessVc;
@property (strong, nonatomic)LBMySalesmanListFaildViewController *faildVc;
@property (nonatomic, strong)UIViewController *currentViewController;
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIView *lineView;

@property (strong, nonatomic)NSString *usertype;

@end

@implementation LBShowSaleManAndBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.flag = YES;
    self.navigationController.navigationBar.hidden = YES;
    //    self.navigationItem.title = @"商家列表";
      self.automaticallyAdjustsScrollViewInsets = NO;
     [self.buttonv addSubview:self.lineView];
    
    _AuditVc=[[LBMySalesmanListAuditViewController alloc]init];
    _scuessVc=[[LBMySalesmanListViewController alloc]init];
    _faildVc=[[LBMySalesmanListFaildViewController alloc]init];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, SCREEN_HEIGHT - 114)];
    [self.view addSubview:_contentView];
    
    [self addChildViewController:_AuditVc];
    [self addChildViewController:_scuessVc];
    [self addChildViewController:_faildVc];
    
    self.currentViewController = _faildVc;
    [self fitFrameForChildViewController:_faildVc];
    [self.contentView addSubview:_faildVc.view];
    
    __weak typeof(self) weakself = self;
    _scuessVc.returnpushvc = ^(NSDictionary *dic){
    
        if ([dic[@"saleman_type"] integerValue] == 8) {
//            weakself.hidesBottomBarWhenPushed = YES;
//            LBMyBusinessListViewController *vc=[[LBMyBusinessListViewController alloc]init];
//            vc.HideNavB = YES;
//            [weakself.navigationController pushViewController:vc animated:YES];
//            weakself.hidesBottomBarWhenPushed = NO;
        }else {
            weakself.hidesBottomBarWhenPushed = YES;
            LBMySalesmanListDeatilViewController *vc=[[LBMySalesmanListDeatilViewController alloc]init];
            vc.dic = dic;
            [weakself.navigationController pushViewController:vc animated:YES];
            weakself.hidesBottomBarWhenPushed = NO;
        }
    };
    
    NSDictionary *dict1 = @{@"imageName" : @"",
                            @"itemName" : @"创客"
                            };
    NSDictionary *dict2 = @{@"imageName" : @"",
                            @"itemName" : @"城市创客"
                            };

     NSArray *dataArray = @[dict1,dict2];
    
    _dataArray = dataArray;
    
    __weak __typeof(&*self)weakSelf = self;
    
    /**
     *  创建普通的MenuView，frame可以传递空值，宽度默认120，高度自适应
     */
    [CommonMenuView createMenuWithFrame:CGRectMake(0, 0, 130, 0) target:self dataArray:dataArray itemsClickBlock:^(NSString *str, NSInteger tag) {
        [weakSelf doSomething:(NSString *)str tag:(NSInteger)tag]; // do something
    } backViewTap:^{
        weakSelf.flag = YES; // 这里的目的是，让rightButton点击，可再次pop出menu
    }];
}

- (IBAction)salemanEvent:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = CGRectMake(0, 48, SCREEN_WIDTH / 3, 1);
        [self.saleBt setTitleColor:TABBARTITLE_COLOR forState:UIControlStateNormal];
        [self.businessBt setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
        [self.shenheZBt setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
    }];
    
    [self transitionFromVC:self.currentViewController toviewController:_faildVc];
    [self fitFrameForChildViewController:_faildVc];
}
- (IBAction)businessEvent:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = CGRectMake(SCREEN_WIDTH/3 , 48, SCREEN_WIDTH / 3, 1);
        [self.businessBt setTitleColor:TABBARTITLE_COLOR forState:UIControlStateNormal];
        [self.saleBt setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
        [self.shenheZBt setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
    }];
    
    [self transitionFromVC:self.currentViewController toviewController:_scuessVc];
    [self fitFrameForChildViewController:_scuessVc];
    
}

- (IBAction)shenhezhong:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.frame = CGRectMake(SCREEN_WIDTH/3 * 2, 48, SCREEN_WIDTH / 3, 1);
        [self.saleBt setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
        [self.businessBt setTitleColor:YYSRGBColor(0, 0, 0, 1) forState:UIControlStateNormal];
        [self.shenheZBt setTitleColor:TABBARTITLE_COLOR forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        
    }];
    
    [self transitionFromVC:self.currentViewController toviewController:_AuditVc];
    [self fitFrameForChildViewController:_AuditVc];
    
}
//帅选
- (IBAction)shaixuanEvent:(UIButton *)sender {
    
    //[[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    //[self.maskView addSubview:self.mySalesmanListView];
    [self popMenu:CGPointMake(SCREEN_WIDTH-30, 50)];
    
}

- (IBAction)backEvent:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)popMenu:(CGPoint)point{
    if (self.flag) {
        [CommonMenuView showMenuAtPoint:point];
        self.flag = NO;
    }else{
        [CommonMenuView hidden];
        self.flag = YES;
    }
}

- (void)fitFrameForChildViewController:(UIViewController *)childViewController{
    CGRect frame = self.contentView.frame;
    frame.origin.y = 0;
    childViewController.view.frame = frame;
}

- (void)transitionFromVC:(UIViewController *)viewController toviewController:(UIViewController *)toViewController {
    
    if ([toViewController isEqual:self.currentViewController]) {
        return;
    }
    [self transitionFromViewController:viewController toViewController:toViewController duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:nil completion:^(BOOL finished) {
        [viewController willMoveToParentViewController:nil];
        [toViewController willMoveToParentViewController:self];
        self.currentViewController = toViewController;
    }];
    
}
#pragma mark -- 回调事件(自定义)
- (void)doSomething:(NSString *)str tag:(NSInteger)tag{
    self.titleLb.text = str;
    switch (tag) {
        case 1:
            [LBSavaTypeModel defaultUser].type = @"1";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"filterExtensionCategories" object:nil userInfo:nil];
            break;
        case 2:
            [LBSavaTypeModel defaultUser].type = @"2";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"filterExtensionCategories" object:nil userInfo:nil];
            break;
//        case 3:
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"filterExtensionCategories" object:nil userInfo:@{@"indexVc":@3}];
//            break;
            
        default:
            break;
    }
    
    
    [CommonMenuView hidden];
    self.flag = YES;
}

-(UIView*)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH / 3, 1)];
        _lineView.backgroundColor = TABBARTITLE_COLOR;
    }
    
    return _lineView;
    
}

#pragma mark -- dealloc:释放菜单
- (void)dealloc{
    [CommonMenuView clearMenu];   // 移除菜单
}
@end
