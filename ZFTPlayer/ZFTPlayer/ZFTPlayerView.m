//
//  ZFTPlayerView.m
//  IJKplayerTest
//
//  Created by 张芳涛 on 2017/4/27.
//  Copyright © 2017年 张芳涛. All rights reserved.
//

#import "ZFTPlayerView.h"
#import "ZFTButton.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "ZFTNetNotiView.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "ZFTLoadingView.h"
#import "ZFTPlayerOption.h"
#import "AFNetworking.h"
@interface ZFTPlayerView()<UIGestureRecognizerDelegate,UIApplicationDelegate>

@property(nonatomic,strong)UIView *playerView;//播放器所在的View
@property(nonatomic,copy)NSString *playerPlaceHolderImgName;//刚开始播放视频的时候的占位图片名称
@property(nonatomic,strong)UIImageView *voiceImgView;//声音提示图片
@property(nonatomic,strong)UIImageView *brightNessImgView;//亮度提示图片
@property(nonatomic,assign) BOOL isHideTool;//需要隐藏工具栏界面
@property(nonatomic,assign)CGPoint  startPoint;//开始的点
@property(nonatomic,strong)CAShapeLayer *layerView;//layer层动画界面
@property(nonatomic,strong)CAShapeLayer *layerContainer;//
@property(nonatomic,strong)UITapGestureRecognizer *tapGesture;//手势


@end
@implementation ZFTPlayerView

#pragma mark - 对象的懒加载***************************************************
#pragma mark - 懒加载timer
-(NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateEvent) userInfo:nil repeats:YES];
    }
    return _timer;
}



#pragma mark - 初始化********************************************************
-(instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate url:(NSString *)url placeHolderImg:(NSString *)placeHolderImgName playerOption:(ZFTPlayerOption * _Nullable)playerOption{
    if (self = [super initWithFrame:frame]) {
        self.playerPlaceHolderImgName = placeHolderImgName;
       //设置代理方法
        [self setUpPlayerDelegate:delegate];
       //创建playerOption
        [self setUpPlayerOption];
        if (playerOption) {
        self.playerOption = playerOption;
        }
       //设置播放器的url
        self.url = url;
       //设置UI
        [self setUpUI];
    }
    return self;
}





-(void)setUpUI{
    //1:设置playerBaseView
    [self setUpPlayerBaseView];
    //2：设置playerOption
    [self setUpPlayerOption];
    
}
#pragma mark - *****************************************************************************


#pragma mark - 创建playerBaseView（播放器所有的可见部分都是PlayerBaseView的subView）
-(void)setUpPlayerBaseView
{
    //设置playerBaseView
    if (!self.playerBaseView) {
        
        [self setUpPlayerBaseViewOnly];
        
    }
    else
    {
        [self releasePlayer];
    }
    
    
    
    if (!self.playerView) {
        //设置player
        [self setUpPlayerView];
    }
    else
    {
        [self.playerView removeFromSuperview];
        self.playerView = nil;
        [self setUpPlayerView];
    }
    
    
    if (!self.coverView) {
        //设置CoverView
        [self setUpCoverView];
    }
    else
    {
        [self.coverView removeFromSuperview];
        self.coverView  = nil;
        [self setUpPlayerView];
    }
    
    
    if (!self.loadingView) {
        //设置loadingView
        [self setUpLoadingView];
    }
    else
    {
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
        
        [self setUpLoadingView];
    }
    
    if (!self.netShowView) {
        //设置netShowView
        [self setUpNetShowView];
    }
    else
    {
        [self.netShowView  removeFromSuperview];
        self.netShowView =  nil;
        
        [self setUpNetShowView];
    }

    //3：设置完成之后先让一部分控件隐藏起来
    [self hidePlayerOptions];
}





#pragma mark - 创建playerOption（存放视频播放器的一些相关联的属性信息）
-(void)setUpPlayerOption
{
    if (!self.playerOption) {
        self.playerOption = [[ZFTPlayerOption alloc]init];
    }
}


#pragma mark - 设置单一的playerBaseView，(视频播放器的UI容器)
-(void)setUpPlayerBaseViewOnly
{
    self.backgroundColor = [UIColor blackColor];
        //如果有了就不要重复创建，目前的·处理办法是先释放掉
        if (self.playerBaseView) {
            [self.playerBaseView  removeFromSuperview];
            self.playerBaseView = nil;
    
        }
    
    //设置playerBaseView
    self.playerBaseView = [[UIView alloc]init];
    [self insertSubview:self.playerBaseView atIndex:1];
    [self.playerBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    self.playerBaseView.frame = self.bounds;
    
}





#pragma mark - 创建视频播放器(视频就在这里面播放)
-(void)setUpPlayerView
{
    
    
    
    
    //IJKplayer属性参数设置
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame" ofCategory:kIJKFFOptionCategoryCodec];
    [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter" ofCategory:kIJKFFOptionCategoryCodec];
    [options setOptionIntValue:0 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
    [options setOptionIntValue:60 forKey:@"max-fps" ofCategory:kIJKFFOptionCategoryPlayer];
    [options setPlayerOptionIntValue:256 forKey:@"vol"];
    
    
    
    NSURL *url = [NSURL URLWithString:self.url];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    [self.player setScalingMode:IJKMPMovieScalingModeAspectFit];
    //设置缓存大小，太大了没啥用,太小了视频就处于边播边加载的状态，目前是10M，后期可以调整
    [self.player setPlayerOptionIntValue:10* 1024 *1024 forKey:@"max-buffer-size"];
    
    
    
    
    
    //先创建视频播放器的View
    self.playerView = [self.player view];
    //设置大小
    [self.playerBaseView insertSubview:self.playerView atIndex:1];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.playerBaseView);
    }];
    
    //添加通知之前先移除通知
    [self removeMovieNotificationObservers];
    //添加通知方法
    [self installMovieNotificationObservers];
    
    
    
    //如果有填充图片，就添加填充图片
    if (self.playerPlaceHolderImgName)
    {
        self.playerPlaceHolderImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.playerPlaceHolderImgName]];
        [self.playerView addSubview:self.playerPlaceHolderImg];
        [self.playerPlaceHolderImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.playerBaseView);
        }];
        self.playerPlaceHolderImg.hidden = NO;
        self.playerPlaceHolderImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    //添加手势监听
    UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playerViewTap:)];
    tap.delegate = self;
    [self.playerView addGestureRecognizer:tap];
    
}



