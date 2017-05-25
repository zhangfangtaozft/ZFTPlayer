//
//  AppDelegate.m
//  IJKplayerTest
//
//  Created by 张芳涛 on 2017/4/11.
//  Copyright © 2017年 张芳涛. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AFNetworkActivityIndicatorManager.h>
#import <AFNetworking.h>
#import <objc/runtime.h>


@interface AppDelegate ()
@property(nonatomic,assign) BOOL shouldStopBg;
@property(nonatomic,strong)AVAudioPlayer * audioPlayer;
@property(nonatomic,assign)NSInteger optionNumber;
@property(nonatomic,assign)NSTimeInterval interViewTime;

@end

@implementation AppDelegate
@synthesize allowRotation;

@synthesize netWorkStatesCode;

#pragma mark - 屏幕旋转相关设置
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    FirstViewController *vc = [[FirstViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    [self netWorkChangeEvent];
    [self setUpMusicOption];
    [self setUpMusicOptionsWithNormal:YES];
    return YES;
}

#pragma mark - 检测网络状态变化
-(void)netWorkChangeEvent
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    NSURL *url = [NSURL URLWithString:@"http://baidu.com"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self.netWorkStatesCode = status;
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"当前使用的是流量模式");
                break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"当前使用的是wifi模式");
                break;
                case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"断网了");
                break;
                case AFNetworkReachabilityStatusUnknown:
                NSLog(@"变成了未知网络状态");
                break;
                
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"netWorkChangeEventNotification" object:@(status)];
    }];
    [manager.reachabilityManager startMonitoring];
}
#pragma mark -  应用退到后台或者上划出来控制界面下划出来通知界面都会走这个方法
- (void)applicationWillResignActive:(UIApplication *)application {
    [self setUpMusicOptionsWithNormal:YES];
    [self performSelectorInBackground:@selector(playEmptyMusicInBackGround) withObject:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationWillResignActive" object:nil];
}
#pragma mark - 从上面的场景中回到应用就会执行这个方法
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playEmptyMusicInBackGround) object:nil];
    [self setUpMusicOptionsWithNormal:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"applicationDidBecomeActive" object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {

}
#pragma mark - 设置music播放相关参数
-(void)setUpMusicOptionsWithNormal:(BOOL)normal
{
    if (normal) {
        self.optionNumber = 1;
        self.interViewTime = 1.0;
    }
    else{
        self.optionNumber = -1;
        self.interViewTime = 0.01;
    }
}

#pragma mark -设置music播放器
-(void)setUpMusicOption
{
    NSURL *musicUrl = [[NSURL alloc]initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"60秒静音" ofType:@"mp3"]];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:musicUrl error:nil];
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.volume = 0;
}

#pragma mark -后台播放没有声音的音乐
-(void)playEmptyMusicInBackGround
{
  
   UIBackgroundTaskIdentifier bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    _shouldStopBg = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        while ( self.optionNumber != 0 ) {
            if ( _shouldStopBg ){ break; }
            float remainTime = [[UIApplication sharedApplication] backgroundTimeRemaining];
            NSLog(@"###!!!BackgroundTimeRemaining: %f",remainTime);
            if ( remainTime < 20.0 ){
                NSLog(@"start play audio!");
                NSError *audioSessionError = nil;
                AVAudioSession *audioSession = [AVAudioSession sharedInstance];
                if ( [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&(audioSessionError)] )
                {
                    NSLog(@"set audio session success!");
                }else{
                    NSLog(@"set audio session fail!");
                }
                [self.audioPlayer play];
                [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            }
            self.optionNumber ++;
            [NSThread sleepForTimeInterval:self.interViewTime];
        }
    });
}
#pragma mark - 释放应用
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"applicationDidBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"applicationWillResignActive" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"netWorkChangeEventNotification" object:nil];
}


@end
