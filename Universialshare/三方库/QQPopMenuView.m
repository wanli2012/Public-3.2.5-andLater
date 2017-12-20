//
//  QQPopMenuView.m
//  ECLite
//
//  Created by ec on 16/6/16.
//  Copyright © 2016年 eclite. All rights reserved.
//

#import "QQPopMenuView.h"
#import "PopMenuTableViewCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

static CGFloat const kCellHeight = 44;

@interface QQPopMenuView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGPoint trianglePoint;
@property (nonatomic, copy) void(^action)(NSInteger index);
@end

@implementation QQPopMenuView

- (instancetype)initWithItems:(NSArray <NSDictionary *>*)array
                        width:(CGFloat)width
             triangleLocation:(CGPoint)point
                       action:(void(^)(NSInteger index))action
{
    if (array.count == 0) {
        return nil;
    }
    
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        self.alpha = 0;
        _tableData = [array copy];
        _trianglePoint = point;
        self.action = action;
        
        
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        CGFloat heigtV = 0;
         BOOL SrolB = NO;
        if (array.count >= 5) {
            heigtV = kCellHeight * 5;
            SrolB = YES;
        }else{
             heigtV = kCellHeight * array.count;
            SrolB = NO;
        }
        // 创建tableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - width - 5, point.y + 10, width, heigtV) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 5;
        _tableView.scrollEnabled = SrolB;
        _tableView.rowHeight = kCellHeight;
        [_tableView registerNib:[UINib nibWithNibName:@"PopMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"PopMenuTableViewCell"];
        [self addSubview:_tableView];
    
    }
    return self;
}

+ (void)showWithItems:(NSArray <NSDictionary *>*)array
                width:(CGFloat)width
     triangleLocation:(CGPoint)point
               action:(void(^)(NSInteger index))action
{
    QQPopMenuView *view = [[QQPopMenuView alloc] initWithItems:array width:width triangleLocation:point action:action];
    [view show];
}

- (void)tap {
    [self hide];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        return NO;
    }
    return YES;
}

#pragma mark - Show or Hide
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    // 设置右上角为transform的起点（默认是中心点）
    _tableView.layer.position = CGPointMake(SCREEN_WIDTH - 5, _trianglePoint.y + 10);
    // 向右下transform
    _tableView.layer.anchorPoint = CGPointMake(1, 0);
    _tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        _tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        _tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        [_tableView removeFromSuperview];
        [self removeFromSuperview];
        if (self.hideHandle) {
            self.hideHandle();
        }
    }];
}

#pragma mark - Draw triangle
- (void)drawRect:(CGRect)rect {
    // 设置背景色
    [YYSRGBColor(102, 139, 255, 1) set];
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    //利用path进行绘制三角形
    CGContextBeginPath(context);
    CGPoint point = _trianglePoint;
    // 设置起点
    CGContextMoveToPoint(context, point.x, point.y);
    // 画线
    CGContextAddLineToPoint(context, point.x - 10, point.y + 10);
    CGContextAddLineToPoint(context, point.x + 10, point.y + 10);
    CGContextClosePath(context);
    // 设置填充色
    [YYSRGBColor(102, 139, 255, 1) setFill];
    // 设置边框颜色
    [YYSRGBColor(102, 139, 255, 1) setStroke];
    // 绘制路径
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopMenuTableViewCell" forIndexPath:indexPath];
    NSDictionary *dic = _tableData[indexPath.row];
    cell.leftImageView.image = [UIImage imageNamed:dic[@"imageName"]];

    cell.titleLabel.text = dic[@"title"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    
    if (self.isHideImage == YES) {
        cell.leftImageView.hidden = YES;
        cell.leftconstart.constant = 0;
        cell.widethconstart.constant = 0;
    }else{
    
        if (self.isBigImage) {
            cell.leftconstart.constant = 7;
            cell.widethconstart.constant = 20;
            cell.heightconstrait.constant = 20;
        }else{
            cell.leftconstart.constant = 7;
            cell.widethconstart.constant = 8;
            cell.heightconstrait.constant = 8;
        }
        cell.leftImageView.hidden = NO;
    
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    if (_action) {
        _action(indexPath.row);
    }
}

@end