#pragma mark - 创建CoverView（存放播放按钮，进度条等等）
-(void)setUpCoverView
{
    if (self.coverView) {
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }
    self.coverView = [[UIView alloc]init];
    self.coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.playerBaseView insertSubview:self.coverView atIndex:2];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.playerBaseView);
    }];
    
    
    
    
    //在coverView上面添加返回按钮
    self.backBtn = [[ZFTButton alloc]init];
    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:(UIControlStateNormal)];
    [self.coverView addSubview:_backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.coverView);
        make.top.equalTo(self.coverView).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    [self.backBtn addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    
    
    //在coverView上面添加全屏按钮
    self.fullScreenBtn = [[ZFTButton alloc]init];
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"fullScreen"] forState:(UIControlStateNormal)];
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"quiteScreen"] forState:(UIControlStateSelected)];
    [self.coverView addSubview:self.fullScreenBtn];
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.coverView);
        make.bottom.equalTo(self.coverView);
        make.width.height.mas_equalTo(50);
    }];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreen:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    
    //在coverView上面添加播放按钮
    _playBtn = [[ZFTButton alloc]init];
    [_coverView addSubview:_playBtn];
    [_playBtn setImage:[UIImage imageNamed:@"pause"] forState:(UIControlStateNormal)];
    [_playBtn setImage:[UIImage imageNamed:@"play"] forState:(UIControlStateSelected)];
    [_playBtn addTarget:self action:@selector(playOption:) forControlEvents:(UIControlEventTouchUpInside)];
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_coverView);
        make.width.height.mas_equalTo(100);
    }];
    
    
    
    
    
    
    //在coverView上面添加锁定按钮
    _btnLock = [[ZFTButton alloc]init];
    [_btnLock setImage:[UIImage imageNamed:@"lock1"] forState:(UIControlStateNormal)];
    [_btnLock setImage:[UIImage imageNamed:@"lockSel1"] forState:(UIControlStateSelected)];
    [_btnLock addTarget:self action:@selector(lock:) forControlEvents:(UIControlEventTouchUpInside)];
    [_coverView addSubview:_btnLock];
    [_btnLock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_playBtn);
        make.left.equalTo(_playBtn);
        make.width.height.mas_equalTo(40);
    }];
    
    
    
    
    
    //在coverView上面添加视频当前时间Label
    _lblCurrentTime = [[UILabel alloc]init];
    _lblCurrentTime.font = [UIFont systemFontOfSize:15];
    if (self.playerOption.currenTime > 0) {
        _lblCurrentTime.text =[self TimeformatFromSeconds:self.playerOption.currenTime];
    }
    else
    {
        _lblCurrentTime.text = @"00:00:00";
    }
    _lblCurrentTime.textAlignment = NSTextAlignmentLeft;
    _lblCurrentTime.textColor = [UIColor whiteColor];
    [_coverView addSubview:_lblCurrentTime];
    [_lblCurrentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_coverView).offset(10);
        make.centerY.equalTo(_fullScreenBtn);
        make.width.mas_equalTo(65);
    }];
    
    
    
    
    
    //在coverView上面添加视频总时长Label
    _lblTotalTime = [[UILabel alloc]init];
    _lblTotalTime.font = [UIFont systemFontOfSize:15];
    if (self.playerOption.totalTime > 0.00) {
        _lblTotalTime.text = [self TimeformatFromSeconds:self.playerOption.totalTime];
    }
    else
    {
        _lblTotalTime.text = @"00:00:00";
    }
    
    _lblTotalTime.textAlignment = NSTextAlignmentRight;
    _lblTotalTime.textColor = [UIColor whiteColor];
    [_coverView addSubview:_lblTotalTime];
    [_lblTotalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_fullScreenBtn.mas_left);
        make.centerY.equalTo(_fullScreenBtn);
        make.width.mas_equalTo(65);
        
    }];
    
    
    
    
    
    //在coverView上面添加缓冲的进度条
    _progressView = [[UIProgressView alloc]init];
    [_coverView addSubview:_progressView];
    _progressView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lblCurrentTime.mas_right).offset(5);
        make.right.equalTo(_lblTotalTime.mas_left).offset(-5);
        make.centerY.equalTo(_fullScreenBtn);//progressView向下一个像素
    }];
    _progressView.tintColor = [UIColor whiteColor];
    [_progressView setProgress:0];
    
    
    
    
    
    
    //在coverView上面添加滑块
    _sliderView = [[UISlider alloc]init];
    _sliderView.userInteractionEnabled = YES;
    _sliderView.continuous = NO;//设置为NO,只有在手指离开的时候调用valueChange
    [_sliderView addTarget:self action:@selector(sliderTouchDownEvent:) forControlEvents:UIControlEventTouchDown];
    [_sliderView addTarget:self action:@selector(sliderValuechange:) forControlEvents:UIControlEventValueChanged];
    [_sliderView addTarget:self action:@selector(sliderTouchUpEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_sliderView addTarget:self action:@selector(sliderTouchUpEvent:) forControlEvents:UIControlEventTouchUpOutside];
    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sliderTap:)];
    [_sliderView addGestureRecognizer:_tapGesture];
    [_coverView addSubview:_sliderView];
    [_sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.equalTo(_progressView);
        make.centerY.equalTo(_progressView);
        make.height.mas_equalTo(52);
    }];
    if ((self.playerOption.currenTime > 0.00) && (self.playerOption.totalTime > 0.00)) {
        [self.sliderView setValue:self.playerOption.currenTime/self.playerOption.totalTime animated:NO];
    }
    _sliderView.minimumTrackTintColor = [UIColor whiteColor];
    _sliderView.maximumTrackTintColor = [UIColor clearColor];
    _sliderView.minimumValue = 0;
    _sliderView.maximumValue = 1;
    _sliderView.enabled = YES;
    UIImage * image = [self createImageWithColor:[UIColor whiteColor]];
    UIImage * circleImage = [self circleImageWithImage:image borderWidth:0 borderColor:[UIColor clearColor]];
    [_sliderView setThumbImage:circleImage forState:(UIControlStateNormal)];
    [self layoutIfNeeded];
    
}


