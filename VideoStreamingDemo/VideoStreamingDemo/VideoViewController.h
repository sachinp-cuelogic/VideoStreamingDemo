//
//  ViewController.h
//  VideoStreamingDemo
//
//  Created by Sachin Patil on 20/01/17.
//  Copyright © 2017 Cuelogic Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GUIPlayerView.h"
#import <GoogleInteractiveMediaAds/GoogleInteractiveMediaAds.h>
#import "VideoTableViewCell.h"
#import "ImageInfo.h"

@interface VideoViewController : UIViewController
{
    
}

@property (nonatomic,strong) NSDictionary *videoListDict;
@property (nonatomic,strong) ImageInfo *imageInfo;

@end

