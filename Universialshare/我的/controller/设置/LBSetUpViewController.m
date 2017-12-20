//
//  LBSetUpViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/3/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBSetUpViewController.h"
#import "LBMineCentermodifyAdressViewController.h"
#import "LBMineCenterAccountSafeViewController.h"
#import "GLSetup_VersionInfoController.h"
#import "LBViewProtocolViewController.h"
#import "GLSetup_SwitchIDController.h"
#import "LBMineCenterRegionQueryViewController.h"
#import "MinePhoneAlertView.h"

#define PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]

@interface LBSetUpViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *exitBt;
@property (weak, nonatomic) IBOutlet UILabel *momeryLb;
@property (weak, nonatomic) IBOutlet UILabel *verionLb;
@property (nonatomic , assign)float folderSize;//缓存

@property(nonatomic ,strong)MinePhoneAlertView  *phoneView;
@property(nonatomic ,strong)NSString  *phonestr;//服务热线
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstarit;

@end

@implementation LBSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.verionLb.text = [UserModel defaultUser].version;
    
    self.folderSize = [self filePath];
    
    self.momeryLb.text = [NSString stringWithFormat:@"%.2fM",self.folderSize];
    
    self.phonestr = [UserModel defaultUser].pre_phone;
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
//切换身份
- (IBAction)switchIdentity:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLSetup_SwitchIDController *switchVC = [[GLSetup_SwitchIDController alloc] init];
    [self.navigationController pushViewController:switchVC animated:YES];
}


//修改收货地址
- (IBAction)exchangeAdress:(UITapGestureRecognizer *)sender {
    self.hidesBottomBarWhenPushed = YES;
    LBMineCentermodifyAdressViewController *vc=[[LBMineCentermodifyAdressViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
   
}
//清除缓存
- (IBAction)clearMomery:(UITapGestureRecognizer *)sender {
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要删除缓存吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 11;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
        if (alertView.tag == 10) {
            
            [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error)
             {
                 extern NSString *NTESNotificationLogout;
                 [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
             }];
           [UserModel defaultUser].loginstatus = NO;
            [UserModel defaultUser].headPic = @"";
            [UserModel defaultUser].usrtype = @"0";
            [usermodelachivar achive];
            
            CATransition *animation = [CATransition animation];
            animation.duration = 0.3;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = @"suckEffect";
            // animation.type = kCATransitionFade;
            [self.view.window.layer addAnimation:animation forKey:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"exitLogin" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if (alertView.tag == 11){
        
             [self clearFile];//清楚缓存
        }

    }
    
}
//账号安全
- (IBAction)accountSafe:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBMineCenterAccountSafeViewController *vc=[[LBMineCenterAccountSafeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
   
}
//关于
- (IBAction)aboutUs:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBViewProtocolViewController *vc=[[LBViewProtocolViewController alloc]init];
    vc.webUrl = ABOUTUS_URL;
    vc.navTitle = @"关于我们";
    [self.navigationController pushViewController:vc animated:YES];
    
}

//区域查询
- (IBAction)areaCheck:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed=YES;
    LBMineCenterRegionQueryViewController *vc=[[LBMineCenterRegionQueryViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

//联系客服
- (IBAction)customerService:(id)sender {
    self.phoneView.transform=CGAffineTransformMakeScale(0, 0);
    
    NSString *str=[NSString stringWithFormat:@"是否拨打电话? %@",self.phonestr];
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange rangel = [[textColor string] rangeOfString:self.phonestr];
    [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:76/255.0 green:140/255.0 blue:247/255.0 alpha:1] range:rangel];
    //[textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:rangel];
    [_phoneView.titleLb setAttributedText:textColor];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.phoneView];
    
    [UIView animateWithDuration:0.3 animations:^{
        _phoneView.transform=CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
    }];

}

//普通问题汇总
- (IBAction)SummaryOfGeneralQuestions:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBViewProtocolViewController *vc=[[LBViewProtocolViewController alloc]init];
    vc.webUrl = ordinaryURL;
    vc.navTitle = @"普通问题汇总";
    [self.navigationController pushViewController:vc animated:YES];
    
}
//财务问题汇总
- (IBAction)SummaryOfFinancialProblems:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBViewProtocolViewController *vc=[[LBViewProtocolViewController alloc]init];
    vc.webUrl = financeURL;
    vc.navTitle = @"财务问题汇总";
    [self.navigationController pushViewController:vc animated:YES];
}
//技术问题汇总
- (IBAction)SummaryOfTechnicalProblems:(UITapGestureRecognizer *)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    LBViewProtocolViewController *vc=[[LBViewProtocolViewController alloc]init];
    vc.webUrl = technicalURL;
    vc.navTitle = @"技术问题汇总";
    [self.navigationController pushViewController:vc animated:YES];
}


//退出登录
- (IBAction)exitEvent:(UIButton *)sender {
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 10;
    [alert show];
    
}
- (IBAction)versionInfo:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLSetup_VersionInfoController *versionVC = [[GLSetup_VersionInfoController alloc] init];
    [self.navigationController pushViewController:versionVC animated:YES];
}

//*********************清理缓存********************//
//显示缓存大小
-( float )filePath
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}
//单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}
//返回多少 M
- ( float ) folderSizeAtPath:( NSString *) folderPath{
    NSFileManager * manager = [ NSFileManager defaultManager ];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
    }
    return folderSize/( 1024.0 * 1024.0 );
}
// 清理缓存
- (void)clearFile
{
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    //NSLog ( @"cachpath = %@" , cachPath);
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
}

-(void)clearCachSuccess{
    self.folderSize=[self filePath];
    self.momeryLb.text = [NSString stringWithFormat:@"%.2fM",self.folderSize];
    
}



-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.widthConstrait.constant = SCREEN_WIDTH;
    self.heightConstarit.constant = 750;
    self.exitBt.layer.cornerRadius = 5;
    self.exitBt.clipsToBounds = YES;


}
-(MinePhoneAlertView *)phoneView{
    
    if (!_phoneView) {
        _phoneView=[[NSBundle mainBundle]loadNibNamed:@"MinePhoneAlertView" owner:nil options:nil].firstObject;
        _phoneView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _phoneView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [_phoneView.cancelBt addTarget:self action:@selector(cancelbutton) forControlEvents:UIControlEventTouchUpInside];
        [_phoneView.sureBt addTarget:self action:@selector(surebuttonE) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _phoneView;
}

-(void)cancelbutton{
    [UIView animateWithDuration:0.3 animations:^{
        _phoneView.transform=CGAffineTransformMakeScale(0.000001, 0.000001);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [_phoneView removeFromSuperview];
        }
    }];
    
}

-(void)surebuttonE{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phonestr]]]; //拨号
    
}
@end
