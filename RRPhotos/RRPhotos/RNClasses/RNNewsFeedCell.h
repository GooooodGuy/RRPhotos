//
//  RNNewsFeedCell.h
//  RRPhotos
//
//  Created by yi chen on 12-3-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRImageView.h"
#import "RRAttachScrollView.h"
#import "RRNewsFeedItem.h"
#import "UIImageView+RRWebImage.h"

@protocol RNNewsFeedCellDelegate <NSObject>

@optional

/*
	点击新鲜事标题,即相册名称

 */
- (void)onTapTitleLabel: (NSNumber *)userId albumId: (NSNumber *)photoId ;

/*
	点击新鲜事附件照片
 */
- (void)onTapAttachView:(NSNumber *)userId photoId:(NSNumber *)photoId;


/*
	点击头像
 */
- (void)onTapHeadImageView:(NSNumber *)userId;

- (void)onTapHeadImageView:(NSNumber *)userId userName:(NSString *)userName;
@end

/*	-------------------------------------	*/
/*			新鲜事主列表的cell					*/
/*	-------------------------------------	*/
@interface RNNewsFeedCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate,RRAttachScrollViewDelegate>
{
	//新鲜事主体数据
	RRNewsFeedItem *_newsFeedItem;
	//头像图片
	UIImageView *_headImageView;
	//好友姓名
	UILabel* _userNameLabel;
	//新鲜事内容前缀
	UILabel	*_prefixLabel;
	//新鲜事主体内容
	UILabel *_titleLabel;
	//新鲜事时间
	UILabel *_updateTimeLabel;
	//分享来源
	NSString *_fromAddress;
	//附件照片
	UITableView	*_attachmentsTableView;
	//附件照片滚动视图
	RRAttachScrollView *_attachScrollView;
	//评论列表
	UITableView *_commentsTableView;
	
	id<RNNewsFeedCellDelegate> _delegate;
}
@property(nonatomic, retain)RRNewsFeedItem *newsFeedItem;	
@property(nonatomic, retain)UIImageView *headImageView;
@property(nonatomic, retain)UILabel *userNameLabel;
@property(nonatomic, retain)UILabel *prefixLabel;
@property(nonatomic, retain)UILabel *titleLabel;
@property(nonatomic, retain)UILabel *updateTimeLabel;
@property(nonatomic, copy)NSString *fromAddress;
@property(nonatomic, retain)UITableView	*attachmentsTableView;
@property(nonatomic, retain)RRAttachScrollView *attachScrollView;
@property(nonatomic, retain)UITableView *commentTableView;
@property(nonatomic, assign)id<RNNewsFeedCellDelegate>delegate;

/*
	设置cell的数据
 */
- (void)setCellWithItem :(RRNewsFeedItem*)newsFeedItem;

@end

////////////////////////////////////////////////////////////////////////////////////////////////

