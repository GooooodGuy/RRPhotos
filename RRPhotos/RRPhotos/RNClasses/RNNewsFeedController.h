//
//  RNNewsFeedController.h
//  RRPhotos
//
//  Created by yi chen on 12-4-8.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNModelViewController.h"
#import "RNNewsFeedModel.h"
#import "RRNewsFeedItem.h"
#import "RNNewsFeedCell.h"
#import "RRRefreshTableHeaderView.h"
#import "RNHotShareViewController.h"
/*	-----------------------------------  */
/*		图片新鲜事主界面				     */
/*	-----------------------------------  */
@interface RNNewsFeedController : RNModelViewController
	<UITableViewDataSource,
	UITableViewDelegate,
	RNNewsFeedCellDelegate,
	RRRefreshTableHeaderDelegate>
{
	//新鲜事列表
	UITableView *_newFeedTableView;
	//下拉刷新
	RRRefreshTableHeaderView *_rrRefreshTableHeaderView;
	//正在更新列表数据标志
	BOOL _bIsLoading;
	
	//主界面容器，包括新鲜事列表
	UIViewController *_mainContainerController;
	//热门分享
	RNHotShareViewController *_hotShareViewController;
	//用于指示当前是好友动态还是热门分享
	UIViewController *_currentViewController;
}

@property(nonatomic,retain)UITableView *newsFeedTableView;
@property(nonatomic,retain)RRRefreshTableHeaderView *rrRefreshTableHeaderView;

@property(nonatomic,retain)UIViewController *mainContainerController;
@property(nonatomic,retain)RNHotShareViewController *hotShareViewController;
@property(nonatomic,retain)UIViewController *currentViewController;
@end
