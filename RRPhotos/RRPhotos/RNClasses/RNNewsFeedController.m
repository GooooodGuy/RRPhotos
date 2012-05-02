//
//  RNNewsFeedController.m
//  RRPhotos
//
//  Created by yi chen on 12-4-8.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RNNewsFeedController.h"
#import "RNAlbumWaterViewController.h"
#import "RNPhotoViewController.h"
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
	self.navBar.hidden = YES; //采用系统的navbar
	
	UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
	temporaryBarButtonItem.title = @"刷新";
	self.navigationItem.rightBarButtonItem = temporaryBarButtonItem;
	[temporaryBarButtonItem release];
	
	//中间栏
	UISegmentedControl *segmentControl = [[UISegmentedControl alloc]initWithItems:
										  [NSArray arrayWithObjects:@"好友动态",@"热门分享",nil]];

	CGFloat width = 150;
	segmentControl.frame = CGRectMake((PHONE_SCREEN_SIZE.width - width ) / 2.0, 10, width, 30);
	segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentControl.backgroundColor = [UIColor colorWithPatternImage:[[RCResManager getInstance]imageForKey:@"button_bar"]];
	segmentControl.tintColor = self.navigationController.navigationBar.tintColor;
	NSMutableDictionary * attributes = [NSMutableDictionary dictionaryWithCapacity:5];
	[attributes setObject:[UIFont fontWithName:MED_HEITI_FONT size: 12] forKey:UITextAttributeFont];
	[segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
	[segmentControl setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
	self.navigationItem.titleView  = segmentControl;
	TT_RELEASE_SAFELY(segmentControl);

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
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
	RRNewsFeedItem *item = [[(RNNewsFeedModel *)self.model newsFeeds]objectAtIndex:indexPath.row];
	if ([item.attachments count] < 3) {
		return  (kCellTopPadding + kCellHeadImageHeight + \
				 kCellHeadContentSpace + PHONE_SCREEN_SIZE.width ); //如果是单张图片高度变宽
	}
	return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *cellIdentifier  = @"newsFeedCell";
	
	RNNewsFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	NSLog(@"row = %d",indexPath.row);

	if (!cell) {
		cell = [[[RNNewsFeedCell alloc]initWithStyle:UITableViewCellStyleDefault 
									 reuseIdentifier:cellIdentifier]autorelease];
		cell.delegate = self;
	}else {
//		while ([cell.contentView.subviews lastObject] != nil) {  
//            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  
//        } 
	}	
	RRNewsFeedItem *item = [[(RNNewsFeedModel *)self.model newsFeeds]objectAtIndex:indexPath.row];
	[cell setCellWithItem:item]; 
//	cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
	return cell;	
}

#pragma mark - RNNewsFeedCellDelegate

/*
 点击新鲜事附件照片
 */
- (void)onClickAttachView: (NSNumber *)userId photoId:(NSNumber *)photoId {
	if (userId && photoId) {
//		RNAlbumWaterViewController *albumViewContoller = [[RNAlbumWaterViewController alloc]initWithUid:userId albumId:albumId];
		NSString *userIdStr = [userId stringValue];
		NSString *photoIdStr = [photoId stringValue];
		RNPhotoViewController *viewController = [[RNPhotoViewController alloc]initWithUid:userIdStr
																				  withPid:photoIdStr
																				  shareId:nil 
																				 shareUid:nil];
//		[self presentModalViewController:viewController animated:YES];
//		self.hidesBottomBarWhenPushed = YES;
//		viewController.wantsFullScreenLayout = YES;
//		[self.navigationController pushViewController:viewController animated:YES];
//		TT_RELEASE_SAFELY(viewController);
		
		NSLog(@"进入照片内容页");
		UINavigationController *currentNav = self.navigationController;
		if (!currentNav) {
			currentNav = [[UINavigationController alloc]initWithRootViewController:self];
		}
		viewController.hidesBottomBarWhenPushed = YES;

		[currentNav pushViewController:viewController animated:YES];
		TT_RELEASE_SAFELY(viewController);

	}
}
@end
