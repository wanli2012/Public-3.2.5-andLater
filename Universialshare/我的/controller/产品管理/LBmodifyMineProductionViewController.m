//
//  LBAddMineProductionViewController.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/5/15.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBmodifyMineProductionViewController.h"
#import "editorMaskPresentationController.h"
#import "LBAddrecomdManChooseAreaViewController.h"
#import "QQTagView.h"
#import <SDWebImage/UIView+WebCache.h>

@interface LBmodifyMineProductionViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,UITextFieldDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,QQTagViewDelegate>
{
    BOOL      _ishidecotr;//判断是否隐藏弹出控制器
    LoadWaitView *_loadV;
    NSMutableArray *_tags;
    NSMutableArray *_tag_ids;
    QQTagView *_tagView;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViwH;
@property (weak, nonatomic) IBOutlet UITextField *riceTf;

@property (weak, nonatomic) IBOutlet UIButton *submitBt;//提交
@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (strong, nonatomic)NSMutableArray *imageArr;
@property (strong, nonatomic)NSMutableArray *titleArr;
@property (assign, nonatomic)NSInteger deleteImageIndex;//删除图片

@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UIButton *selectBtOne;
@property (weak, nonatomic) IBOutlet UIButton *selectBtTwo;
@property (weak, nonatomic) IBOutlet UIButton *selectBtThree;
@property (weak, nonatomic) IBOutlet UIButton *selectBtFour;

@property (weak, nonatomic) IBOutlet UITextField *UnitPriceTf;
@property (weak, nonatomic) IBOutlet UITextView *productdesTv;
@property (weak, nonatomic) IBOutlet UITextField *numTf;

@property (weak, nonatomic) IBOutlet UITextField *freightTf;
@property (weak, nonatomic) IBOutlet UITextField *favorablePriceTf;
@property (weak, nonatomic) IBOutlet UITextField *SpecificationsTf;//商品规格

@property (assign, nonatomic)NSInteger stype;//分红类型
@property (assign, nonatomic)NSInteger indexShelves;//是否上架

//行业
@property (nonatomic, strong)NSMutableArray *industryArr;//分类
@property (nonatomic, strong)NSMutableArray *goodsArr;//属性
@property (nonatomic, assign)NSInteger isChoseFirstClassify;//记录一级分类的第几行
@property (nonatomic, assign)NSInteger isChoseSecondClassify;//记录二级分类的第几行
@property (weak, nonatomic) IBOutlet UILabel *oneClassifyLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoClassifyLabel;
//属性View
@property (weak, nonatomic) IBOutlet UIView *shuxingView;

@property (strong, nonatomic)UIView *incentiveModelMaskV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shuxingViewHeight;

@property (nonatomic, assign)CGRect shuxingSize;
@property (nonatomic, strong)NSMutableArray *selectedTagIds;

@property (strong, nonatomic)NSString *one_cate_id;
@property (strong, nonatomic)NSString *two_cate_id;

@end

@implementation LBmodifyMineProductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"商品详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titleArr = [NSMutableArray arrayWithObjects:@"one",@"two",@"three", nil];
    
    self.shuxingSize = CGRectZero;
    
    self.indexShelves = 1;
    
    if ([self.datadic[@"sh_status"]integerValue] == 3) {//审核中
        [self.submitBt setTitle:@"审核中" forState:UIControlStateNormal];
        self.submitBt.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.submitBt.userInteractionEnabled = NO;
    }
    
