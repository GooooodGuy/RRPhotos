//
//  RNNewsFeedController.m
//  RRPhotos
//
//  Created by yi chen on 12-4-8.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RNNewsFeedController.h"

@interface RNNewsFeedController ()

@end




@implementation RNNewsFeedController
@synthesize testButton;
@synthesize newsFeedTableView = _newFeedTableView;

- (void)dealloc{
	self.testButton = nil;
	self.newsFeedTableView = nil;
	[super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
				
	    }
    return self;
}
- (void)loadView{
	[super loadView];
	self.view.backgroundColor = [UIColor blackColor];
	
	//测试按钮
	UIButton *testbutton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.testButton = testbutton;
	[self.testButton setImage:[UIImage imageNamed:@"main_p_pub.png" ]forState:UIControlStateNormal];
	[self.testButton addTarget:self action:@selector(onClickTestButton) forControlEvents:UIControlEventTouchDown];
	self.testButton.frame = CGRectMake(0, 100, 40, 40);
	[self.view addSubview:self.testButton];

	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setImage:[UIImage imageNamed:@"main_p_set.png"] forState:UIControlStateNormal];
	button.frame = CGRectMake(5, 5, 40, 40);
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = leftButton;
	TT_RELEASE_SAFELY(leftButton);
	
	
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"返回";
	self.navigationItem.rightBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.testButton = nil;
	self.newsFeedTableView = nil;
}


- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
//	[self.navigationController setNavigationBarHidden:YES animated:NO];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)onClickTestButton{
	UIViewController *viewController = [[UIViewController alloc]init ];
	viewController.view.backgroundColor = [UIColor redColor];
	viewController.hidesBottomBarWhenPushed = YES;//push 的时候隐藏tabbar
	[viewController.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController pushViewController:viewController animated:YES];
	TT_RELEASE_SAFELY(viewController);
}
@end
