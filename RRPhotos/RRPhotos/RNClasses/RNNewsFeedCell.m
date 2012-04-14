//
//  RNNewsFeedCell.m
//  RRPhotos
//
//  Created by yi chen on 12-3-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RNNewsFeedCell.h"
#import <QuartzCore/QuartzCore.h>
static const CGFloat kCellHeight = 80; //cell的高度
static const CGFloat kCellWidth = 320;

static const CGFloat kCellLeftPadding = 50;         // 内容左填充
static const CGFloat kCellTopPadding = 5;           //  内容顶部填充
static const CGFloat kCellBottomPadding = 5;        //  内容底部填充
static const CGFloat kCellRightPadding = 5;         //  内容右填充

static const CGFloat kCellHeadImageHeight = 40;     // 头像高度
static const CGFloat kCellHeadImageWidth = 40;      // 头像宽度 

static const CGFloat kCellHeadScrollSpace = 10;     // 头像和滚动视图的空隙

static const CGFloat kCellScrollViewHeight = kCellHeight - kCellHeight - kCellHeadImageHeight;    //多图片滚动视图高度



@implementation RNNewsFeedCell

@synthesize newsFeedItem = _newsFeedItem;
@synthesize headImageView = _headImageView;
@synthesize userNameLabel = _userNameLabel;
@synthesize newsFeedTimeLabel = _newsFeedTimeLabel;
@synthesize fromAddress = _fromAddress;
@synthesize cellScrollView = _cellScrollView;

- (void)dealloc{
	
	self.newsFeedItem = nil;
	self.headImageView = nil;
	self.userNameLabel = nil;
	self.newsFeedTimeLabel = nil;
	self.fromAddress = nil;
	self.cellScrollView = nil;
	[super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews{
	[super layoutSubviews];

	self.detailTextLabel.backgroundColor = [UIColor clearColor];
	self.textLabel.backgroundColor = [UIColor clearColor];
	self.selectionStyle = UITableViewCellSelectionStyleBlue; 
	self.backgroundColor = [UIColor clearColor];
    self.accessoryType = UITableViewCellAccessoryNone;

	self.headImageView.backgroundColor = [UIColor clearColor];	
	CALayer *layer = [self.headImageView.imageView layer];
	[layer setCornerRadius:6.0];

}

/*
 设置cell的数据
 */
- (void)setCellWithItem :(RRNewsFeedItem*)newsFeedItem{
	if (!newsFeedItem) {
		return;
	}
	
	self.newsFeedItem = newsFeedItem;
	
	//头像
	if(self.newsFeedItem.headUrl){ 
		[self.headImageView loadImageWithUrl:self.newsFeedItem.headUrl isUseCache:YES];
	}
	[self.headImageView setDefaultImage:[UIImage imageNamed:@"main_head_profile.png"]];
	

	//用户名
	if (self.newsFeedItem.userName && self.newsFeedItem.prefix) {
		self.userNameLabel.text = [NSString stringWithFormat:@"%@-%@", 
								   self.newsFeedItem.userName,self.newsFeedItem.prefix];
	}
	
	[self layoutIfNeeded];
	[self.contentView addSubview:_userNameLabel];
	[self.contentView addSubview:_headImageView];

}

/*
	头像的view
 */
- (RRImageView *)headImageView{
	if (!_headImageView) {
		_headImageView = [[RRImageView alloc]initWithFrame:CGRectMake(kCellLeftPadding,
																  kCellTopPadding,
																  kCellHeadImageWidth, 
																  kCellHeadImageHeight)];
		CALayer *layer = [self.headImageView.imageView layer];
        [layer setCornerRadius:6.0];

	}
	return _headImageView;
}

- (UILabel *)userNameLabel{
	if (!_userNameLabel) {
		_userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100,
																  kCellTopPadding,
																  200, 
																  kCellHeadImageHeight)];
		_userNameLabel.backgroundColor = [UIColor clearColor];
		_userNameLabel.textColor = [UIColor blackColor];
	}
	 
	return _userNameLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
