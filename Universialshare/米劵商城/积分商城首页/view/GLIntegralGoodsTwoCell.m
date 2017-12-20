//
//  GLIntegralGoodsTwoCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIntegralGoodsTwoCell.h"
#import "LBIntegralGoodsOneCollectionViewCell.h"
#import "LBCustomAttribuText.h"

@interface GLIntegralGoodsTwoCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionV;


@end

static NSString *ID = @"LBIntegralGoodsOneCollectionViewCell";
@implementation GLIntegralGoodsTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
     [self.collectionV registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBIntegralGoodsOneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    [cell.imagev sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.item][@"thumb"]] placeholderImage:nil];
    
    cell.nameLb.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.item][@"goods_name"]];
    NSString *priceAll = [NSString stringWithFormat:@"¥%@+%@米券",self.dataArr[indexPath.item][@"discount"],self.dataArr[indexPath.item][@"coupons"]];
    cell.priceLb.attributedText = [LBCustomAttribuText originstr:priceAll specilstr:[NSString stringWithFormat:@"+%@米券",self.dataArr[indexPath.item][@"coupons"]] attribus:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate clickCheckGoodsinfo:self.dataArr[indexPath.item][@"goods_id"]];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 30)/3.0, (SCREEN_WIDTH - 30)/3.0 + 50);
    
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

-(void)refreshdataSource:(NSArray *)arr{
    if ([arr count] > 0) {
        self.beautfHeight = ((SCREEN_WIDTH - 30)/3 + 60) * (([arr count]  - 1) / 3 + 1) + 5;
    }
    self.dataArr = arr;
    [self.collectionV reloadData];

}

-(NSArray*)dataArr{

    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}


@end