#pragma mark - 创建LoadingView（需要数据加载的时候显示的）
-(void)setUpLoadingView
{
    if (_loadingView) {
        return;
    }
    _loadingView = [[ZFTLoadingView alloc]init];
    [self.playerBaseView insertSubview:self.loadingView atIndex:3];
    
    if (!self.netShowView.hidden) {
        [self.playerBaseView bringSubviewToFront:self.netShowView];
    }
    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerBaseView);
        make.top.equalTo(self.playerBaseView);
        make.right.equalTo(self.playerBaseView);
        make.bottom.equalTo(self.playerBaseView);
    }];
    
    [self showLoadingView];
}



#pragma mark - 创建网络提示界面
-(void)setUpNetShowView
{
    if (_netShowView) {
        return;
    }
    
    _netShowView = [[ZFTNetNotiView alloc]init];
    
    [self.playerBaseView insertSubview:self.netShowView atIndex:4];
    
    [_netShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

#pragma mark - 刚开始设置UI的时候，先隐藏一部分控件
-(void)hidePlayerOptions
{
    if (self.coverView) {
        
        self.coverView.hidden = YES;
        
    }
    if (self.loadingView) {
        
        self.loadingView.hidden = NO;
    }
    if (self.netShowView) {
        
        self.netShowView.hidden = YES;
        
    }
    
}



#pragma mark - 设置播放器的相关代理方法
-(void)setUpPlayerDelegate:(id)delegate
{
    
    self.fullBtnOrBackBtnClickDelegate = delegate;
    self.playStatesDelegate = delegate;
    self.playLoadStatesDelegate = delegate;
    self.playBackStateDidChangeDelgate = delegate;

}



#pragma mark - 释放掉视频播放器
-(void)releasePlayer
{
    if (self.player) {
      [self.player shutdown];
      self.player = nil;
    }

    for (UIView *subview in self.playerBaseView.subviews) {
        [subview removeFromSuperview];
    }

    [self.playerBaseView removeFromSuperview];
    self.playerBaseView = nil;
}





#pragma mark - 记录视频播放器的属性
-(void)RecordThePropertiesOfThePlayer
{
//设定的前提是得有这个播放，如果没有播放器，直接忽略
    if (self.playerBaseView) {
        ZFTInterfaceOrientationType directionType = [self.playerOption getCurrentScreenDirection];
        self.playerOption.screenDirection = directionType;
        self.playerOption.currenTime = self.player.currentPlaybackTime;
        self.playerOption.totalTime = self.player.duration;
        self.playerOption.isPlaying = self.player.isPlaying;
    }
    
    
}



#pragma mark -显示loading界面
-(void)showLoadingView
{
    [self.loadingView showAndStartAnimation];
}



#pragma mark -隐藏移除loading界面
-(void)removeLoadingView
{
    [self.loadingView hideAndStopAnimation];

}



#pragma mark - 加载状态发生改变的时候进行切换
-(void)changeState{
    //移除加载条
    [self removeLoadingView];
    //改变隐藏的状态
    self.coverView.hidden = !self.coverView.hidden;
}




#pragma mark - 点击了全屏按钮
- (void)fullScreen:(ZFTButton *)sender
{
    NSLog(@"您点击了全屏按钮");
    sender.selected = !sender.selected;
    
    if (self.fullBtnOrBackBtnClickDelegate&&[self.fullBtnOrBackBtnClickDelegate respondsToSelector:@selector(fullBtnClick:)]) {
        [self.fullBtnOrBackBtnClickDelegate fullBtnClick:sender];
    }
}




#pragma mark - 点击了返回按钮触发的事件
-(void)back:(UIButton *)sender
{
    NSLog(@"您点击了返回按钮");
    [_loadingView removeFromSuperview];
    _loadingView = nil;
    if (self.fullBtnOrBackBtnClickDelegate&&[self.fullBtnOrBackBtnClickDelegate respondsToSelector:@selector(fullBtnClick:)]) {
        [self.fullBtnOrBackBtnClickDelegate backBtnCLick:sender];
    }
    
}




#pragma mark - playerView的点击事件
-(void)playerViewTap:(UITapGestureRecognizer *)recognizer{
    
    //每次点击取消还在进程中的隐藏方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    
    self.isHideTool = !self.isHideTool;
    
    [UIView animateWithDuration:0.25 animations:^{
        if (self.isHideTool) {
            self.coverView.alpha = 0;
        }else{
            self.coverView.alpha = 1;
        }
    } completion:^(BOOL finished) {
        if (self.isHideTool) {
            self.coverView.hidden = YES;
        }else{
            self.coverView.hidden = NO;
            //如果最后没隐藏,在调用隐藏的代码
            [self performSelector:@selector(hide) withObject:nil afterDelay:4];
        }
    }];
}



#pragma mark - 判断那些控件可以接受屏幕响应方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[ZFTButton class]]||[touch.view isKindOfClass:[UISlider class]]){
        return NO;
    }
    return YES;
}




