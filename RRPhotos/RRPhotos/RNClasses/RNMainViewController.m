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
#import "RNPickPhotoHelper.h"

@interface RNMainViewController ()

@end

@implementation RNMainViewController
@synthesize tabBarController = _tabBarController;
@synthesize tabBar = _tabBar;
@synthesize pickHelper = _pickHelper;
@synthesize newsFeedController = _newsFeedController;
@synthesize testViewController = _testViewController;
@synthesize lastSelectIndex = _lastSelectIndex;

- (void)dealloc{
	self.tabBarController = nil;
	self.tabBar = nil;
	self.pickHelper = nil;
	self.newsFeedController = nil;
	self.testViewController = nil;
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

		//照片拾取器
		RNPickPhotoHelper *help = [[RNPickPhotoHelper alloc]init];
		self.pickHelper = help;
		TT_RELEASE_SAFELY(help);

		[self initView];
//		[self initSubView];
	
    }
    return self;
}


//- (void)initSubView{
//		
//	
//	//测试
//	UIViewController *testController = [[UIViewController alloc]init];
//	self.testViewController = testController;
//	TT_RELEASE_SAFELY(testController);
//	
//	self.testViewController.view.frame = CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, PHONE_SCREEN_SIZE.height);
//	self.testViewController.view.backgroundColor = [UIColor greenColor];
//	[self.view addSubview:self.testViewController.view];
//	
//	
//	//新鲜事
//	RNNewsFeedController *newsFeedController = [[RNNewsFeedController alloc]init];
//	self.newsFeedController = newsFeedController;
//	TT_RELEASE_SAFELY(newsFeedController);
//	
//	self.newsFeedController.view.frame = CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, PHONE_SCREEN_SIZE.height);
////	self.newsFeedController.view.backgroundColor = [UIColor blueColor];
//	[self.view addSubview:self.newsFeedController.view];
//	
//	
//	//tabBar
//	NSArray *item = [[NSArray alloc]initWithObjects:@"动态", @"玩图",@"拍照",@"消息",@"更多",nil];
//	NSMutableArray *tabBarItems = [NSMutableArray array];
//	
//	int i = 0;
//	for (NSString *name in item) {
//		
//		UIImage *itemBackImage;
//		
//		switch (i) { //设置背景
//			case 0:
//			case 1:
//			case 3:
//			case 4:
//			{
//				itemBackImage = [UIImage imageNamed:@"publish_expression_sel@2x.png"];
//				
//			}break;
//				
//			case 2:	
//			{
//				itemBackImage = [UIImage imageNamed:@"navigationbar_btn_camera.png"];
//				
//			}break;
//			default:
//				
//				break;
//		}
//		
//		UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:name image:itemBackImage tag:i];
//		i ++;
//		[tabBarItems addObject:tabBarItem];
//		TT_RELEASE_SAFELY(tabBarItem);
//	}
//	
//	UITabBar *tabBar = [[UITabBar alloc]init];
//	self.tabBar = tabBar;
//	TT_RELEASE_SAFELY(tabBar);
//	
//	
//	self.tabBar.delegate = self;
//	[self.tabBar setItems:tabBarItems];
//	//		self.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"navigationbar_arrow.png"];
//	self.tabBar.frame = CGRectMake(0, PHONE_SCREEN_SIZE.height - 44, PHONE_SCREEN_SIZE.width,44);
//	
//	[self.tabBar setSelectedItem:[self.tabBar.items objectAtIndex:0]];
//	[self.view addSubview: self.tabBar];
//	
//	
//	
//}


- (void)initView{
	
	NSArray *item = [[NSArray alloc]initWithObjects:@"动态", @"多图",@"拍照",@"消息",@"更多",nil];
	NSMutableArray *controllers = [NSMutableArray array];//视图控制器数组
	
	for (int i = 0 ; i < [item count]; i++) {
		
		UIViewController *mainView;
		UINavigationController *nav;

		switch (i) { //设置背景
			case 0:{
				
				mainView = [[RNNewsFeedController alloc]init];
				mainView.title = [item objectAtIndex: i];

				nav = [[UINavigationController alloc]initWithRootViewController:mainView];
				nav.tabBarItem.image = [UIImage imageNamed: @"main_p_model.png"];
				nav.navigationBar.barStyle = UIBarStyleDefault;

				TT_RELEASE_SAFELY(mainView);
			}break;
			
			case 1:{
				mainView = [[UIViewController alloc]init];
				mainView.title = [item objectAtIndex:i];
				mainView.view.frame = CGRectZero;
				nav = [[UINavigationController alloc]initWithRootViewController:mainView];
				TT_RELEASE_SAFELY(mainView);
			
				nav.tabBarItem.image = [UIImage imageNamed: @"navigation_extend_icon.png"];
				nav.view.frame = CGRectZero;
			}break;
				
			case 2:{
				mainView = [[UIViewController alloc]init];
				mainView.title = [item objectAtIndex:i];
				mainView.view.frame = CGRectZero;
				nav = [[UINavigationController alloc]initWithRootViewController:mainView];
				TT_RELEASE_SAFELY(mainView);
				
				nav.tabBarItem.image = [UIImage imageNamed: @"publisher_photo.png"];
				nav.view.frame = CGRectZero;
			}break;
				
			case 3:{
				mainView = [[UIViewController alloc]init];
				mainView.view.backgroundColor = [UIColor greenColor];
				mainView.title = [item objectAtIndex:i];
				nav = [[UINavigationController alloc]initWithRootViewController:mainView];
				TT_RELEASE_SAFELY(mainView);
				nav.tabBarItem.image = [UIImage imageNamed: @"publisher_status.png"];

			}break;
				
			case 4:{
				mainView = [[UIViewController alloc]init];
				mainView.view.backgroundColor = [UIColor blueColor];
				mainView.title = [item objectAtIndex:i];
				nav = [[UINavigationController alloc]initWithRootViewController:mainView];
				TT_RELEASE_SAFELY(mainView);
				nav.tabBarItem.image = [UIImage imageNamed:@"main_p_set.png"];
			}break;
				
			default:
				
				break;
		}

		[controllers addObject: nav];
		TT_RELEASE_SAFELY(nav);
	}
	
	UITabBarController *tabBarController = [[UITabBarController alloc]init];
	tabBarController.viewControllers = controllers;//设置tabbar所对应的视图控制器
	tabBarController.delegate = self;
	tabBarController.view.frame = CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, PHONE_SCREEN_SIZE.height);
	self.tabBarController = tabBarController;

	TT_RELEASE_SAFELY(tabBarController);

}

- (void)loadView{
	[super loadView];
	[self.view addSubview: self.tabBarController.view];

}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	
//	[[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	

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

#pragma -mark UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController 
			didSelectViewController:(UIViewController *)viewController{
	
	if (viewController == [tabBarController.viewControllers objectAtIndex:2]) { //拍照功能
		[self.pickHelper pickPhotoWithSoureType:UIImagePickerControllerSourceTypeCamera];
		[tabBarController setSelectedViewController:[tabBarController.viewControllers objectAtIndex: _lastSelectIndex]];
	}else if (viewController == [tabBarController.viewControllers objectAtIndex:1]) { //选择照片功能
		[self.pickHelper pickPhotoWithSoureType:UIImagePickerControllerSourceTypePhotoLibrary];
		[tabBarController setSelectedViewController:[tabBarController.viewControllers objectAtIndex: _lastSelectIndex]];

	}else {
		_lastSelectIndex = [tabBarController selectedIndex];
	}
	
	[self viewWillAppear:YES];
}

#pragma -mark UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
	
}
@end
