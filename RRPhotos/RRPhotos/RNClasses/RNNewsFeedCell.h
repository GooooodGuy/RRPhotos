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


#define  kCellLeftPadding 10        // 内容左填充
#define  kCellTopPadding  20        //  内容顶部填充
#define  kCellBottomPadding 5       //  内容底部填充
#define  kCellRightPadding 5        //  内容右填充

#define  kCellHeadImageHeight 40    // 头像高度
#define  kCellHeadImageWidth 40     // 头像宽度 

#define  kCellHeadContentSpace  20     // 头像和滚动视图的空隙
#define  kCellContentViewPhotoCount  3 //滚动视图内的照片数量
#define  kCellContentViewHeight (kCellWidth / kCellContentViewPhotoCount)//多图片滚动视图高度
#define  kCellContentViewWidth  320.0

#define  kCellHeight  (kCellTopPadding + kCellHeadImageHeight + \
					kCellHeadContentSpace + kCellContentViewHeight ) //cell的高度
#define  kCellWidth  320

@protocol RNNewsFeedCellDelegate <NSObject>

@optional
/*
	点击新鲜事标题,即相册名称
	
 */
- (void)onTapTitleLabel: (NSNumber *)userId albumId: (NSNumber *)albumId ;

/*
	点击新鲜事附件照片
 */
- (void)onClickAttachView:(NSNumber *)userId photoId:(NSNumber *)photoId;

@end

/*	-------------------------------------	*/
/*			新鲜事主列表的cell					*/
/*	-------------------------------------	*/
@interface RNNewsFeedCell : UITableViewCell</*UITableViewDataSource,UITableViewDelegate,*/RRAttachScrollViewDelegate>
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
@property(nonatomic, assign)id<RNNewsFeedCellDelegate>delegate;


/*
	设置cell的数据
 */
- (void)setCellWithItem :(RRNewsFeedItem*)newsFeedItem;

@end

////////////////////////////////////////////////////////////////////////////////////////////////

/*	-------------------------------------	*/
/*			新鲜事主列表的照片附件cell			*/
/*	-------------------------------------	*/
@interface RNAttachmentCell : UITableViewCell
{
	UIImageView *_contentImageView;
}
@property(nonatomic,retain)UIImageView *bgImageView;
@property(nonatomic,retain)UIImageView *contentImageView;
@end

