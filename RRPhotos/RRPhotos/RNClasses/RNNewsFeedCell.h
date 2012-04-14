//
//  RNNewsFeedCell.h
//  RRPhotos
//
//  Created by yi chen on 12-3-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRImageView.h"
#import "RRCellScrollView.h"
#import "RRNewsFeedItem.h"
@interface RNNewsFeedCell : UITableViewCell
{
	//新鲜事主体数据
	RRNewsFeedItem *_newsFeedItem;
	
	//头像图片
	RRImageView *_headImageView;
	
	//好友姓名
	UILabel* _userNameLabel;
	
	//新鲜事时间
	UILabel* _newsFeedTimeLabel;
	
	//分享来源
	NSString* _fromAddress;
	
	//照片滚动控件
	RRCellScrollView *_cellScrollView;
}
@property(nonatomic,retain)RRNewsFeedItem *newsFeedItem;	

@property(nonatomic, retain) RRImageView *headImageView;

@property(nonatomic, copy) UILabel *userNameLabel;

@property(nonatomic, copy) UILabel *newsFeedTimeLabel;

@property(nonatomic, copy) NSString *fromAddress;

@property(nonatomic, retain) RRCellScrollView *cellScrollView;

/*
	设置cell的数据
 */
- (void)setCellWithItem :(RRNewsFeedItem*)newsFeedItem;

@end