#pragma mark - 隐藏方法
-(void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha =0.0 ;
    }completion:^(BOOL finished) {
        self.coverView.hidden = YES;
        self.isHideTool = YES;
    }];
}



#pragma mark - 点击屏幕的方法
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    self.startPoint = [[touches anyObject] locationInView:self.playerView];
    
    if (!self.isHideTool && self.player) {
       
        [self hide];
        
    }
}




#pragma mark - 手指移动的方法(这个方法可以用来管理屏幕亮度和声音大小)
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved __  PLAY");

    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.playerView];
    //    CGFloat deltaX = point.x-startP.x;//这个可以用来进行拖动播放进度
    CGFloat deltaY = point.y- self.startPoint.y;
    CGFloat volume = [MPMusicPlayerController applicationMusicPlayer].volume;

    if (self.startPoint.x>[UIScreen mainScreen].bounds.size.width/2) {//调节音量
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:volume-deltaY/1000];
        [self setupLayerLeft:NO];
    }else{
        CGFloat brightness = [UIScreen mainScreen].brightness;
        [[UIScreen mainScreen] setBrightness:brightness-deltaY/5000];
        [self setupLayerLeft:YES];
    }

}

#pragma mark - 结束点击方法
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.layerContainer removeFromSuperlayer];
}
#pragma mark - 取消点击
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.layerContainer removeFromSuperlayer];
}



