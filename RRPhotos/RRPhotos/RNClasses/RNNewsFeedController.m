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
#define kHotShareViewTag 10001
#define kNewsFeedViewTag 10002
@interface RNNewsFeedController ()

@end

@implementation RNNewsFeedController
@synthesize newsFeedTableView = _newFeedTableView;
@synthesize rrRefreshTableHeaderView = _rrRefreshTableHeaderView;
@synthesize hotShareViewController = _hotShareViewController;
@synthesize mainContainerController = _mainContainerController;
@synthesize currentViewController = _currentViewController;

- (void)dealloc{
	self.newsFeedTableView = nil;
	self.rrRefreshTableHeaderView = nil;
	self.hotShareViewController = nil;
	self.mainContainerController = nil;
	self.currentViewController = nil;
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
	
	//刷新按钮
	UIButton *refreshButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
	UIImage *refreshButtonImage = [[RCResManager getInstance]imageForKey:@"webbrowser_refresh"];
	[refreshButton setImage:refreshButtonImage forState:UIControlStateNormal];
	[refreshButton setImage:refreshButtonImage forState:UIControlStateSelected];
	[refreshButton addTarget:self action:@selector(onClickRefreshButton) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:refreshButton];

	self.navigationItem.rightBarButtonItem = item;
	
	//中间栏
	UISegmentedControl *segmentControl = [[UISegmentedControl alloc]initWithItems:
										  [NSArray arrayWithObjects:@"好友动态",@"热门分享",nil]];
	CGFloat width = 150;
	segmentControl.frame = CGRectMake((PHONE_SCREEN_SIZE.width - width ) / 2.0, 10, width, 30);
	segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentControl.backgroundColor = [UIColor colorWithPatternImage:
									  [[RCResManager getInstance]imageForKey:@"button_bar"]];
	segmentControl.tintColor = self.navigationController.navigationBar.tintColor;
	NSMutableDictionary * attributes = [NSMutableDictionary dictionaryWithCapacity:5]; //设置字体风格
	[attributes setObject:[UIFont fontWithName:MED_HEITI_FONT size: 12] forKey:UITextAttributeFont];
	[segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
	[segmentControl setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
	[segmentControl addTarget:self action:@selector(changeCurrentViewController:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView  = segmentControl;
	TT_RELEASE_SAFELY(segmentControl);

	

	[self.view addSubview:self.hotShareViewController.view]; //热门分享
	[self.view addSubview:self.mainContainerController.view];//好友动态
}
/*
	主界面容器，包括新鲜事列表
 */
- (UIViewController *)mainContainerController{
	
	if (!_mainContainerController) {
		_mainContainerController = [[UIViewController alloc]init];
		_mainContainerController.view.frame = CGRectMake(0, 
														 0, 
														 PHONE_SCREEN_SIZE.width, 
														 PHONE_SCREEN_SIZE.height);
		_mainContainerController.view.tag = kNewsFeedViewTag;
		
		[_mainContainerController.view addSubview:self.newsFeedTableView];
	}
	
	return _mainContainerController;
}

- (RNHotShareViewController *)hotShareViewController{
	
	if (!_hotShareViewController) {
		_hotShareViewController = [[RNHotShareViewController alloc]init];
		_hotShareViewController.view.frame = CGRectMake(0, 
														0, 
														PHONE_SCREEN_SIZE.width, 
														PHONE_SCREEN_SIZE.height);
		_hotShareViewController.view.tag = kHotShareViewTag;
	}
	return _hotShareViewController;
}

/*
	图片新鲜事内容表
 */
- (UITableView *)newsFeedTableView{
	if (!_newFeedTableView) {
		//新鲜事表
		UITableView *newsFeedTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 
																					  0, 
																					  PHONE_SCREEN_SIZE.width, 
																					  PHONE_SCREEN_SIZE.height)];
		newsFeedTableView.backgroundColor = RGBCOLOR(222, 222, 222);
		newsFeedTableView.dataSource = self; //tableView的数据
		newsFeedTableView.delegate = self;
		UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320,200)];
		footerView.backgroundColor = [UIColor clearColor];
		newsFeedTableView.tableFooterView = footerView;
		TT_RELEASE_SAFELY(footerView);
		[self.view addSubview:newsFeedTableView];
		_newFeedTableView = newsFeedTableView;

	}
	return _newFeedTableView;
}

/*
	下拉刷新头部
 */
