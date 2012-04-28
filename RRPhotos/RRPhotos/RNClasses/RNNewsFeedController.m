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
	
	//新鲜事表
	UITableView *newsFeedTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 
																				  0, 
																				  PHONE_SCREEN_SIZE.width, 
																				  PHONE_SCREEN_SIZE.height)];
	newsFeedTableView.backgroundColor = RGBCOLOR(222, 222, 222);
	
	self.newsFeedTableView = newsFeedTableView;
	newsFeedTableView.dataSource = self; //tableView的数据
	newsFeedTableView.delegate = self;
	[self.view addSubview:newsFeedTableView];
	TT_RELEASE_SAFELY(newsFeedTableView);
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

//点击测试按钮
- (void)onClickTestButton{
	UIViewController *viewController = [[UIViewController alloc]init ];
	viewController.view.backgroundColor = [UIColor redColor];
	viewController.hidesBottomBarWhenPushed = YES;//push 的时候隐藏tabbar
	[viewController.navigationController setNavigationBarHidden:NO animated:YES];
	[self.navigationController pushViewController:viewController animated:YES];
	TT_RELEASE_SAFELY(viewController);
}

/*
	重载父类的创建model
 */
- (void)createModel {
	
	//新鲜事类型
	NSString *typeString = ITEM_TYPES_NEWSFEED_FOR_PHOTO;//只请求与照片有关的数据
	
	RNNewsFeedModel *model = [[RNNewsFeedModel alloc]initWithTypeString:typeString];
	self.model = (RNModel *) model;
	[self.model load:NO];//加载数据
}


- (void)modelDidFinishLoad:(RNModel *)model{

    [_newFeedTableView reloadData];
}

#pragma -mark UITableViewDataSource
//@required

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	
	return ((RNNewsFeedModel *)self.model).newsFeedCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *cellIdentifier  = @"newsFeedCell";
	
	RNNewsFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	NSLog(@"row = %d",indexPath.row);

	if (!cell) {
		cell = [[[RNNewsFeedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
	}else {
//		while ([cell.contentView.subviews lastObject] != nil) {  
//            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  
//        } 
	}	
	RRNewsFeedItem *item = [[(RNNewsFeedModel *)self.model newsFeeds]objectAtIndex:indexPath.row];
	[cell setCellWithItem:item]; //cia
	cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
	return cell;	
}
@end
