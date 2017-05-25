//
//  FirstViewController.m
//  IJKplayerTest
//
//  Created by 张芳涛 on 2017/4/13.
//  Copyright © 2017年 张芳涛. All rights reserved.
//

#import "FirstViewController.h"
#import "PlayerViewController.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}
-(void)setUpUI
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton *playerbtn1 = [[UIButton alloc]init];
    playerbtn1.frame =CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5 - 50, [UIScreen mainScreen].bounds.size.height * 0.5 - 50, 100, 100);
    playerbtn1.backgroundColor = [UIColor grayColor];
    [playerbtn1 setTitle:@"点播视频" forState:UIControlStateNormal];
    [playerbtn1 addTarget:self action:@selector(playerBtnClick1) forControlEvents:UIControlEventTouchUpInside];
    playerbtn1.titleLabel.numberOfLines = 0;
    playerbtn1.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:playerbtn1];
    
//    UIButton *playerbtn2 = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.75 - 50, [UIScreen mainScreen].bounds.size.height * 0.5 - 50, 100, 100)];
//    playerbtn2.backgroundColor = [UIColor grayColor];
//    [playerbtn2 setTitle:@"直播视频" forState:UIControlStateNormal];
//    [playerbtn2 addTarget:self action:@selector(playerBtnClick2) forControlEvents:UIControlEventTouchUpInside];
//    playerbtn2.titleLabel.numberOfLines = 0;
//    playerbtn2.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:playerbtn2];
//    self.navigationItem.title = @"播放器（测试使用）";
    
}
-(void)playerBtnClick1
{
    PlayerViewController *playervc =[[PlayerViewController alloc]init];
    playervc.playUrl = @"http://fastwebcache.yod.cn/yanglan/2013suoluosi/2013suoluosi_850/2013suoluosi_850.m3u8";
   playervc.videoName = @"杨澜采访索罗斯";
    [self.navigationController pushViewController:playervc animated:NO];
}
-(void)playerBtnClick2
{
    PlayerViewController *playervc =[[PlayerViewController alloc]init];
    playervc.playUrl = @"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8";
    [self.navigationController pushViewController:playervc animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