- (RRRefreshTableHeaderView *)rrRefreshTableHeaderView{
	
	//下拉刷新
	if (_rrRefreshTableHeaderView == nil) {
		RRRefreshTableHeaderView *view = [[RRRefreshTableHeaderView alloc]
										  initWithFrame:CGRectMake(0.0f,
																   0.0f - self.newsFeedTableView.bounds.size.height,
																   PHONE_SCREEN_SIZE.width,
																   self.newsFeedTableView.bounds.size.height)];
		view.delegate = self;
		[self.newsFeedTableView addSubview:view];
		_rrRefreshTableHeaderView = view;
		view.backgroundColor = RGBCOLOR(222, 222, 222);
		TT_RELEASE_SAFELY(view);
		
		[_rrRefreshTableHeaderView refreshLastUpdatedDate];
		_bIsLoading = NO; //是否正在加载标记
	}

	return _rrRefreshTableHeaderView;
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
	self.newsFeedTableView = nil;
	self.rrRefreshTableHeaderView = nil;
	self.hotShareViewController = nil;
	self.mainContainerController = nil;
	self.currentViewController = nil;
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

/*
	开始
 */
- (void)modelDidStartLoad:(RNModel *)model {
	_bIsLoading = YES;
}

- (void)modelDidFinishLoad:(RNModel *)model{
    [_newFeedTableView reloadData];
	_bIsLoading = NO; //正在刷新标记NO

	[self.rrRefreshTableHeaderView rrRefreshScrollViewDataSourceDidFinishedLoading:self.newsFeedTableView];
}

/*
	改变浏览频道，是热门分享还是好友动态
 */
- (void)changeCurrentViewController:(UISegmentedControl *)sender{
	if (0 == sender.selectedSegmentIndex) {
		self.currentViewController = self.mainContainerController;
	}else {
		self.currentViewController = self.hotShareViewController;
	}
	
	[self.view bringSubviewToFront:self.currentViewController.view];
}
#pragma mark - 刷新
- (void)onClickRefreshButton{
	if (_bIsLoading) {
		return;
	}
	if (self.currentViewController == self.hotShareViewController) {
		[self.hotShareViewController.model load:YES];
	}else{
		[UIView animateWithDuration:0.3 animations:^() {
			NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
			[self.newsFeedTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
			[self.newsFeedTableView setContentOffset : CGPointMake(0, - 150) animated:NO];
		} completion:^(BOOL finished){
			if (finished) {
				[self.rrRefreshTableHeaderView setState:RROPullRefreshPulling];
				[self.rrRefreshTableHeaderView rrRefreshScrollViewDidScroll:self.newsFeedTableView];
				[self.rrRefreshTableHeaderView rrRefreshScrollViewDidEndDragging:self.newsFeedTableView];
			}
		}];
	}
	
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
	float time = [[NSDate date]timeIntervalSince1970];
	NSLog(@"拖动开始%f",time);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	//拖动结束
	[self.rrRefreshTableHeaderView rrRefreshScrollViewDidEndDragging:scrollView];
	float time = [[NSDate date]timeIntervalSince1970];
	NSLog(@"拖动结束%f",time);

}

#pragma mark - RRRefreshTableHeaderDelegate Methods

- (void)rrRefreshTableHeaderDidTriggerRefresh:(RRRefreshTableHeaderView*)view{
	if (_bIsLoading) {
		return;
	}
	
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
	点击新鲜事附件照片,查看照片
 */
- (void)onClickAttachView: (NSNumber *)userId photoId:(NSNumber *)photoId {
	if (userId && photoId) {
		NSString *userIdStr = [userId stringValue];
		NSString *photoIdStr = [photoId stringValue];
		RNPhotoViewController *viewController = [[RNPhotoViewController alloc]initWithUid:userIdStr
																				  withPid:photoIdStr
																				  shareId:nil 
																				 shareUid:nil];
		
		NSLog(@"进入照片内容页");
		//此处用AppDelegate presentModalViewController 否则支持横竖屏会有问题
		AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

		[appDelegate.mainViewController presentModalViewController:viewController animated:NO];
		TT_RELEASE_SAFELY(viewController);

	}
}

/*
	点击新鲜事标题,即相册名称,进入相册内容页
 */
- (void)onTapTitleLabel: (NSNumber *)userId albumId: (NSNumber *)photoId {
	if (userId && photoId) {
		NSMutableDictionary* dics = [NSMutableDictionary dictionary];
		[dics setObject:[RCMainUser getInstance].sessionKey forKey:@"session_key"];
		[dics setObject:photoId forKey:@"pid"];
		[dics setObject:userId forKey:@"uid"];
		
		RCGeneralRequestAssistant *mReqAssistant = [RCGeneralRequestAssistant requestAssistant];
		//    __block typeof(self) self = self;
		mReqAssistant.onCompletion = ^(NSDictionary* result){
			NSNumber *albumId = [result objectForKey:@"album_id"];
			RNAlbumWaterViewController *viewController = [[RNAlbumWaterViewController alloc]initWithUid:userId albumId:albumId];
			viewController.hidesBottomBarWhenPushed = YES;
			[self.navigationController pushViewController:viewController animated:YES];
			NSLog(@"进入相册内容页");
			//查看相册
			TT_RELEASE_SAFELY(viewController);
		};
		mReqAssistant.onError = ^(RCError* error) {
			NSLog(@"error....%@",error.titleForError);

		};
		[mReqAssistant sendQuery:dics withMethod:@"photos/get"];
	}

}
@end
