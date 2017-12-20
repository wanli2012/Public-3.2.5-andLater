//
//  yindaotuViewController.m
//  AngelComing
//
//  Created by sm on 16/10/22.
//  Copyright © 2016年 ruichikeji. All rights reserved.
//

#import "yindaotuViewController.h"
#import "basetabbarViewController.h"
#import "BasetabbarViewController.h"

@interface yindaotuViewController ()<UIScrollViewDelegate>

@property (strong , nonatomic)UIScrollView *scrollView;
@property (nonatomic , strong)UIPageControl *pagecontroll;
@property (nonatomic , strong)UIButton  *doneBt;

@end

@implementation yindaotuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
        [self.view addSubview:self.scrollView];
        //[self.view addSubview:self.pagecontroll];
        
        for (int i=0; i<3; i++) {
            UIImageView  *image=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            image.contentMode=UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            if (i==0) {
                image.image=[UIImage imageNamed:@"引导页1"];
            }else  if (i==1) {
                image.image=[UIImage imageNamed:@"引导页2"];
            }else{
                image.image=[UIImage imageNamed:@"引导页3"];
                image.userInteractionEnabled=YES;
                [image addSubview:self.doneBt];
            }
    
            [self.scrollView addSubview:image];
        }
}

- (IBAction)pidaotu:(UIButton *)sender {

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    

}
#pragma mark - getter
-(UIScrollView*)scrollView{
   
        if (!_scrollView) {
            _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH ,SCREEN_HEIGHT)];
            _scrollView.backgroundColor=[UIColor blackColor];
            //设置contentsize(内容大小)
            //_scrilview.contentSize=CGSizeMake(8*_scrilview.bounds.size.width, CGRectGetHeight(_scrilview.bounds));
            _scrollView.contentSize=CGSizeMake(self.view.bounds.size.width*3, 0);
            //设置偏移量0
            _scrollView.contentOffset=CGPointMake(0, 0);
            //设置滚动视图能否回弹
            _scrollView.bounces= NO;
            //设置是否显示横向指示器
            _scrollView.showsHorizontalScrollIndicator=NO;
            //设置是否显示纵向指示器
            _scrollView.showsVerticalScrollIndicator=NO;
            //设置代理
            _scrollView.delegate=self;
            //设置是否分页
            _scrollView.pagingEnabled=YES;
        }
    
    return _scrollView;
    
}

-(UIPageControl *)pagecontroll{
        if (!_pagecontroll) {
            _pagecontroll=[[UIPageControl alloc]init];
            _pagecontroll.frame=CGRectMake((SCREEN_WIDTH-120)/2,SCREEN_HEIGHT-50, 120, 30);
            _pagecontroll.numberOfPages=3;
            _pagecontroll.currentPage=0;
            _pagecontroll.backgroundColor=[UIColor clearColor];
            _pagecontroll.pageIndicatorTintColor=YYSRGBColor(165, 165, 165, 1);
            _pagecontroll.currentPageIndicatorTintColor=TABBARTITLE_COLOR;
    
        }
    
    return _pagecontroll;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pagecontroll.currentPage=self.scrollView.contentOffset.x/self.view.bounds.size.width;
}

-(UIButton*)doneBt{

    if (!_doneBt) {
        _doneBt=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2,SCREEN_HEIGHT-55, 150, 45)];
        [_doneBt setTitle:@"立即进入" forState:UIControlStateNormal];
        [_doneBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _doneBt.titleLabel.font=[UIFont systemFontOfSize:17];
        _doneBt.backgroundColor=[UIColor clearColor];
        _doneBt.layer.borderColor = [UIColor whiteColor].CGColor;
        _doneBt.layer.borderWidth = 1;
        _doneBt.layer.cornerRadius = 4;
        _doneBt.clipsToBounds = YES;
        [_doneBt addTarget:self action:@selector(donebutton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBt;
}

-(void)donebutton{
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"isdirect1"];//判断是否看过引导图
    BasetabbarViewController *wantVC = [[BasetabbarViewController alloc]init];
    CATransition *animation = [CATransition animation];
    animation.duration = 1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"SXcameraIrisHollowOpen";
    animation.type = kCATransitionFade;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:wantVC animated:NO completion:nil];
    
}

@end
