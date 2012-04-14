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
@interface RNNewsFeedController : RNModelViewController<UITableViewDataSource,UITableViewDelegate>
{
	UIButton *testButton;
	
	//新鲜事列表
	UITableView *_newFeedTableView;
	
}
@property(nonatomic,retain)UIButton *testButton;

@property(nonatomic,retain)UITableView *newsFeedTableView;

@end
