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
#define kTableViewBgColor RGBCOLOR(222, 222, 222)
#define kHotShareViewTag 10001
#define kNewsFeedViewTag 10002
@interface RNNewsFeedController ()

@end

@implementation RNNewsFeedController
@synthesize newsFeedTableView = _newFeedTableView;
@synthesize rrRefreshTableHeaderView = _rrRefreshTableHeaderView;
@synthesize parentController = _parentController;
@synthesize userId = _userId;
- (void)dealloc{
	self.newsFeedTableView = nil;
	self.rrRefreshTableHeaderView = nil;
	self.parentController = nil;
	self.userId = nil;
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
/*
	@userId:用户的id
 */
- (id)initWithUserId:(NSNumber *)userId{
	if (userId) {
		self.userId = userId;
	}
	if (self = [super init]) {
		
	}
	return self;
}

- (void)loadView{
	[super loadView];
	self.view.backgroundColor = [UIColor blackColor];
	self.navBar.hidden = YES; //采用系统的navbar
	
	[self.view addSubview:self.newsFeedTableView];
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
		newsFeedTableView.backgroundColor = kTableViewBgColor;
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
		view.backgroundColor = kTableViewBgColor;
		
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
	
}


- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 网络
/*
	重载父类的创建model
 */
- (void)createModel {
	
	//新鲜事类型
	NSString *typeString = ITEM_TYPES_NEWSFEED_FOR_PHOTO;//只请求与照片有关的数据
	RNNewsFeedModel *model = nil;

	if (self.userId) {
		NSLog(@"userid = %@",self.userId);
		//某个指定id的新鲜事
		model = [[RNNewsFeedModel alloc]initWithTypeString:typeString 
											userId:self.userId];

	}else {
		//自己的新鲜事
		model = [[RNNewsFeedModel alloc]initWithTypeString:typeString];
	}

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

#pragma mark - 刷新

/*
	刷新数据
 */
- (void)refreshData{
	if (_bIsLoading) {
		return;
	}
	
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

	return [self tableView: self.newsFeedTableView cellForRowAtIndexPath:indexPath].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *cellIdentifier  = @"newsFeedCell";
	
	RNNewsFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	NSLog(@"row = %d",indexPath.row);

	if (!cell) {
		cell = [[[RNNewsFeedCell alloc]initWithStyle:UITableViewCellStyleDefault 
									 reuseIdentifier:cellIdentifier]autorelease];
		cell.delegate = self;
	}
	RRNewsFeedItem *item = [[(RNNewsFeedModel *)self.model newsFeeds]objectAtIndex:indexPath.row];
	[cell setCellWithItem:item]; 
	if (0 == (indexPath.row % 2)) {
		cell.contentView.backgroundColor = RGBCOLOR(200, 200, 200);
	}else {
		cell.contentView.backgroundColor = kTableViewBgColor;
	}
//	cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
	return cell;	
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	// 列表拖动
	[self.rrRefreshTableHeaderView rrRefreshScrollViewDidScroll:scrollView];
//	float time = [[NSDate date]timeIntervalSince1970];
//	NSLog(@"拖动开始%f",time);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	// 拖动结束
	[self.rrRefreshTableHeaderView rrRefreshScrollViewDidEndDragging:scrollView];
//	float time = [[NSDate date]timeIntervalSince1970];
//	NSLog(@"拖动结束%f",time);

}

#pragma mark - RRRefreshTableHeaderDelegate Methods

- (void)rrRefreshTableHeaderDidTriggerRefresh:(RRRefreshTableHeaderView*)view{
	if (_bIsLoading) {
		return;
	}
	
	[self.model load:YES];// 加载数据
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
- (void)onTapAttachView: (NSNumber *)userId photoId:(NSNumber *)photoId {
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
			RNAlbumWaterViewController *viewController = [[RNAlbumWaterViewController alloc]initWithUid:userId
																								albumId:albumId];
			viewController.hidesBottomBarWhenPushed = YES;
			NSLog(@"cy ----------%@",self.parentController.navigationController);
			if (self.navigationController) {
				[self.navigationController pushViewController:viewController animated:YES];
			}else {
				[self.parentController.navigationController pushViewController:viewController animated:YES];
			}
			NSLog(@"cy-------------进入相册内容页");
			//查看相册
			TT_RELEASE_SAFELY(viewController);
		};
		mReqAssistant.onError = ^(RCError* error) {
			NSLog(@"error....%@",error.titleForError);
			UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"网络加载错误" 
																message:nil 
															   delegate:nil 
													  cancelButtonTitle:@"确定" 
													  otherButtonTitles:nil];
			[errorAlert show];
			TT_RELEASE_SAFELY(errorAlert);
		};
		[mReqAssistant sendQuery:dics withMethod:@"photos/get"];
	}

}

/*
	点击头像,进入某个用户的个人主页
 */
- (void)onTapHeadImageView:(NSNumber *)userId{
	if (!userId) {
		return;
	}
	
	RNNewsFeedController *newsFeedController = [[RNNewsFeedController alloc]initWithUserId:userId];
	newsFeedController.hidesBottomBarWhenPushed = YES;
	newsFeedController.parentController = self;
	[self.parentController.navigationController pushViewController:newsFeedController animated:YES];
	TT_RELEASE_SAFELY(newsFeedController);
}

@end
