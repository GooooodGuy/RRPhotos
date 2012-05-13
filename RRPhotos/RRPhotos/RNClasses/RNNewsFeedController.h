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
	//父controller
	UIViewController *_parentController;
	
	@private
	//新鲜事列表
	UITableView *_newFeedTableView;
	//下拉刷新
	RRRefreshTableHeaderView *_rrRefreshTableHeaderView;
	//正在更新列表数据标志
	BOOL _bIsLoading;
	
	//用户id
	NSNumber *_userId;
}
@property(nonatomic,assign)UIViewController *parentController;
@property(nonatomic,retain)UITableView *newsFeedTableView;
@property(nonatomic,retain)RRRefreshTableHeaderView *rrRefreshTableHeaderView;
@property(nonatomic,copy)NSNumber *userId;

/*
	@userId:用户的id
 */
- (id)initWithUserId:(NSNumber *)userId;
/*
	刷新数据
 */
- (void)refreshData;
@end
