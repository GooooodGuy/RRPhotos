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
#import "UIImageView+RRWebImage.h"

@protocol RNNewsFeedCellDelegate <NSObject>

@optional
/*
	点击新鲜事附件照片的滚动
 */
- (void)onClickScrollView ;
@end

/*	-------------------------------------	*/
/*			新鲜事主列表的cell					*/
/*	-------------------------------------	*/

@interface RNNewsFeedCell : UITableViewCell
{
	//新鲜事主体数据
	RRNewsFeedItem *_newsFeedItem;
	
	//头像图片
	UIImageView *_headImageView;
	
	//好友姓名
	UILabel* _userNameLabel;
	
	//新鲜事时间
	UILabel* _newsFeedTimeLabel;
	
	//分享来源
	NSString* _fromAddress;
	
	//附件照片
	UITableView	*_attachmentsTableView;
}
@property(nonatomic,retain)RRNewsFeedItem *newsFeedItem;	
@property(nonatomic, retain) UIImageView *headImageView;
@property(nonatomic, copy) UILabel *userNameLabel;
@property(nonatomic, copy) UILabel *newsFeedTimeLabel;
@property(nonatomic, copy) NSString *fromAddress;
@property(nonatomic, retain)UITableView	*attachmentsTableView;


/*
	设置cell的数据
 */
- (void)setCellWithItem :(RRNewsFeedItem*)newsFeedItem;

@end

////////////////////////////////////////////////////////////////////////////////////////////////

/*	-------------------------------------	*/
/*			新鲜事主列表的cell					*/
/*	-------------------------------------	*/
@interface attachmentCell : UITableViewCell
{
	UIImageView *_bgImageView;
	
	UIImageView *_contentImageView;
}
@property(nonatomic,retain)UIImageView *bgImageView;
@property(nonatomic,retain)UIImageView *contentImageView;
@end

