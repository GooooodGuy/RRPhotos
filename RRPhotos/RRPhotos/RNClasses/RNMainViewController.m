//
//  RNMainViewController.m
//  RRPhotos
//
//  Created by yi chen on 12-4-7.
//  Copyright (c) 2012年 renren. All rights reserved.
//
#import "AppDelegate.h"
#import "RNMainViewController.h"
#import "RNNewsFeedController.h"
#import "ImageProcessingViewController.h"
@interface RNMainViewController ()

@end

@implementation RNMainViewController
@synthesize  tabBarController = _tabBarController;

- (void)dealloc{
	self.tabBarController = nil;
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[self initView];
    }
    return self;
}

- (void)initView{
	
	NSArray *item = [[NSArray alloc]initWithObjects:@"动态", @"玩图",@"拍照",@"消息",@"更多",nil];
	NSMutableArray *controllers = [NSMutableArray array];//视图控制器数组
	
	for (int i = 0 ; i < [item count]; i++) {
		
		UIViewController *mainView;
		if (0 == i) {
			mainView = [[RNNewsFeedController alloc]init]; //第一个登陆界面　登陆后显示好友动态
		}else if(2 == i) {
			//			mainView = [[RNPickPhotoController alloc]init];
			mainView = [[ImageProcessingViewController alloc]init ];
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
	self.tabBarController = tabBarController;
	TT_RELEASE_SAFELY(tabBarController);
}

- (void)loadView{
	[super loadView];
	self.wantsFullScreenLayout = YES;
	self.tabBarController.view.frame = CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, PHONE_SCREEN_SIZE.height);
	[self.view addSubview:self.tabBarController.view];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	
	[[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
	self.tabBarController = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
