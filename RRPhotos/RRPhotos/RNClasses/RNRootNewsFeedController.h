//
//  RNNewsFeedController.h
//  RRPhotos
//
//  Created by yi chen on 12-3-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNLoginViewController.h"
@interface RNRootNewsFeedController : UIViewController <RNLoginDelegate>
{
	//登陆界面
	RNLoginViewController *_loginViewController;
	
	UIViewController *_newsFeedViewController;
}

@property(nonatomic,retain)RNLoginViewController *loginViewController;
@property(nonatomic,retain)UIViewController *newsFeedViewController;
@end
