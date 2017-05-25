//
//  PlayerViewController.h
//  IJKplayerTest
//
//  Created by 张芳涛 on 2017/4/13.
//  Copyright © 2017年 张芳涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewController : UIViewController
/*
 视频播放器的播放地址
 */
@property(nonatomic,copy)NSString *playUrl;
/*
 视频名称
 */
@property(nonatomic,copy)NSString *videoName;


@end