#pragma mark - 设置音量条，亮度条
-(void)setupLayerLeft:(BOOL)left{
    
    [self.layerContainer removeFromSuperlayer];
    [self.layerView removeFromSuperlayer];
    self.layerContainer = nil;
    self.layerView = nil;
    CGFloat volume = [MPMusicPlayerController applicationMusicPlayer].volume ;
    CGFloat brightness = [UIScreen mainScreen].brightness;
    
    
    
    
    // 创建layer并设置属性
    self.layerContainer = [CAShapeLayer layer];
    self.layerContainer.lineWidth =  3;
    self.layerContainer.strokeColor = [[UIColor grayColor] colorWithAlphaComponent:0.2].CGColor;
    [self.playerView.layer addSublayer:self.layerContainer];
    self.layerContainer.strokeEnd = 1;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointMake(left?29:KScreenWidth-29, self.playerView.center.y+20);
    [path moveToPoint:point];
    [path addLineToPoint:CGPointMake(point.x, point.y-100)];
    self.layerContainer.path = path.CGPath;
    
    
    // 创建layer并设置属性
    self.layerView = [CAShapeLayer layer];
    self.layerView.fillColor = [UIColor whiteColor].CGColor;
    self.layerView.lineWidth =  3;
    self.layerView.lineCap = kCALineCapRound;
    self.layerView.lineJoin = kCALineJoinRound;
    self.layerView.strokeColor = [UIColor whiteColor].CGColor;
    [self.layerContainer addSublayer:self.layerView];
    self.layerView.strokeEnd = left?brightness:volume;
    self.layerView.path = path.CGPath;
}




