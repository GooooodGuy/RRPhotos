//
//  RNNewsFeedCell.m
//  RRPhotos
//
//  Created by yi chen on 12-3-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RNNewsFeedCell.h"
#import <QuartzCore/QuartzCore.h>
static const CGFloat kCellHeight = 150; //cell的高度
static const CGFloat kCellWidth = 320;

static const CGFloat kCellLeftPadding = 50;         // 内容左填充
static const CGFloat kCellTopPadding = 5;           //  内容顶部填充
static const CGFloat kCellBottomPadding = 5;        //  内容底部填充
static const CGFloat kCellRightPadding = 5;         //  内容右填充

static const CGFloat kCellHeadImageHeight = 40;     // 头像高度
static const CGFloat kCellHeadImageWidth = 40;      // 头像宽度 

static const CGFloat kCellHeadContentSpace = 10;     // 头像和滚动视图的空隙
static const CGFloat kCellContentViewHeight = (kCellHeight - kCellHeadContentSpace  - kCellHeadImageHeight);    //多图片滚动视图高度
static const CGFloat kCellContentViewWidth = 320;
static const NSInteger kContentViewPhotoCount = 3;	//滚动视图内的照片数量


@implementation RNNewsFeedCell

@synthesize newsFeedItem = _newsFeedItem;
@synthesize headImageView = _headImageView;
@synthesize userNameLabel = _userNameLabel;
@synthesize newsFeedTimeLabel = _newsFeedTimeLabel;
@synthesize fromAddress = _fromAddress;
@synthesize attachmentsTableView = _attachmentsTableView;

- (void)dealloc{
	self.newsFeedItem = nil;
	self.headImageView = nil;
	self.userNameLabel = nil;
	self.newsFeedTimeLabel = nil;
	self.fromAddress = nil;
	self.attachmentsTableView = nil;
	
	[super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
	
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
	CALayer *layer = [self.headImageView layer];
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

	if (self.newsFeedItem.headUrl) {
		[self.headImageView setImageWithURL:[NSURL URLWithString:self.newsFeedItem.headUrl]
						   placeholderImage:[UIImage imageNamed:@"main_head_profile.png"]];
	}
	
	//用户名
	if (self.newsFeedItem.userName && self.newsFeedItem.prefix) {
		self.userNameLabel.text = [NSString stringWithFormat:@"%@-%@", 
								   self.newsFeedItem.userName,self.newsFeedItem.prefix];
	}

		
	[self.contentView removeAllSubviews];
	[self.contentView addSubview:self.userNameLabel];
	[self.contentView addSubview:self.headImageView];
	
}

/*
	头像的view
 */
- (UIImageView *)headImageView{
	if (!_headImageView) {
		_headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kCellLeftPadding,
																  kCellTopPadding,
																  kCellHeadImageWidth, 
																  kCellHeadImageHeight)];
		CALayer *layer = [self.headImageView layer];
        [layer setCornerRadius:6.0];

	}
	return _headImageView;
}

/*
	用户名标签
 */
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

////////////////////////////////////////////////////////////////////////////////////////////////

/*	-------------------------------------	*/
/*			新鲜事主列表的cell					*/
/*	-------------------------------------	*/
@implementation attachmentCell
@synthesize bgImageView = _bgImageView;
@synthesize contentImageView = _contentImageView;

- (void)dealloc{
	self.bgImageView = nil;
	self.contentImageView = nil;
	[super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.contentView.backgroundColor = [UIColor clearColor];
        UIView *selectedView = [[UIView alloc] initWithFrame:self.contentView.frame];
        selectedView.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = selectedView;
        [selectedView release];

		_bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5,
																   5, 
																   kCellContentViewHeight, 
																   50)];
		_bgImageView.backgroundColor = [UIColor grayColor];
		[self addSubview:_bgImageView];
		
//		_contentImageView = [[UIImageView alloc]initWithImage:CGRectMake(5,
//																		5, 
//																		kCellContentViewHeight, 
//																		50)];
	}
	return self;
}
@end





