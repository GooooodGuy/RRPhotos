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
@interface RNNewsFeedController : RNModelViewController
	<UITableViewDataSource,
	UITableViewDelegate,
	RNNewsFeedCellDelegate,
	RRRefreshTableHeaderDelegate>
{
	UIButton *testButton;
	
	//新鲜事列表
	UITableView *_newFeedTableView;
	
	//下拉刷新
	RRRefreshTableHeaderView *_rrRefreshTableHeaderView;
	//正在更新列表数据标志
	BOOL _bIsLoading;
}
@property(nonatomic,retain)UIButton *testButton;
@property(nonatomic,retain)UITableView *newsFeedTableView;
@property(nonatomic,retain)RRRefreshTableHeaderView *rrRefreshTableHeaderView;
@end
