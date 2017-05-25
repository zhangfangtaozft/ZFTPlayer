//
//  AppDelegate.h
//  IJKplayerTest
//
//  Created by 张芳涛 on 2017/4/11.
//  Copyright © 2017年 张芳涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/*
 决定是不是可以允许转屏的参数
 */
@property(nonatomic,assign)BOOL allowRotation;

/*
 当前的网络状态
 */
@property(nonatomic,assign)int netWorkStatesCode;


@end


