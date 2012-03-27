//
//  AppDelegate.m
//  RRPhotos
//
//  Created by yi chen on 12-3-26.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "AppDelegate.h"
#import "RNLoginViewController.h"
#import "RNPickPhotoController.h"
@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
	[_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	
    // Override point for customization after application launch.
	NSArray *item = [[NSArray alloc]initWithObjects:@"动态", @"玩图",@"拍照",@"消息",@"更多",nil];
	NSMutableArray *controllers = [NSMutableArray array];//视图控制器数组
	
	for (int i = 0 ; i < [item count]; i++) {
		
		UIViewController *mainView;
		if (0 == i) {
			mainView = [[RNLoginViewController alloc]init]; //第一个登陆界面　登陆后显示好友动态
		}else if(2 == i) {
			mainView = [[RNPickPhotoController alloc]init];
		}else {
			mainView = [[UIViewController alloc]init ];
		}
		
		UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainView];
		mainView.title = [item objectAtIndex: i];
		
		//nav.tabBarItem.title = [item objectAtIndex: i];
		nav.tabBarItem.image = [UIImage imageNamed: @"publish_expression_sel@2x.png"];
		nav.navigationBar.barStyle = UIBarStyleDefault;
		[controllers addObject: nav];
		
		[mainView release];
		[nav release];
	}
	
	UITabBarController *tabBarController = [[UITabBarController alloc]init];
	tabBarController.viewControllers = controllers;//设置tabbar所对应的视图控制器
	tabBarController.customizableViewControllers = controllers;

	self.window.rootViewController = tabBarController;
   // [self.window addSubview:tabBarController.view];
	
	//RNLoginViewController *loginView = [[RNLoginViewController alloc]init]
	//[self.window addSubview:(UIView *)
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

@end
