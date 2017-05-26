//
//  ZFTNetNotiView.m
//  IJKplayerTest
//
//  Created by 张芳涛 on 2017/4/19.
//  Copyright © 2017年 张芳涛. All rights reserved.
//

#import "ZFTNetNotiView.h"

#define AutoSize(px) ((kScreenHeight > kScreenWidth) ? ([UIScreen mainScreen].bounds.size.width/750)*(px) : ([UIScreen mainScreen].bounds.size.height/750)*(px))
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@implementation ZFTNetNotiView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.bgView = [[UIView alloc]init];
        self.showLabel = [[UILabel alloc]init];
        self.showLabel.textAlignment = NSTextAlignmentCenter;
        self.selectBtn = [[UIButton alloc]init];
        self.backBtn = [[UIButton alloc]init];
        [self addSubview:self.bgView];
        [self addSubview:self.showLabel];
        [self addSubview:self.selectBtn];
        [self addSubview:self.backBtn];
    }
    return self;
}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
    self.bgView.backgroundColor = [UIColor blackColor];
    self.showLabel.frame = CGRectMake(0, self.bounds.size.height * 0.5 -AutoSize(59), self.bounds.size.width, AutoSize(28));
    self.showLabel.textColor = [UIColor whiteColor];
   
    self.showLabel.font = [UIFont systemFontOfSize:14];
    self.selectBtn.frame = CGRectMake(self.bounds.size.width * 0.5 - AutoSize(100), self.bounds.size.height * 0.5 + AutoSize(17), AutoSize(200), AutoSize(60));
    self.selectBtn.layer.cornerRadius = AutoSize(30);
    self.selectBtn.layer.masksToBounds = YES;
    self.selectBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.selectBtn.layer.borderWidth = 1;
    [self.selectBtn addTarget:self action:@selector(selectedBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.selectBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
   
    self.backBtn.frame = CGRectMake(0, AutoSize(40), AutoSize(120), AutoSize(60));
    [self.backBtn setTitle:@"back" forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.netWorkNotiViewType == ZFTNetNotiViewTypeOfNoNetWork) {
        [self contentWithNoNetWork];
    }else if (self.netWorkNotiViewType == ZFTNetNotiViewTypeOfBecomeWWAN)
    {
        [self contentWithWWAN];
    }
}
#pragma mark - 无网情况下的显示内容
-(void)contentWithNoNetWork
{
    self.netWorkNotiViewType = ZFTNetNotiViewTypeOfNoNetWork;
    self.showLabel.text = @"请确认网络连接后再重试";
    [self.selectBtn setTitle:@"点击重试" forState:UIControlStateNormal];
}
#pragma mark - 流量状态下的显示内容
-(void)contentWithWWAN
{
    self.netWorkNotiViewType = ZFTNetNotiViewTypeOfBecomeWWAN;
    self.showLabel.text = @"已切换到3G/4G网络，继续播放将会消耗流量";
    [self.selectBtn setTitle:@"继续观看" forState:UIControlStateNormal];
}
-(void)selectedBtnClickEvent
{
    if (self.btnClickblock) {
        self.btnClickblock();
    }
}
-(void)backBtnClickEvent
{
    if (self.backBlock) {
        self.backBlock();
    }
}
-(void)showNetNotiViewWithType:(ZFTNetNotiViewType)type
{
    
        switch (type) {
            case ZFTNetNotiViewTypeOfNoNetWork :
                [self contentWithNoNetWork];
                break;
             case ZFTNetNotiViewTypeOfBecomeWWAN:
                [self contentWithWWAN];
                break;
            default:
                break;
        }
    NSLog(@"%f",self.frame.size.width);
    self.hidden = NO;
}
-(void)hideNetNotiView
{
    self.hidden = YES;
}
@end
