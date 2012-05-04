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
@synthesize rrRefreshTableHeaderView = _rrRefreshTableHeaderView;
- (void)dealloc{
	self.testButton = nil;
	self.newsFeedTableView = nil;
	self.rrRefreshTableHeaderView = nil;
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
	
//	UIButton *temporaryBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
//	[temporaryBarButton setTitle:@"加载" forState:UIControlStateNormal];
//	[temporaryBarButton setImage:[[RCResManager getInstance] imageForKey:@"main_btn_set_hl.png"]
//						forState:UIControlStateNormal];
//	[temporaryBarButton setImage:[[RCResManager getInstance] imageForKey:@"main_btn_set_hl.png"]
//						forState:UIControlStateHighlighted];
//	[temporaryBarButton addTarget:self action:@selector(testLoadMore)
//				 forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"加载" 
															style:UIBarButtonItemStylePlain
														   target:self 
														   action:@selector(testLoadMore)];
	self.navigationItem.rightBarButtonItem = item;
//	[temporaryBarButton release];
	
	//中间栏
	UISegmentedControl *segmentControl = [[UISegmentedControl alloc]initWithItems:
										  [NSArray arrayWithObjects:@"好友动态",@"热门分享",nil]];
	CGFloat width = 150;
	segmentControl.frame = CGRectMake((PHONE_SCREEN_SIZE.width - width ) / 2.0, 10, width, 30);
	segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentControl.backgroundColor = [UIColor colorWithPatternImage:
									  [[RCResManager getInstance]imageForKey:@"button_bar"]];
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
	
	//下拉刷新
	if (_rrRefreshTableHeaderView == nil) {
		RRRefreshTableHeaderView *view = [[RRRefreshTableHeaderView alloc]
										  initWithFrame:CGRectMake(0.0f,
																   0.0f - self.newsFeedTableView.bounds.size.height,
																   PHONE_SCREEN_SIZE.width,
																   self.newsFeedTableView.bounds.size.height)];
		view.delegate = self;
		[self.newsFeedTableView addSubview:view];
		self.rrRefreshTableHeaderView = view;
		view.backgroundColor = RGBCOLOR(222, 222, 222);
		TT_RELEASE_SAFELY(view);
	}
	[_rrRefreshTableHeaderView refreshLastUpdatedDate];
	_bIsLoading = NO;

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
	self.rrRefreshTableHeaderView = nil;
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
	[self.model load:YES];//加载数据
}


- (void)modelDidFinishLoad:(RNModel *)model{
    [_newFeedTableView reloadData];
	_bIsLoading = NO; //正在刷新标记NO

	[self.rrRefreshTableHeaderView rrRefreshScrollViewDataSourceDidFinishedLoading:self.newsFeedTableView];
}

#pragma mark - 测试加载更多
- (void)testLoadMore{
	
	[self.model load:YES];
}
#pragma mark - UITableViewDataSource
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



#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	//列表拖动
	[self.rrRefreshTableHeaderView rrRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	//拖动结束
	[self.rrRefreshTableHeaderView rrRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - RRRefreshTableHeaderDelegate Methods

- (void)rrRefreshTableHeaderDidTriggerRefresh:(RRRefreshTableHeaderView*)view{

	[self.model load:YES];//加载数据
	_bIsLoading = YES;

}

- (BOOL)rrRefreshTableHeaderDataSourceIsLoading:(RRRefreshTableHeaderView*)view{
	return  _bIsLoading;
}

- (NSDate*)rrRefreshTableHeaderDataSourceLastUpdated:(RRRefreshTableHeaderView*)view
{	
	return [NSDate date]; // should return date data source was last changed
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

//		[currentNav pushViewController:viewController animated:YES];
		[self presentModalViewController:viewController animated:NO];
		TT_RELEASE_SAFELY(viewController);

	}
}
@end
