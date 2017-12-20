//
//  LBFilterMallShopViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/10/12.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBFilterMallShopViewController.h"
#import "LBFilterMallShopCollectionViewCell.h"
#import "LBFilterMailShopCollectionReusableView.h"
#import "GLClassifyModel.h"
#import "InvestmentFilterPresentationController.h"

@interface LBFilterMallShopViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (assign , nonatomic)NSInteger isLastrow;//记录上次的选中按钮 默认为-1；
@property (assign , nonatomic)NSInteger isLastsection;//记录上次的选中按钮 默认为-1；

@end

//设置标识
static NSString *LBFilterMailShopView = @"LBFilterMailShopCollectionReusableView";
static NSString *LBFilterMallShopCell = @"LBFilterMallShopCollectionViewCell";

@implementation LBFilterMallShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isLastrow = -1;
    _isLastsection = -1;
#pragma mark -- 注册单元格
    [_collectionview registerNib:[UINib nibWithNibName:LBFilterMallShopCell bundle:nil] forCellWithReuseIdentifier:LBFilterMallShopCell];
#pragma mark -- 注册头部视图
    [_collectionview registerNib:[UINib nibWithNibName:LBFilterMailShopView bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:LBFilterMailShopView];
    
    if (self.models.count <= 0 ) {
        [self getMarkGoodsType];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    
}

- (void)getMarkGoodsType {
    
    //请求数据
    [NetworkManager requestPOSTWithURLStr:@"Shop/getMarkGoodsCate" paramDic:@{} finish:^(id responseObject) {
        
        if ([responseObject[@"code"] integerValue] == 1){
            [self.models removeAllObjects];
            
            if ([[NSString stringWithFormat:@"%@",responseObject[@"data"]] rangeOfString:@"null"].location == NSNotFound ) {
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    GLClassifyModel *model = [GLClassifyModel mj_objectWithKeyValues:dic];
                    [self.models addObject:model];
                    
                }
            }
            
        }else{
        [self.view.window makeToast:responseObject[@"message"] duration:1 position:CSToastPositionCenter];
        
        }
        
        [self.collectionview reloadData];
        
    } enError:^(NSError *error) {
         [self.view.window makeToast:@"网络请求失败" duration:1 position:CSToastPositionCenter];
    }];
}


#pragma UICollectionDelegate UICollectionDataSource
//有多少个Section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.models.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    GLClassifyModel *model = self.models[section];
    return model.son.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LBFilterMallShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LBFilterMallShopCell forIndexPath:indexPath];
     GLClassifyModel *model = self.models[indexPath.section];
    cell.model = model.son[indexPath.row];
    
    if (cell.model.iscollection) {
        _isLastsection = indexPath.section;
        _isLastrow = indexPath.row;
    }
    
    return cell;
}

//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView =nil;
    
    if (kind ==UICollectionElementKindSectionHeader) {
        //定制头部视图的内容
        LBFilterMailShopCollectionReusableView *headerV = (LBFilterMailShopCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:LBFilterMailShopView forIndexPath:indexPath];
               headerV.model = self.models[indexPath.section];
        
        reusableView = headerV;
    }
    
        return reusableView;
}

//这个方法是返回 Header的大小 size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return CGSizeMake(self.view.width, 35);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isLastrow == -1) {
        GLClassifyModel *model = self.models[indexPath.section];
        LBclassifyTypeModel *typemodel = model.son[indexPath.row];
        typemodel.iscollection = !typemodel.iscollection;
         [self.collectionview reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section], nil]];
        NSString *namestr = [NSString string];
        if ([typemodel.catename isEqualToString:@"全部"]) {
            namestr = model.catename;
        }else{
            namestr = typemodel.catename;
        }
        if (self.refreshClassifyData) {
            self.refreshClassifyData(typemodel.cate_id,namestr);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"dismissnvestmentFilter" object:nil];
        }
    }else{
        GLClassifyModel *model = self.models[indexPath.section];
        LBclassifyTypeModel *typemodel = model.son[indexPath.row];
        GLClassifyModel *model1 = self.models[_isLastsection];
        LBclassifyTypeModel *typemodel1 = model1.son[_isLastrow];
        typemodel.iscollection = !typemodel.iscollection;
        typemodel1.iscollection = !typemodel1.iscollection;
        if (indexPath.section == _isLastsection && indexPath.row == _isLastrow) {
            NSString *namestr = [NSString string];
            if ([typemodel.catename isEqualToString:@"全部"]) {
                namestr = model.catename;
            }else{
                namestr = typemodel.catename;
            }
            if (self.refreshClassifyData) {
                self.refreshClassifyData(typemodel1.cate_id,namestr);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"dismissnvestmentFilter" object:nil];
            }
            return;
        }
        
        [self.collectionview reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section], nil]];
        [self.collectionview reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_isLastrow inSection:_isLastsection], nil]];
        NSString *namestr = [NSString string];
        if ([typemodel.catename isEqualToString:@"全部"]) {
            namestr = model.catename;
        }else{
            namestr = typemodel.catename;
        }
        if (self.refreshClassifyData) {
            self.refreshClassifyData(model1.cate_id,namestr);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"dismissnvestmentFilter" object:nil];
        }
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((self.view.width - 23)/3, 40);
    
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
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
//返回
- (IBAction)backEvent:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dismissnvestmentFilter" object:nil];
}
//重置
- (IBAction)reSetupEvent:(UIButton *)sender {
    if (_isLastrow != -1) {
        GLClassifyModel *model = self.models[_isLastsection];
        LBclassifyTypeModel *typemodel = model.son[_isLastrow];
        typemodel.iscollection = NO;
        [self.collectionview reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_isLastrow inSection:_isLastsection], nil]];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dismissnvestmentFilter" object:nil];
    if (self.refreshClassifyData) {
        self.refreshClassifyData(@"",@"筛选");
    }
    _isLastrow = -1;
    _isLastsection = -1;
}

- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}
@end
