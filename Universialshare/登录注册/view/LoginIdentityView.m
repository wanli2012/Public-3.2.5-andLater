//
//  LoginIdentityView.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/24.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LoginIdentityView.h"
#import "GLLoginIdentityCell.h"

@interface LoginIdentityView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)UIView *footerView;

@property (nonatomic, strong)NSMutableArray *isSeleArr;//是否选中数组

@property (nonatomic, assign)NSInteger selectIndex;//选中的行 下标

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureBtnWidth;//确定按钮宽度

@end

@implementation LoginIdentityView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10.f;
    self.cancelBt.layer.cornerRadius = 5.f;
    self.sureBt.layer.cornerRadius = 5.f;
    
    self.selectIndex = 0;
    
    self.titleLabel.font = [UIFont systemFontOfSize:15 * autoSizeScaleX];
    [self.sureBt.titleLabel setFont:[UIFont systemFontOfSize:14 *autoSizeScaleX]];
    [self.cancelBt.titleLabel setFont:[UIFont systemFontOfSize:14 * autoSizeScaleX]];
    self.sureBtnWidth.constant = 100 * autoSizeScaleX;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLLoginIdentityCell" bundle:nil] forCellReuseIdentifier:@"GLLoginIdentityCell"];
}

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLLoginIdentityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLLoginIdentityCell"];
    cell.titleLabel.text = self.dataSoure[indexPath.row];
    cell.isSelec = [self.isSeleArr[indexPath.row] boolValue];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.block(indexPath.row);
    
    if (self.selectIndex == -1) {
        
        BOOL s = ![self.isSeleArr[indexPath.row] boolValue];
        
        [self.isSeleArr replaceObjectAtIndex:indexPath.row withObject:@(s)];
        
        self.selectIndex = indexPath.row;
        
    }else{
        
        if (self.selectIndex == indexPath.row) {
            return;
        }
        
        BOOL a=[self.isSeleArr[indexPath.row]boolValue];
        [self.isSeleArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!a]];
        [self.isSeleArr replaceObjectAtIndex:self.selectIndex withObject:[NSNumber numberWithBool:NO]];
        self.selectIndex = indexPath.row;
        
    }

    [self.tableView reloadData];
}

- (NSMutableArray *)isSeleArr{
    
    if (!_isSeleArr) {
        
        _isSeleArr = [NSMutableArray array];
        
        for (int i = 0; i < self.dataSoure.count; i ++) {
            
            if(i == 0){
                [self.isSeleArr addObject:@YES];//默认选中会员
            }else{
                [self.isSeleArr addObject:@NO];
            }
        }
        
    }
    return _isSeleArr;
}
@end
