//
//  RNNewsFeedController.m
//  RRPhotos
//
//  Created by yi chen on 12-3-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RNRootNewsFeedController.h"

@interface RNRootNewsFeedController ()

@end

@implementation RNRootNewsFeedController
@synthesize loginViewController = _loginViewController;
@synthesize newsFeedViewController = _newsFeedViewController;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
		RNLoginViewController *login = [[RNLoginViewController alloc]init ];
		login.loginDelegate = self; //设置登陆结束处理的代理
		self.loginViewController = login;
		TT_RELEASE_SAFELY(login);
		
		UIViewController *view = [[UIViewController alloc]init];
		self.newsFeedViewController = view;
		view.view.backgroundColor = [UIColor cyanColor];
		TT_RELEASE_SAFELY(view);

		
    }
    return self;
}

- (void)loadView{
	[super loadView];
	
	self.newsFeedViewController.view.frame =  CGRectMake(0 , 0 , PHONE_SCREEN_SIZE.width, PHONE_SCREEN_SIZE.height);
	[self.view addSubview:self.newsFeedViewController.view];
	
	self.loginViewController.view.frame = CGRectMake(0 , 0 , PHONE_SCREEN_SIZE.width, PHONE_SCREEN_SIZE.height);
	[self.view addSubview: self.loginViewController.view];
	
	

}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationController setNavigationBarHidden:YES animated:YES];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.loginViewController = nil;
	self.newsFeedViewController = nil;
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)finishLogin{
	self.loginViewController.view.frame = CGRectOffset(_loginViewController.view.frame, 320, 0	);
	[self.navigationController setNavigationBarHidden:NO animated:YES];

	[self viewWillAppear:YES];
}
@end