#pragma mark - 进度条滑块相关的操作
#pragma mark -点击滑块操作
-(void)sliderTap:(UITapGestureRecognizer *)tap{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    UISlider * slider = (UISlider *)tap.view;
    CGPoint point = [tap locationInView:_sliderView];
    double value = point.x/_sliderView.bounds.size.width*1;
    if (value == self.player.duration && self.player.duration > 5.00) {
        value = self.player.duration - 5;
    }
    else if (value == self.player.duration && self.player.duration <= 5.0)
    {
        value = self.player.duration * 0.8;
    }
    
    [_sliderView setValue:value animated:YES];
    _lblCurrentTime.text =[self TimeformatFromSeconds:self.player.currentPlaybackTime];
    _player.currentPlaybackTime = slider.value*_player.duration;
    self.playerOption.currenTime = slider.value*_player.duration;
    [self performSelector:@selector(hide) withObject:nil afterDelay:4];
    NSLog(@"滑块的点击操作");
}



#pragma mark -滑块的touchDown方法
-(void)sliderTouchDownEvent:(UISlider *)sender
{
    [self pauseWithoutRecoder];
    _tapGesture.enabled = NO;
}




#pragma mark - 滑块的touchUp方法
-(void)sliderTouchUpEvent:(UISlider *)sender
{
    double value = sender.value * _player.duration;
    if (value == self.player.duration && self.player.duration > 5.00) {
        value = self.player.duration - 5;
    }
    else if (value == self.player.duration && self.player.duration <= 5.0)
    {
        value = self.player.duration * 0.8;
    }
    if (sender) {
        NSLog(@"sliderTouchUp");
    }
    else
    {
        NSLog(@"SliderTouchUp from actionTap");
    }
    NSLog(@"滑块的touchUp方法");
    _tapGesture.enabled = YES;
    self.playerOption.currenTime = value;
    _player.currentPlaybackTime = value;
    if (self.playerOption.isPlaying) {
        [self play];
    }
    _lblCurrentTime.text =[self TimeformatFromSeconds:self.player.currentPlaybackTime];
}




#pragma mark - 滑块的值发生改变
-(void)sliderValuechange:(UISlider *)sender{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    [self performSelector:@selector(hide) withObject:nil afterDelay:4];
    NSLog(@"滑块的值发生了改变");
}




#pragma mark - 更新方法(每秒钟执行一次)
-(void)updateEvent{
    if ([self.player isPlaying]) {
        self.playerOption.currenTime = self.player.currentPlaybackTime;
        _lblCurrentTime.text =[self TimeformatFromSeconds:self.player.currentPlaybackTime];
        CGFloat current = self.player.currentPlaybackTime;
        CGFloat total = self.player.duration;
        CGFloat able = self.player.playableDuration;
        [_sliderView setValue:current/total animated:YES];
        [_progressView setProgress:able/total animated:YES];
    }
}




#pragma mark - 更新加载状态
- (void)loadStateDidChange:(NSNotification*)notification
{
    IJKMPMovieLoadState loadState = _player.loadState;
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) !=0) {
        NSLog(@"加载状态变成了已经缓存完成，如果设置了自动播放，这时会自动播放");

            if (self.player.currentPlaybackTime == self.playerOption.currenTime) {
           
                [self removeLoadingView];

            }
 
       
        _lblTotalTime.text = [NSString stringWithFormat:@"%@",[self TimeformatFromSeconds:self.player.duration]];
        if (self.playLoadStatesDelegate &&[self.playLoadStatesDelegate respondsToSelector:@selector(playerMPMovieLoadStatePlaythroughOK)]) {
            [self.playLoadStatesDelegate playerMPMovieLoadStatePlaythroughOK];
        }
       
    }
    if ((loadState & IJKMPMovieLoadStateStalled) != 0)
    {
        [self showLoadingView];

        
        NSLog(@"加载状态变成了数据缓存已经停止，播放将暂停");
        if (self.playLoadStatesDelegate &&[self.playLoadStatesDelegate respondsToSelector:@selector(playerMPMovieLoadStateStalled)]) {
            [self.playLoadStatesDelegate playerMPMovieLoadStateStalled];
        }
    }
    if((loadState & IJKMPMovieLoadStatePlayable) != 0)
    {
        NSLog(@"加载状态变成了缓存数据足够开始播放，但是视频并没有缓存完全");
        [self removeLoadingView];
        
        if (self.playLoadStatesDelegate && [self.playLoadStatesDelegate respondsToSelector:@selector(playerMPMovieLoadStatePlayable)]) {
            [self.playLoadStatesDelegate playerMPMovieLoadStatePlayable];
        }
    }
    if ((loadState & IJKMPMovieLoadStateUnknown) != 0) {
        NSLog(@"加载状态变成了未知状态");
        [self showLoadingView];
        if (self.playLoadStatesDelegate && [self.playLoadStatesDelegate respondsToSelector:@selector(playerMPMovieLoadStateUnknown)]) {
            [self.playLoadStatesDelegate playerMPMovieLoadStateUnknown];
        }
    }
}




