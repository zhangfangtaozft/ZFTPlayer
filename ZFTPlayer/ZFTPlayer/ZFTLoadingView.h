//
//  ZFTLoadingView.h
//  IJKplayerTest
//
//  Created by 张芳涛 on 2017/4/20.
//  Copyright © 2017年 张芳涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFTLoadingView : UIView
/*
 显示加载框并且显示加载动画
 */
-(void)showAndStartAnimation;
/*
 隐藏加载框并且停止加载动画
 */
-(void)hideAndStopAnimation;

@end
