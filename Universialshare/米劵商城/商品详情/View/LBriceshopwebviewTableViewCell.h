//
//  LBriceshopwebviewTableViewCell.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/11/11.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LBriceshopwebviewTableViewdelegete <NSObject>

- (void)refreshWebHeigt:(CGFloat)webheight;

@end

@interface LBriceshopwebviewTableViewCell : UITableViewCell<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@property (strong , nonatomic)NSString *urlstr;

@property (assign , nonatomic)CGFloat webH;

@property (nonatomic, assign)id<LBriceshopwebviewTableViewdelegete>delegate;

@property (assign , nonatomic)BOOL isload;

@end