#pragma mark - 播放状态改变
- (void)moviePlayBackFinish:(NSNotification*)notification
{
    int reason = [[[notification userInfo]valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"播放状态改变了：现在是播放完毕的状态：%d",reason);
            if (self.playStatesDelegate && [self.playStatesDelegate respondsToSelector:@selector(playerMPMovieFinishReasonPlaybackEnded)]) {
                [self.playStatesDelegate playerMPMovieFinishReasonPlaybackEnded];
            }
            
            break;
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"播放状态改变了：现在是用户退出状态：%d",reason);
            if (self.playStatesDelegate && [self.playStatesDelegate respondsToSelector:@selector(playerMPMovieFinishReasonUserExited)]) {
                [self.playStatesDelegate playerMPMovieFinishReasonUserExited];
            }
            break;
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"播放状态改变了：现在是播放错误状态：%d",reason);
            if (self.playStatesDelegate &&[self.playStatesDelegate respondsToSelector:@selector(playerMPMovieFinishReasonPlaybackError)]) {
                [self.playStatesDelegate playerMPMovieFinishReasonPlaybackError];
            }
#warning 播放错误的时候需要添加重新播放视频的按钮
            
            break;
        default:
            
            break;
    }
}




- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPrepareToPlayDidChange");

    [self changeState];
}




#pragma mark - 加载完成的方法
-(void)seekCompletedEvent
{
    
}



#pragma mark - 视频播放器状态改变
- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    
 //   AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
//    if (self.player.playbackState == IJKMPMoviePlaybackStatePlaying) {
//        //视频开始的时候开启计时器
//        [self.timer  fire];
//        [self performSelector:@selector(hide) withObject:nil afterDelay:4];
//    }
    
    //视频开始的时候开启计时器
    [self.timer  fire];
    [self performSelector:@selector(hide) withObject:nil afterDelay:4];
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            if (self.playBackStateDidChangeDelgate && [self.playBackStateDidChangeDelgate respondsToSelector:@selector(playerMPMoviePlaybackStateStopped)]) {
                [self.playBackStateDidChangeDelgate playerMPMoviePlaybackStateStopped];
            }
            NSLog(@"播放器的播放状态变了，现在是停止状态:%d",(int)_player.playbackState);
            break;
        case IJKMPMoviePlaybackStatePlaying:
            if (self.playBackStateDidChangeDelgate && [self.playBackStateDidChangeDelgate respondsToSelector:@selector(playerMPMoviePlaybackStatePlaying)]) {
                [self.playBackStateDidChangeDelgate playerMPMoviePlaybackStatePlaying];
            }
            
            NSLog(@"播放器的播放状态变了，现在是播放状态:%d",(int)_player.playbackState);
            break;
        case IJKMPMoviePlaybackStatePaused:
            if (self.playBackStateDidChangeDelgate && [self.playBackStateDidChangeDelgate respondsToSelector:@selector(playerMPMoviePlaybackStatePaused)]) {
                [self.playBackStateDidChangeDelgate playerMPMoviePlaybackStatePaused];
            }
            NSLog(@"播放器的播放状态变了，现在是暂停状态:%d",(int)self.player.playbackState);
            break;
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"播放器的播放状态变了，现在是中断状态:%d",(int)self.player.playbackState);
            if (self.playBackStateDidChangeDelgate && [self.playBackStateDidChangeDelgate respondsToSelector:@selector(playerMPMoviePlaybackStateInterrupted)]) {
                [self.playBackStateDidChangeDelgate playerMPMoviePlaybackStateInterrupted];
            }
            break;
        case IJKMPMoviePlaybackStateSeekingForward:
            NSLog(@"播放器的播放状态变了，现在是向前拖动状态:%d",(int)self.player.playbackState);
            
            self.playerOption.currenTime = self.player.currentPlaybackTime;
            if (self.playBackStateDidChangeDelgate && [self.playBackStateDidChangeDelgate respondsToSelector:@selector(playerMPMoviePlaybackStateSeekingForward)]) {
                [self.playBackStateDidChangeDelgate playerMPMoviePlaybackStateSeekingForward];
            }
            break;
        case IJKMPMoviePlaybackStateSeekingBackward:
            if (self.playBackStateDidChangeDelgate && [self.playBackStateDidChangeDelgate respondsToSelector:@selector(playerMPMoviePlaybackStateSeekingBackward)]) {
                [self.playBackStateDidChangeDelgate playerMPMoviePlaybackStateSeekingBackward];
            }
            NSLog(@"播放器的播放状态变了，现在是向后拖动状态：%d",(int)self.player.playbackState);
            break;
        default:
            if (self.playBackStateDidChangeDelgate && [self.playBackStateDidChangeDelgate respondsToSelector:@selector(playerMPMoviePlaybackStateUnKnown)]) {
                [self.playBackStateDidChangeDelgate playerMPMoviePlaybackStateUnKnown];
            }
            NSLog(@"播放器的播放状态变了，现在是未知状态：%d",(int)self.player.playbackState);
            break;
    }
}

