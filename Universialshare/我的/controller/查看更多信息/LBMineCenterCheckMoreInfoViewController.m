//
//  LBMineCenterCheckMoreInfoViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/30.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMineCenterCheckMoreInfoViewController.h"
#import "LBMineCenterMoreInfoCollectionViewCell.h"

@interface LBMineCenterCheckMoreInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic)NSArray *titleArr;
@property (strong, nonatomic)NSArray *imageArr;
@property (strong, nonatomic)NSArray *valueArr;

@end

@implementation LBMineCenterCheckMoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"更多";
    [self.collectionView registerNib:[UINib nibWithNibName:@"LBMineCenterMoreInfoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LBMineCenterMoreInfoCollectionViewCell"];
     [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    
    NSString  *meeple =  [NSString stringWithFormat:@"%@",[UserModel defaultUser].meeple];//米宝
    
    if ([meeple rangeOfString:@"null"].location != NSNotFound || meeple.length <= 0) {
        
        [UserModel defaultUser].meeple = @"0.00";
    }
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

     return self.titleArr.count;

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.titleArr[section]count];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCenterMoreInfoCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"LBMineCenterMoreInfoCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    cell.titileLb.text = self.titleArr[indexPath.section][indexPath.row];
    cell.imagev.image = [UIImage imageNamed:self.imageArr[indexPath.section][indexPath.row]];
    if ([cell.titileLb.text isEqualToString:@"上个奖励日"]) {
         cell.valueLb.text = [NSString stringWithFormat:@"%@",self.valueArr[indexPath.section][indexPath.row]];
    }else{
        cell.valueLb.text = [NSString stringWithFormat:@"%.2f",[self.valueArr[indexPath.section][indexPath.row] floatValue]];
    }
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        reusableView = footerview;
    }

    return reusableView;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{

    return CGSizeMake(SCREEN_WIDTH, 10);
}

//UICollectionViewCell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(SCREEN_WIDTH, 54);
    
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}

-(NSArray*)titleArr{
    
    if (!_titleArr) {
        
        if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
            
            _titleArr=[NSArray arrayWithObjects:@[@"米子",@"米分",@"米券",@"米宝"],@[@"每日剩余额度",@"每日总额度",@"每单额度"],@[@"推荐奖励",@"上个奖励日"],nil];
            
        }else if([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]){
            
            _titleArr=[NSArray arrayWithObjects:@[@"米子",@"米分",@"米券",@"米宝"],@[@"活跃米分",@"冻结米分"],@[@"推荐奖励",@"上个奖励日"], nil];
        }else{
            
            _titleArr=[NSArray arrayWithObjects:@[@"米子",@"米分",@"米券",@"米宝"],@[@"推荐奖励",@"上个奖励日"], nil];
        }
    }
    
    return _titleArr;
    
}
-(NSArray*)imageArr{
    
    if (!_imageArr) {
        
        if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
            
            _imageArr=[NSArray arrayWithObjects:@[@"mizi",@"fen",@"minecard",@"米宝"],@[@"每日剩余额度",@"每日总额度",@"每单额度"],@[@"推荐奖励",@"更多-上个奖励日"],nil];
            
        }else if([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]){
            
            _imageArr=[NSArray arrayWithObjects:@[@"mizi",@"fen",@"minecard",@"米宝"],@[@"huoyue",@"dongjie"],@[@"推荐奖励",@"更多-上个奖励日"], nil];
        }else{
            
            _imageArr=[NSArray arrayWithObjects:@[@"mizi",@"fen",@"minecard",@"米宝"],@[@"推荐奖励",@"更多-上个奖励日"], nil];
        }
    }
    
    return _imageArr;
    
}

-(NSArray*)valueArr{
    
    if (!_valueArr) {
        
        if ([[UserModel defaultUser].usrtype isEqualToString:Retailer]) {
            
            _valueArr=[NSArray arrayWithObjects:@[[UserModel defaultUser].ketiBean,[UserModel defaultUser].loveNum,[UserModel defaultUser].mark,[UserModel defaultUser].meeple],@[[UserModel defaultUser].surplusLimit,[UserModel defaultUser].allLimit,[UserModel defaultUser].single],@[[UserModel defaultUser].recommendMark,[UserModel defaultUser].lastFanLiTime],nil];
            
        }else if([[UserModel defaultUser].usrtype isEqualToString:OrdinaryUser]){
            
            _valueArr=[NSArray arrayWithObjects:@[[UserModel defaultUser].ketiBean,[UserModel defaultUser].loveNum,[UserModel defaultUser].mark,[UserModel defaultUser].meeple],@[[UserModel defaultUser].activation_mark,[UserModel defaultUser].frozen_mark],@[[UserModel defaultUser].recommendMark,[UserModel defaultUser].lastFanLiTime], nil];
        }else{
            
            _valueArr=[NSArray arrayWithObjects:@[[UserModel defaultUser].ketiBean,[UserModel defaultUser].loveNum,[UserModel defaultUser].mark,[UserModel defaultUser].meeple],@[[UserModel defaultUser].recommendMark,[UserModel defaultUser].lastFanLiTime], nil];
        }
    }
    
    return _valueArr;
    
}


@end
