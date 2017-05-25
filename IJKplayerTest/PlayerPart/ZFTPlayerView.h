//
//  ZFTPlayerView.h
//  IJKplayerTest
//
//  Created by 张芳涛 on 2017/4/27.
//  Copyright © 2017年 张芳涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
@class ZFTButton;
@class ZFTLoading;
@class ZFTNetNotiView;
@class ZFTLoadingView;
@class ZFTPlayerOption;
#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height
#pragma mark - 全屏按钮或者退出按钮点击代理方法
@protocol playerfullBtnOrBackBtnClickDelegate<NSObject>
/*
 全屏按钮点击方法
 */
-(void)fullBtnClick:(UIButton *_Nullable)sender;
/*
 返回按钮点击方法
 */
-(void)backBtnCLick:(UIButton *_Nullable)sender;

@end

#pragma mark - 播放器加载状态变化的相关代理方法
@protocol playerPlayLoadStatesDelegate<NSObject>
/**
 *播放器加载状态变成了缓冲完成代理方法
 */
-(void)playerMPMovieLoadStatePlaythroughOK;
/*
 播放器加载状态变成了数据缓冲已经停止
 */
-(void)playerMPMovieLoadStateStalled;
/*
 播放器加载状态变成了缓存数据足够开始播放
 */
-(void)playerMPMovieLoadStatePlayable;
/*
 播放器加载状态变成了未知状态
 */
-(void)playerMPMovieLoadStateUnknown;
@end
#pragma mark - 播放器播放状态变化的相关代理方法
@protocol  playerPlayStatesDelegate<NSObject>
/*
 播放器播放状态变成了播放完毕状态
 */
-(void)playerMPMovieFinishReasonPlaybackEnded;
/*
 播放器状态变成了用户退出状态
 */
-(void)playerMPMovieFinishReasonUserExited;
/*
 播放器状态变成了播放错误状态
 */
-(void)playerMPMovieFinishReasonPlaybackError;

@end
#pragma mark - 播放器播放状态变化相关代理方法
@protocol playerPlayBackStateDidChangeDelgate<NSObject>

/*
 播放器当前的播放状态是停止状态
 */
-(void)playerMPMoviePlaybackStateStopped;
/*
 播放器当前的播放状态是播放状态
 */
-(void)playerMPMoviePlaybackStatePlaying;
/*
 播放器当前的播放状态是暂停状态
 */
-(void)playerMPMoviePlaybackStatePaused;
/*
 播放器当前的播放状态是中断状态
 */
-(void)playerMPMoviePlaybackStateInterrupted;
/*
 播放器当前的播放状态是向前拖动状态
 */
-(void)playerMPMoviePlaybackStateSeekingForward;
/*
 播放器当前的播放状态是向后拖动状态
 */
-(void)playerMPMoviePlaybackStateSeekingBackward;
/*
 播放器当前的播放状态是未知状态
 */
-(void)playerMPMoviePlaybackStateUnKnown;


@end
#pragma mark - ZFTPlayerView

NS_ASSUME_NONNULL_BEGIN
@interface ZFTPlayerView : UIView
#pragma mark -  参数
/*
 全屏/退出代理方法
 */
@property(nonatomic,strong)id<playerfullBtnOrBackBtnClickDelegate> fullBtnOrBackBtnClickDelegate;
/*
 播放器播放状态发生变化的代理方法
 */
@property(nonatomic,strong)id<playerPlayBackStateDidChangeDelgate>playBackStateDidChangeDelgate;
/*
 播放器加载状态发生变化的代理方法
 */
@property(nonatomic,strong)id<playerPlayLoadStatesDelegate>playLoadStatesDelegate;
/*
 播放器状态发生变化的代理方法
 */
@property(nonatomic,strong)id<playerPlayStatesDelegate>playStatesDelegate;
/*
 网络发生变化的代理方法
 */

/*
 player视图的基视图
 */
@property(nonatomic,strong)UIView *playerBaseView;
/*
 IJKplayer播放器
 */
@property(nonatomic,strong)IJKFFMoviePlayerController *player;
/*
 播放器的远程播放URL
 */
@property(nonatomic,copy)NSString *url;
/*
 蒙版,上面放一些时间label，播放按钮之类的
 */
@property(nonatomic,strong)UIView *coverView;
/*
 网络切换的时候需要显示的提示界面
 */
@property(nonatomic,strong)ZFTNetNotiView *netShowView;

/*
 播放器加载界面
 */
@property(nonatomic,strong)ZFTLoadingView *loadingView;
/*
 锁定按钮
 */
@property(nonatomic,strong)ZFTButton *btnLock;

/*
 返回按钮
 */
@property(nonatomic,strong)ZFTButton *backBtn;

/*
 播放器播放/暂停按钮
 */
@property(nonatomic,strong)ZFTButton *playBtn;
/*
 全屏按钮
 */
@property(nonatomic,strong)ZFTButton *fullScreenBtn;
/*
 显示播放器当前时间的label
 */
@property(nonatomic,strong)UILabel *lblCurrentTime;
/*
 显示播放器总时长的label
 */
@property(nonatomic,strong)UILabel *lblTotalTime;
/*
 展示播放器播放进度条的Slider控件
 */
@property(nonatomic,strong)UISlider *sliderView;
/*
 展示视频加载进度的控件
 */
@property(nonatomic,strong)UIProgressView *progressView;
/*
 定时器
 */
@property(nonatomic,strong)NSTimer *timer;

/*
 播放器的一些相关参数
 */
@property(nonatomic,strong)ZFTPlayerOption *playerOption;

/*
 占位图片
 */
@property(nonatomic,strong)UIImageView *playerPlaceHolderImg;//刚开始播放视频的时候占位图片

#pragma mark - 方法名
/*
 初始化视频播放器
 */
-(instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate url:(NSString *)url placeHolderImg:(NSString * __nullable)placeHolderImgName playerOption:(ZFTPlayerOption * __nullable)playerOption;






/*
 设置视频播放器SuperView
 */
-(void)setUpPlayerBaseView;


/*
 播放器的播放方法
 */
-(void)play;


/*
 播放器的暂停方法
 */
-(void)pause;


/*
 触发播放器的暂停方法，但是不会记录当前的暂停状态
 */
-(void)pauseWithoutRecoder;

/*
 播放器将要进行播放
 */
- (void)prepareToPlay;


/*
 停止播放
 */
- (void)stop;


/*
 释放视频播放器
 */
-(void)releasePlayer;


/*
记录当前视频播放器的属性
 */
-(void)RecordThePropertiesOfThePlayer;


NS_ASSUME_NONNULL_END
@end
