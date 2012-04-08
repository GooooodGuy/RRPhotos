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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		self.testButton = button;

		
	    }
    return self;
}
- (void)loadView{
	[super loadView];
	self.view.backgroundColor = [UIColor blackColor];
	
	[self.testButton setImage:[UIImage imageNamed:@"main_p_pub.png" ]forState:UIControlStateNormal];
	[self.testButton addTarget:self action:@selector(onClickTestButton) forControlEvents:UIControlEventTouchDown];
	self.testButton.frame = CGRectMake(0, 100, 40, 40);
	[self.view addSubview:self.testButton];
	self.navigationItem.title = @"动态";
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)onClickTestButton{
	UIViewController *viewController = [[UIViewController alloc]init ];
	viewController.view.backgroundColor = [UIColor redColor];
	[self.navigationController pushViewController:viewController animated:YES];
	TT_RELEASE_SAFELY(viewController);
}
@end
