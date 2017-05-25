//
//  ZFTPlayerOption.h
//  IJKplayerTest
//
//  Created by 张芳涛 on 2017/4/27.
//  Copyright © 2017年 张芳涛. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZFTInterfaceOrientationType) {

    ZFTInterfaceOrientationPortrait           = 0,//home键在下面
    ZFTInterfaceOrientationLandscapeLeft      = 1,//home键在左边
    ZFTInterfaceOrientationLandscapeRight     = 2,//home键在右边
    ZFTInterfaceOrientationUnknown            = 3,//未知方向
    ZFTInterfaceOrientationPortraitUpsideDown = 4,//home键在上面
};

@interface ZFTPlayerOption : NSObject

/*
 屏幕方向
 */
@property(nonatomic,assign)ZFTInterfaceOrientationType screenDirection;

/*
 是否是正在播放状态
 */
@property(nonatomic,assign)BOOL isPlaying;

/*
 当前播放时间
 */
@property(nonatomic,assign) NSTimeInterval currenTime;
/*
 视频的总时长
 */
@property(nonatomic,assign) NSTimeInterval totalTime;
/*
 当前播放器处于被显示状态
 */
@property(nonatomic,assign)BOOL isBeingAppearState;

/*
 当前视频播放器是不是第一响应者状态
 */
@property(nonatomic,assign)BOOL isBeingActiveState;

/*
 获取当前的屏幕方向
 */
-(ZFTInterfaceOrientationType)getCurrentScreenDirection;

@end