    [self refreshimageview];
    [self getPickerData];
}
#pragma mark - get data
- (void)getPickerData {
    //分类列表
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:@"Shop/getGoodsCate" paramDic:dict finish:^(id responseObject) {
        //[_loadV removeloadview];
        if ([responseObject[@"code"] integerValue]==1) {
            self.industryArr = responseObject[@"data"];
            
            if (self.two_cate_id != nil && self.one_cate_id != nil) {//根据获取的id判断在第几行
                for (int i = 0; i < self.industryArr.count; i++) {
                    if ([self.one_cate_id isEqualToString:self.industryArr[i][@"cate_id"] ]) {
                        _isChoseFirstClassify = i;
                    }
                    
                    for (int j = 0; j < [self.industryArr[i][@"son"]count]; j++) {
                        if ([self.two_cate_id isEqualToString:self.industryArr[i][@"son"][j][@"cate_id"] ]) {
                            _isChoseSecondClassify = j;
                        }
                    }
                }
            }
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        //[_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
 
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"goods_id"] = self.datadic[@"goods_id"];
 
    [NetworkManager requestPOSTWithURLStr:@"Shop/getShopGoodsDetail" paramDic:dict1 finish:^(id responseObject) {
       [_loadV removeloadview];

        if ([responseObject[@"code"] integerValue]== 1) {
            
            [self assignment:responseObject[@"data"]];
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
       [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}
//赋值
-(void)assignment:(NSDictionary*)dic{

    self.nameTf.text = [NSString stringWithFormat:@"%@",dic[@"goods_name"]];
    self.stype = [dic[@"rlmode_id"]integerValue];
    if (self.stype == 1) {
        [self.selectBtOne setImage:[UIImage imageNamed:@"添加产品选中"] forState:UIControlStateNormal];
        [self.selectBtTwo setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
        [self.selectBtThree setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
        [self.selectBtFour setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
    }else if (self.stype == 2) {
        [self.selectBtOne setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
        [self.selectBtTwo setImage:[UIImage imageNamed:@"添加产品选中"] forState:UIControlStateNormal];
        [self.selectBtThree setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
        [self.selectBtFour setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
    }else if (self.stype == 3) {
        [self.selectBtOne setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
        [self.selectBtTwo setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
        [self.selectBtThree setImage:[UIImage imageNamed:@"添加产品选中"] forState:UIControlStateNormal];
        [self.selectBtFour setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
    }else if (self.stype == 4) {
        [self.selectBtOne setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
        [self.selectBtTwo setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
        [self.selectBtThree setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
        [self.selectBtFour setImage:[UIImage imageNamed:@"添加产品选中"] forState:UIControlStateNormal];
    }
    
    self.UnitPriceTf.text = [NSString stringWithFormat:@"%@",dic[@"goods_price"]];
    self.productdesTv.text = [NSString stringWithFormat:@"%@",dic[@"goods_info"]];
    self.oneClassifyLabel.text = [NSString stringWithFormat:@"%@",dic[@"one_cate_id"][@"name"]];
     self.twoClassifyLabel.text = [NSString stringWithFormat:@"%@",dic[@"two_cate_id"][@"name"]];
    self.one_cate_id = [NSString stringWithFormat:@"%@",dic[@"one_cate_id"][@"id"]];
    self.two_cate_id = [NSString stringWithFormat:@"%@",dic[@"two_cate_id"][@"id"]];
    
    if (self.two_cate_id != nil && self.one_cate_id != nil) {//根据获取的id判断在第几行
        for (int i = 0; i < self.industryArr.count; i++) {
            if ([self.one_cate_id isEqualToString:self.industryArr[i][@"cate_id"] ]) {
                _isChoseFirstClassify = i;
            }
            
            for (int j = 0; j < [self.industryArr[i][@"son"]count]; j++) {
                if ([self.two_cate_id isEqualToString:self.industryArr[i][@"son"][j][@"cate_id"] ]) {
                    _isChoseSecondClassify = j;
                }
            }
        }
    }
    
    _tagView = [[QQTagView alloc] init];
    _tagView.frame = CGRectMake(80, 10, SCREEN_WIDTH - 80, 0);
    _tagView.delegate = self;
    _tagView.tag = 1;
    _tags = [NSMutableArray array];
    _tag_ids = [NSMutableArray array];
   [_tagView addTags:dic[@"attr_info"] tag_ids:dic[@"attr_all_id"] selectArr:dic[@"attr_id"] ];
    [self.shuxingView addSubview:_tagView];
    
    [self.selectedTagIds addObjectsFromArray:dic[@"attr_id"]];
    
    self.numTf.text = [NSString stringWithFormat:@"%@",dic[@"goods_num"]];
    self.freightTf.text = [NSString stringWithFormat:@"%@",dic[@"send_price"]];
    self.favorablePriceTf.text = [NSString stringWithFormat:@"%@",dic[@"discount"]];
    self.SpecificationsTf.text = [NSString stringWithFormat:@"%@",dic[@"spec_info"]];
    self.riceTf.text = [NSString stringWithFormat:@"%@",dic[@"coupons"]];
    
    [self.imageArr insertObjects:dic[@"thumb_url"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [dic[@"thumb_url"]count])]];
    [self refreshimageview];
    
}
- (void)QQTagView:(QQTagView *)QQTagView QQTagItem:(QQTagItem *)QQTagItem
{
    
    if (QQTagItem.Style == QQTagStyleSlect) {
        
        [self.selectedTagIds addObject:[NSString stringWithFormat:@"%ld",(long)QQTagItem.tag]];
        
    }else{
        
        [self.selectedTagIds removeObject:[NSString stringWithFormat:@"%lu",(long)QQTagItem.tag]];
        
    }
    

}
- (void)QQTagView:(QQTagView *)QQTagView sizeChange:(CGRect)newSize
{
    self.shuxingViewHeight.constant = newSize.size.height + 30;
    self.shuxingSize = newSize;

    if (self.imageArr.count > 3) {
        self.imageViwH.constant = 210;
        self.contentH.constant = 1010 + 110;
        if (self.shuxingSize.size.height) {
            self.imageViwH.constant = 210;
            self.contentH.constant = 1010 + 110 + self.shuxingSize.size.height + 30;
            
        }
    }else{
        self.imageViwH.constant = 210;
        self.contentH.constant = 1010;
        if (self.shuxingSize.size.height) {
            self.imageViwH.constant = 210;
            self.contentH.constant = 1010 + self.shuxingSize.size.height + 30;
            
        }
    }

}
//选择20%
- (IBAction)tappercentTweTy:(UITapGestureRecognizer *)sender {
     self.stype = 1;
    [self.selectBtOne setImage:[UIImage imageNamed:@"添加产品选中"] forState:UIControlStateNormal];
    [self.selectBtTwo setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
    [self.selectBtThree setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
    [self.selectBtFour setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
    
}
//选择10%
- (IBAction)tapgestureTen:(UITapGestureRecognizer *)sender {
     self.stype = 2;
    [self.selectBtOne setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
    [self.selectBtTwo setImage:[UIImage imageNamed:@"添加产品选中"] forState:UIControlStateNormal];
    [self.selectBtThree setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
    [self.selectBtFour setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
}
//选择5%
- (IBAction)tapgestureFive:(UITapGestureRecognizer *)sender {
     self.stype = 3;
    [self.selectBtOne setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
    [self.selectBtTwo setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
    [self.selectBtThree setImage:[UIImage imageNamed:@"添加产品选中"] forState:UIControlStateNormal];
    [self.selectBtFour setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
}
//选择3%
- (IBAction)tapgestureThree:(UITapGestureRecognizer *)sender {
    self.stype = [KThreePersent integerValue];
    [self.selectBtOne setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
    [self.selectBtTwo setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
    [self.selectBtThree setImage:[UIImage imageNamed:@"添加产品未选中"] forState:UIControlStateNormal];
    [self.selectBtFour setImage:[UIImage imageNamed:@"添加产品选中"] forState:UIControlStateNormal];

}
//一级分类选择
- (IBAction)oneClassifyChoose:(id)sender {
     [self.view endEditing:YES];
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    if (self.industryArr.count != 0) {
        
        vc.provinceArr = self.industryArr;
        vc.titlestr = @"请选择一级分类";
        vc.returnreslut = ^(NSInteger index){
            _isChoseFirstClassify = index;
            _oneClassifyLabel.text = _industryArr[index][@"catename"];
            _oneClassifyLabel.textColor = [UIColor blackColor];
            _twoClassifyLabel.text = @"请选择二级分类";
            
        };
        vc.transitioningDelegate=self;
        vc.modalPresentationStyle=UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [MBProgressHUD showError:@"一级分类暂无数据"];
    }

}
//二级分类选择
- (IBAction)twoClassifyChoose:(id)sender {
     [self.view endEditing:YES];
    if ([self.oneClassifyLabel.text isEqualToString:@"请选择一级分类"]) {
        [MBProgressHUD showError:@"请选择一级分类"];
        return;
    }
    
    LBAddrecomdManChooseAreaViewController *vc=[[LBAddrecomdManChooseAreaViewController alloc]init];
    
    NSArray *arr = self.industryArr[_isChoseFirstClassify][@"son"];
    if(arr.count != 0){
        
        vc.provinceArr = self.industryArr[_isChoseFirstClassify][@"son"];
        vc.titlestr = @"请选择二级分类";
        vc.returnreslut = ^(NSInteger index){
            _isChoseSecondClassify = index;
            NSArray *son = _industryArr[_isChoseFirstClassify][@"son"];
            if (son.count == 0) {
                _twoClassifyLabel.text = @"";
            }else{
                
                _twoClassifyLabel.text = _industryArr[_isChoseFirstClassify][@"son"][index][@"catename"];
            }
            _twoClassifyLabel.textColor = [UIColor blackColor];
            
        };
        
        vc.transitioningDelegate=self;
        vc.modalPresentationStyle=UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [MBProgressHUD showError:@"二级分类暂无数据"];
    }

}

- (IBAction)isShelvesEvent:(UISwitch *)sender {
    
    if (sender.isOn) {
        self.indexShelves = 1;
    }else{
       self.indexShelves = 2;
    
    }
    
}
//提交
- (IBAction)submitinfomation:(UIButton *)sender {
     [self.view endEditing:YES];
    if (self.nameTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入商品名"];
        return;
    }
    if (self.UnitPriceTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入商品单价"];
        return;
    }
    if (self.productdesTv.text.length <= 0) {
        [MBProgressHUD showError:@"请输入商品描述"];
        return;
    }
    if (self.oneClassifyLabel.text.length <= 0 || [self.oneClassifyLabel.text isEqualToString:@"请选择一级分类"]) {
        [MBProgressHUD showError:@"请选择一级分类"];
        return;
    }
    if (self.twoClassifyLabel.text.length <= 0 || [self.twoClassifyLabel.text isEqualToString:@"请选择二级分类"]) {
        [MBProgressHUD showError:@"请选择二级分类"];
        return;
    }
    if (self.numTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入商品库存"];
        return;
    }
    if (self.freightTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入运费"];
        return;
    }
    if (self.favorablePriceTf.text.length <= 0) {
        [MBProgressHUD showError:@"请输入优惠价格"];
        return;
    }
    if (self.SpecificationsTf.text.length <= 0) {
        [MBProgressHUD showError:@"请简单描述商品规格"];
        return;
    }
    if (self.imageArr.count <= 1) {
        [MBProgressHUD showError:@"至少上传一张图片"];
        return;
    }
    if ([self.riceTf.text floatValue] > [self.UnitPriceTf.text floatValue]) {
        [MBProgressHUD showError:@"抵消米券不能大于单价"];
        return;
    }
    
    NSString *cate_id = [NSString stringWithFormat:@"%@,%@",self.industryArr[self.isChoseFirstClassify][@"cate_id"],_industryArr[_isChoseFirstClassify][@"son"][_isChoseSecondClassify][@"cate_id"]];
    
    NSMutableString *attr_id = [[NSMutableString alloc] init];
    if (self.selectedTagIds.count <= 0) {
        [MBProgressHUD showError:@"请选择属性"];
        return;
    }else{
        [attr_id appendString:self.selectedTagIds[0]];
        for (int i = 1; i < self.selectedTagIds.count; i++) {
//            [attr_id appendString:[NSString stringWithFormat:@",%@",self.selectedTagIds[i]]];
            [attr_id appendFormat:@",%@",self.selectedTagIds[i]];
        }
    }
    
    NSMutableArray *urlArr =[NSMutableArray array];

    for (int i = 0; i < _imageArr.count; i++) {
        
        if ([self.imageArr[i] isKindOfClass:[NSString class]]) {
            if ([self.imageArr[i] hasPrefix:@"https://"]) {
                 [urlArr addObject:_imageArr[i]];
            }
        }
        
    }
    
    NSString *urlStr = [urlArr componentsJoinedByString:@","];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"]=[UserModel defaultUser].uid;
    dict[@"token"]=[UserModel defaultUser].token;
    dict[@"goods_name"]=self.nameTf.text;
    dict[@"rl_type_id"]=[NSNumber numberWithInteger:self.stype];
    dict[@"goods_info"]=self.productdesTv.text;
    dict[@"status"]=[NSNumber numberWithInteger:self.indexShelves];
    dict[@"price"]=self.UnitPriceTf.text;
    dict[@"discount"]=self.favorablePriceTf.text;
    dict[@"sendPrice"]=self.freightTf.text;
    dict[@"total_num"]=self.numTf.text;
    dict[@"spec_info"]=self.SpecificationsTf.text;
    dict[@"cate_id"]=cate_id;
    dict[@"attr_id"]=attr_id;
    dict[@"count"]=[NSNumber numberWithInteger:self.imageArr.count - 1];
    dict[@"goods_id"]=self.datadic[@"goods_id"];
    dict[@"pic_arr"]=urlStr;
    dict[@"app_version"] = APP_VERSION;
    dict[@"version"] = @"3";
    if (self.riceTf.text.length <= 0) {
        dict[@"coupons"]=@(0);
        dict[@"rice"]=@([self.favorablePriceTf.text floatValue] );
    }else{
        dict[@"coupons"]=self.riceTf.text;
        dict[@"rice"]=@([self.favorablePriceTf.text floatValue] - [self.riceTf.text floatValue]);
    }
     _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    _loadV.isTap = NO;
    self.submitBt.userInteractionEnabled = NO;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.requestSerializer.timeoutInterval = 20;
    // 加上这行代码，https ssl 验证。
    [manager setSecurityPolicy:[NetworkManager customSecurityPolicy]];
    [manager POST:[NSString stringWithFormat:@"%@Shop/updateGoodsData",URL_Base] parameters:dict  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //将图片以表单形式上传
        
        for (int i = 0; i < self.imageArr.count - 1; i ++) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@%d.png",str,i];
            if ([self.imageArr[i] isKindOfClass:[NSData class]]) {
                   [formData appendPartWithFileData:self.imageArr[i] name:[NSString stringWithFormat:@"%d",i] fileName:fileName mimeType:@"image/png"];
            }
            
        }
        
    }progress:^(NSProgress *uploadProgress){
                
    }success:^(NSURLSessionDataTask *task, id responseObject) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([dic[@"code"]integerValue]==1) {
            
            [MBProgressHUD showError:dic[@"message"]];
            if (self.refreshData) {
                self.refreshData();
            }
             [[NSNotificationCenter defaultCenter]postNotificationName:@"addproduct" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:dic[@"message"]];
        }
         [_loadV removeloadview];
         self.submitBt.userInteractionEnabled = YES;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      self.submitBt.userInteractionEnabled = YES;
         [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
    }];

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == self.nameTf && [string isEqualToString:@"\n"]) {
        [self.UnitPriceTf becomeFirstResponder];
        return NO;
    }
    
    if (textField == self.SpecificationsTf && [string isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
        return NO;
    }

    return YES;

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if (textView == self.productdesTv && [text isEqualToString:@"\n"]) {
        [self.numTf becomeFirstResponder];
        return NO;
    }

    return YES;

}

-(void)refreshimageview{

    for (int j = 0 ; j < self.imageView.subviews.count; j++) {
        UIImageView  *imagev = [self.imageView viewWithTag:j+1];
        imagev.hidden = YES;
        
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapgestureImagev:)];
        UILongPressGestureRecognizer *longgestureimagev = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longgestureimagev:)];
        [imagev addGestureRecognizer:tapgesture];
        [imagev addGestureRecognizer:longgestureimagev];
        
    }
    
    for (int i = 0 ; i < self.imageArr.count; i++) {
        
        UIImageView  *imagev = [self.imageView viewWithTag:i+1];
        imagev.hidden = NO;
        
        if (i == self.imageArr.count-1) {
            imagev.image=[UIImage imageNamed:self.imageArr[i]];
        }else{
            if ( [self.imageArr[i] isKindOfClass:[NSData class]]) {
                imagev.image = [UIImage imageWithData:self.imageArr[i]];
               
            }else
                [imagev sd_setImageWithURL:[NSURL URLWithString:self.imageArr[i] ] placeholderImage:[UIImage imageNamed:@"商户暂位图"]];
           }
        }

    if (self.imageArr.count > 3) {
        self.imageViwH.constant = 210;
        self.contentH.constant = 1010 + 110;
        if (self.shuxingSize.size.height) {
            self.imageViwH.constant = 210;
            self.contentH.constant = 1010 + 110 + self.shuxingSize.size.height + 30;

        }
    }else{
        self.imageViwH.constant = 210;
        self.contentH.constant = 1010;
        if (self.shuxingSize.size.height) {
            self.imageViwH.constant = 210;
            self.contentH.constant = 1010 + self.shuxingSize.size.height + 30;
            
        }
    }

}

-(void)tapgestureImagev:(UITapGestureRecognizer*)gesture{

    UIImageView *imaev = (UIImageView*)gesture.view;
    
    if (imaev.tag == self.imageArr.count) {
        if (self.imageArr.count == 4) {
            [MBProgressHUD showError:@"最多只能上传3张"];
            return;
        }
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"去相册选择",@"用相机拍照", nil];
        [actionSheet showInView:self.view];
    }

}

-(void)longgestureimagev:(UILongPressGestureRecognizer*)longgesture{

     UIImageView *imaev = (UIImageView*)longgesture.view;
    self.deleteImageIndex = imaev.tag - 1;
    if (longgesture.state ==  UIGestureRecognizerStateBegan) {
        
        if (imaev.tag != self.imageArr.count) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您确定要删除该图片吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 10;
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {

        if (alertView.tag == 10) {
            [self.imageArr removeObjectAtIndex:self.deleteImageIndex];
            [self refreshimageview];
            
        }

        
    }
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [self getpicture];//获取相册
        }break;
            
        case 1:{
            [self getcamera];//获取照相机
        }break;
        default:
            break;
    }
}

-(void)getpicture{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //    // 设置选择后的图片可以被编辑
    //    picker.allowsEditing = YES;
    //    [self presentViewController:picker animated:YES completion:nil];
    //1.获取媒体支持格式
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.mediaTypes = @[mediaTypes[0]];
    //5.其他配置
    //allowsEditing是否允许编辑，如果值为no，选择照片之后就不会进入编辑界面
    picker.allowsEditing = YES;
    //6.推送
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)getcamera{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // 设置拍照后的图片可以被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        // 先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            
            data = UIImageJPEGRepresentation(image, 0.2);
        }else {
            data=    UIImageJPEGRepresentation(image, 0.2);
        }
        //#warning 这里来做操作，提交的时候要上传
        // 图片保存的路径
        [self.imageArr insertObject:data atIndex:0];
        [self refreshimageview];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

#pragma 动画代理
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    return [[editorMaskPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    
}
//控制器创建执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _ishidecotr=YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _ishidecotr=NO;
    return self;
}
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.5;
    
}
-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (_ishidecotr==YES) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.frame=CGRectMake(-SCREEN_WIDTH, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
        toView.layer.cornerRadius = 6;
        toView.clipsToBounds = YES;
        [transitionContext.containerView addSubview:toView];
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
        }];
    }else{
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20 + SCREEN_WIDTH, (SCREEN_HEIGHT - 300)/2, SCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [toView removeFromSuperview];
                [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            }
            
        }];
        
    }
    
}

//点击maskview
-(void)incentiveModelMaskVtapgestureLb{
    
    [self.incentiveModelMaskV removeFromSuperview];
    
    
}
-(UIView*)incentiveModelMaskV{
    
    if (!_incentiveModelMaskV) {
        _incentiveModelMaskV=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _incentiveModelMaskV.backgroundColor=[UIColor clearColor];
    }
    
    return _incentiveModelMaskV;
    
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.contentW.constant = SCREEN_WIDTH;
    self.contentH.constant = 1010  + self.shuxingSize.size.height + 30;
    self.imageViwH.constant = 100;
    
    self.submitBt.layer.cornerRadius = 4;
    self.submitBt.clipsToBounds = YES;

}

- (IBAction)closeKeyBoard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}


-(NSMutableArray*)imageArr{
    if (!_imageArr) {
        _imageArr=[NSMutableArray arrayWithObjects:@"照片框-拷贝-9", nil];
    }
    return _imageArr;
}
-(NSMutableArray*)selectedTagIds{
    if (!_selectedTagIds) {
        _selectedTagIds=[NSMutableArray array];
    }
    return _selectedTagIds;
}
@end
