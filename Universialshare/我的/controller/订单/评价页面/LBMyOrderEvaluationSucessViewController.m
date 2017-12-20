//
//  LBMyOrderEvaluationSucessViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/10.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyOrderEvaluationSucessViewController.h"
#import "LBMyOrderEveluationSucessCollectionViewCell.h"
#import "LBMyOrderEveluationSucessOneCollectionViewCell.h"

@interface LBMyOrderEvaluationSucessViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collection;


@end

@implementation LBMyOrderEvaluationSucessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"评价成功";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUpCollectionView];
    
    
}
#pragma mark - ******* Methods *******

-(void)setUpCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collection.collectionViewLayout = layout;
    _collection.showsVerticalScrollIndicator = NO;
    _collection.backgroundColor = [UIColor clearColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    [_collection registerNib:[UINib nibWithNibName:@"LBMyOrderEveluationSucessCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:@"LBMyOrderEveluationSucessCollectionViewCell"];
    
    [_collection registerNib:[UINib nibWithNibName:@"LBMyOrderEveluationSucessOneCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:@"LBMyOrderEveluationSucessOneCollectionViewCell"];
    
    
}
#pragma mark - ******* UICollectionViewDelegate,UICollectionViewDataSource *******

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        LBMyOrderEveluationSucessOneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBMyOrderEveluationSucessOneCollectionViewCell" forIndexPath:indexPath];
        
        return cell;
    }else{
        LBMyOrderEveluationSucessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBMyOrderEveluationSucessCollectionViewCell" forIndexPath:indexPath];
        
        
        return cell;
    
    }
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//UICollectionViewCell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return CGSizeMake(SCREEN_WIDTH, 200);
    }else{
        return CGSizeMake((SCREEN_WIDTH-1)/2, 200);
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
}


@end
