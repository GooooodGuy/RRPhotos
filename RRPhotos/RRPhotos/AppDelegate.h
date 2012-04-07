//
//  AppDelegate.h
//  RRPhotos
//
//  Created by yi chen on 12-3-26.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
	UINavigationController *_rootNavController;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UINavigationController *rootNavController;

@end