#pragma mark - *************************************播放器播放/暂停/时间处理******************************
#pragma mark - 锁定按钮的点击方法
-(void)lock:(ZFTButton *)sender{
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        for (UIView * subView in _coverView.subviews) {
//            subView.alpha = 0;
//        }
//        sender.alpha = 1;
//    }else{
//    }
}




#pragma mark - 播放和暂停
-(void)playOption:(ZFTButton *)sender{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        self.playerOption.isPlaying = NO;
        [self.player pause];
    }else{
        self.playerOption.isPlaying = YES;
        [self.player play];
    }
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:4];
    
}





-(void)play
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.playerOption.isPlaying = YES;
    if ((delegate.netWorkStatesCode != AFNetworkReachabilityStatusNotReachable) && (self.playerOption.isBeingActiveState && self.playerOption.isBeingAppearState)) {
        self.playBtn.selected = NO;
        [self.player play];
    }
}




-(void)pause
{
    self.playerOption.isPlaying = NO;
    [self pauseWithoutRecoder];
}




-(void)pauseWithoutRecoder
{
    self.playBtn.selected = YES;
    [self.player pause];
}




#pragma mark - 目前是最基础的停止播放功能，目前尚未使用到
-(void)stop
{
    [self.player stop];
}




#pragma mark - 目前是最基础的preparetoPlay功能，目前尚未使用到。
-(void)prepareToPlay
{
    [self.player prepareToPlay];
}






#pragma mark - *************************************公用方法**********************************************************


#pragma mark - 视频播放器相关通知方法
- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(seekCompletedEvent) name:IJKMPMoviePlayerDidSeekCompleteNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(playerNetWorkStatesChange:) name:@"netWorkChangeEventNotification"
//                                              object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(eventWithPlayerRegistActive:) name:@"applicationWillResignActive"
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(eventWithPlayerBecomeActive:) name:@"applicationDidBecomeActive"
//                                               object:nil];
    
}




#pragma mark - 移除通知
- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:IJKMPMoviePlayerDidSeekCompleteNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"netWorkChangeEventNotification"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"applicationWillResignActive"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"applicationDidBecomeActive"
                                                  object:nil];
}


#pragma mark - 把时间转换成为时分秒
- (NSString*)TimeformatFromSeconds:(NSInteger)seconds
{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}





#pragma mark - 把颜色转变成为图片
- (UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0,0,15,15);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}




#pragma mark - 生成一个待圆角的图片
- (UIImage *)circleImageWithImage:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.加载原图
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 22 * borderWidth;
    CGFloat imageH = oldImage.size.height + 22 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文,这里得到的就是上面刚创建的那个图片上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆。As a side effect when you call this function, Quartz clears the current path.
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}




#pragma mark - dealloc方法
-(void)dealloc
{
    [self deallocEvent];
}



#pragma mark - dealloc以及释放playerBaseView的时候需要执行的释放timer，手势监听的方法
-(void)deallocEvent
{
    if (self.timer) {
        [self.timer invalidate];
    }
    _tapGesture = nil;
    
}



@end
