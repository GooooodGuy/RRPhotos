//
//  RNNewsFeedCell.m
//  RRPhotos
//
//  Created by yi chen on 12-3-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RNNewsFeedCell.h"

static const CGFloat kCellLeftPadding = 5;          // 左填充
static const CGFloat kCellTopPadding = 5;           // 顶部填充
static const CGFloat kCellBottomPadding = 5;        // 底部填充
static const CGFloat kCellRightPadding = 5;         // 右填充

static const CGFloat kCellWidth = 320;              // cell宽度
static const CGFloat kCellHeight = 120;				// cell高度

static const CGFloat kCellHeadImageHeight = 40;     // 头像高度
static const CGFloat kCellHeadImageWidth = 40;      // 头像宽度 

static const CGFloat kCellHeadScrollSpace = 10;     // 头像和滚动视图的空隙

static const CGFloat kCellScrollViewHeight = kCellHeight - kCellHeight - kCellHeadImageHeight;    //多图片滚动视图高度



@implementation RNNewsFeedCell

@synthesize headImage = _headImage;
@synthesize userName = _userName;
@synthesize newsFeedTime = _newsFeedTime;
@synthesize fromAddress = _fromAddress;
@synthesize cellScrollView = _cellScrollView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id) initwithFriendItem :(id)object{
//	if ([object isKindOfClass:RRShareListItem.class]) {
//		//init
//	}
	return nil;
}
@end
