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
#import "RRShareListItem.h"

@interface RNNewsFeedCell : UITableViewCell
{
	//头像图片
	RRImageView *_headImage;
	
	//好友姓名
	NSString* _userName;
	
	//新鲜事时间
	NSString* _newsFeedTime;
	
	//分享来源
	NSString* _fromAddress;
	
	//照片滚动控件
	RRCellScrollView *_cellScrollView;
}
	
@property(nonatomic, retain) RRImageView *headImage;

@property(nonatomic, copy) NSString *userName;

@property(nonatomic, copy) NSString *newsFeedTime;

@property(nonatomic, copy) NSString *fromAddress;

@property(nonatomic, retain) RRCellScrollView *cellScrollView;

- (id) initwithFriendItem :(id)object;
@end
