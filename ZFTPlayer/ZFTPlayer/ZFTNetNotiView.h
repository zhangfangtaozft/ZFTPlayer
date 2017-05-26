//
//  ZFTNetNotiView.h
//  IJKplayerTest
//
//  Created by 张芳涛 on 2017/4/19.
//  Copyright © 2017年 张芳涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ZFTNetNotiViewType ) {
    ZFTNetNotiViewTypeOfNoNetWork   = 0,//没有网络的时候的提示类型
    ZFTNetNotiViewTypeOfBecomeWWAN  = 1,//切换成3G/4G时候的提示类型
};
typedef void(^SelectBtnClickBlock)();
typedef void(^backbtnCLickBlock)();
@interface ZFTNetNotiView : UIView
/*
 背景View
 */
@property(nonatomic,strong)UIView *bgView;

/*
 上方的提示文字
 */
@property(nonatomic,strong)UILabel *showLabel;

/*
 下面的选择按钮
 */
@property(nonatomic,strong)UIButton *selectBtn;

/*
 提示类型
 */
@property (nonatomic, assign) ZFTNetNotiViewType netWorkNotiViewType;

/*
 提示界面的返回按钮
 */
@property(nonatomic,strong)UIButton *backBtn;
/*
 点击按钮的回调方法
 */
@property(nonatomic,copy)SelectBtnClickBlock btnClickblock;
/*
 点击返回按钮的回调方法
 */
@property(nonatomic,copy)backbtnCLickBlock backBlock;
/*
 显示并且设定显示的类型
 */
-(void)showNetNotiViewWithType:(ZFTNetNotiViewType)type;

/*
 隐藏提示框
 */
-(void)hideNetNotiView;

@end
