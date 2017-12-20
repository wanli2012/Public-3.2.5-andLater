//
//  GLHourseOptionCell.h
//  Universialshare
//
//  Created by 龚磊 on 2017/3/31.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLHourseOptionModel.h"
@protocol GLHourseOptionCellDelegete <NSObject>

-(void)btnindex:(int) tag;

@end
@interface GLHourseOptionCell : UITableViewCell
@property(nonatomic)float height;
@property(nonatomic)int seletIndex;
@property (nonatomic,retain) id<GLHourseOptionCellDelegete> delegate;


@property (nonatomic, strong)NSArray *arr;
@property (nonatomic, strong)NSString *typeName;

//@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)GLHourseOptionModel *model;

//-(instancetype)initWithFrame:(CGRect)frame andDatasource:(NSArray *)arr :(NSString *)typename;


@end
