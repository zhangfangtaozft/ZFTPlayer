//
//  ZFTPlayerOption.m
//  IJKplayerTest
//
//  Created by 张芳涛 on 2017/4/27.
//  Copyright © 2017年 张芳涛. All rights reserved.
//

#import "ZFTPlayerOption.h"
#import "AppDelegate.h"
@implementation ZFTPlayerOption

-(ZFTInterfaceOrientationType)getCurrentScreenDirection
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeRight) // home键靠右
    {
        return ZFTInterfaceOrientationLandscapeRight;
    }
    
    if (orientation ==UIInterfaceOrientationLandscapeLeft) // home键靠左
    {
        return ZFTInterfaceOrientationLandscapeLeft;
    }
    if (orientation == UIInterfaceOrientationPortrait)
    {
        
        return ZFTInterfaceOrientationPortrait;
    }
    if (orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        return ZFTInterfaceOrientationPortraitUpsideDown;
    }
    return ZFTInterfaceOrientationUnknown;

}

@end
