
//
//  GLIntegralGoodsCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLIntegralGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "LBIntegralGoodsCollectionViewCell.h"
#import "LBCustomAttribuText.h"

@interface GLIntegralGoodsCell()<UICollectionViewDelegate,UICollectionViewDataSource,LBIntegralGoodsCollectionViewdelegete>
{
    LoadWaitView *_loadV;
}
@end

static NSString *ID = @"LBIntegralGoodsCollectionViewCell";
@implementation GLIntegralGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
     [self.collectionview registerNib:[UINib nibWithNibName:ID bundle:nil] forCellWithReuseIdentifier:ID];
   
}

#pragma UICollectionDelegate UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBIntegralGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.item][@"thumb"]] placeholderImage:nil];
    cell.name.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.item][@"goods_name"]];
    cell.infoLb.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.item][@"goods_info"]];
    
    NSString *priceAll = [NSString stringWithFormat:@"¥%@+%@米券",self.dataArr[indexPath.item][@"discount"],self.dataArr[indexPath.item][@"coupons"]];
 
    cell.price.attributedText = [LBCustomAttribuText originstr:priceAll specilstr:[NSString stringWithFormat:@"+%@米券",self.dataArr[indexPath.item][@"coupons"]] attribus:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
    
    
    cell.delegate = self;
    cell.index = indexPath.item;
    if ([self.dataArr[indexPath.item][@"is_collection"] integerValue] == 1) {
        cell.collectionBt.selected = YES;
    }else{
        cell.collectionBt.selected = NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate clickcheckDetail:self.dataArr[indexPath.item][@"goods_id"]];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 30)/3.0, (SCREEN_WIDTH - 30)/3.0 + 80);
    
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
    return 5.0f;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

-(void)clickcheckcollectionbutton:(NSInteger)index{

    if ([UserModel defaultUser].loginstatus == NO) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"请先去登录" duration:1 position:CSToastPositionCenter];
        return;
    }

    if ([self.dataArr[index][@"is_collection"] integerValue] == 1) {//已收藏
        [self cancelCollectionProduct:index];
    }else{//未收藏
        [self collectionProduct:index];
    }

}
//收藏
-(void)collectionProduct:(NSInteger)index{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"GID"] = self.dataArr[index][@"goods_id"];
    dict[@"type"] = @(1);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/addMyCollect" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){
            NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary:self.dataArr[index]];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.dataArr];
            
            [dic setValue:@(1) forKey:@"is_collection"];
            
            [arr replaceObjectAtIndex:index withObject:dic];
            
            self.dataArr = arr;
            
            [self.collectionview reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil]];
    
             [[UIApplication sharedApplication].keyWindow makeToast:@"收藏成功" duration:1 position:CSToastPositionCenter];
            
        }else{
            
             [[UIApplication sharedApplication].keyWindow makeToast:responseObject[@"message"] duration:1 position:CSToastPositionCenter];

        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络请求失败" duration:1 position:CSToastPositionCenter];
        
    }];

}
//取消收藏
-(void)cancelCollectionProduct:(NSInteger)index{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"GID"] = self.dataArr[index][@"goods_id"];
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/delMyCollect" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == 1){
            
            NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary:self.dataArr[index]];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.dataArr];
            
            [dic setValue:@(0) forKey:@"is_collection"];
            
            [arr replaceObjectAtIndex:index withObject:dic];
            
            self.dataArr = arr;
            
            [self.collectionview reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil]];
            [[UIApplication sharedApplication].keyWindow makeToast:@"取消收藏成功" duration:1 position:CSToastPositionCenter];
            
        }else{
            
            [[UIApplication sharedApplication].keyWindow makeToast:responseObject[@"message"] duration:1 position:CSToastPositionCenter];
        }
        
       
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络请求失败" duration:1 position:CSToastPositionCenter];
    }];
    
}

-(void)refreshDatasource:(NSArray *)arr{
    if (arr.count > 0) {
        self.goodOneH =  (SCREEN_WIDTH - 30)/3.0 + 80;
    }
    self.dataArr = arr;
    [self.collectionview reloadData];

}

-(NSArray*)dataArr{

    if (!_dataArr) {
        _dataArr = [NSArray array];
    }

    return _dataArr;
}

@end
