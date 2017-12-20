//
//  MinePhoneAlertView.m
//  AngelComing
//
//  Created by sm on 16/12/1.
//  Copyright © 2016年 ruichikeji. All rights reserved.
//

#import "MinePhoneAlertView.h"
#import "ScaleSizeImage.h"
@implementation MinePhoneAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.base.layer.cornerRadius=8;
    self.base.clipsToBounds=YES;


     self.HxuxianV.image=[ScaleSizeImage drawXLine:self.HxuxianV Dsize:CGSizeMake(100, 1) Drect:CGRectMake(0, 0, 100, 1) startPoint:CGPointMake(0, 0) endPoint:CGPointMake(100, 0) index:2];
    
    self.VxuxianV.image=[ScaleSizeImage drawXLine:self.VxuxianV Dsize:CGSizeMake(1, 20) Drect:CGRectMake(0, 0, 1, 20) startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 20) index:2];
    
}



@end
