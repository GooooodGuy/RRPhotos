//
//  RNNewsFeedCell.m
//  RRPhotos
//
//  Created by yi chen on 12-3-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RNNewsFeedCell.h"
#import "RNCommentListCell.h"
#import <QuartzCore/QuartzCore.h>

#define  kCellLeftPadding 2        // 内容左填充
#define  kCellTopPadding  20        //  内容顶部填充
#define  kCellBottomPadding 5       //  内容底部填充
#define  kCellRightPadding 5        //  内容右填充

#define  kCellHeadImageHeight 40    // 头像高度
#define  kCellHeadImageWidth 40		// 头像宽度 

#define  kCellHeadContentSpace  10     // 头像和滚动视图的空隙
#define  kCellContentViewPhotoCount  3 //滚动视图内的照片数量
//多图片滚动视图高度
#define  kCellContentViewHeight (kCellWidth / kCellContentViewPhotoCount)
#define  kCellContentViewWidth  300

//评论列表的高度
#define  kCellCommentTableViewHeight 100

#define  kCellHeight  (kCellTopPadding + kCellHeadImageHeight + \
kCellHeadContentSpace + kCellContentViewHeight ) //cell的高度

#define  kCellWidth  320


@interface RNNewsFeedCell(/*私有方法*/)

@end

@implementation RNNewsFeedCell

@synthesize newsFeedItem = _newsFeedItem;
@synthesize headImageView = _headImageView;
@synthesize userNameLabel = _userNameLabel;
@synthesize prefixLabel = _prefixLabel;
@synthesize titleLabel = _titleLabel;
@synthesize updateTimeLabel = _updateTimeLabel;
@synthesize fromAddress = _fromAddress;
@synthesize attachmentsTableView = _attachmentsTableView;
@synthesize attachScrollView = _attachScrollView;
@synthesize commentTableView = _commentsTableView;
@synthesize delegate = _delegate;
- (void)dealloc{
	self.newsFeedItem = nil;
	self.headImageView = nil;
	self.userNameLabel = nil;
	self.prefixLabel = nil;
	self.titleLabel = nil;
	self.updateTimeLabel = nil;
	self.fromAddress = nil;
	self.attachmentsTableView = nil;
	self.attachScrollView = nil;
	self.commentTableView = nil;
	self.delegate = nil;
	
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
	self.selectionStyle = UITableViewCellSelectionStyleNone; 
	self.backgroundColor = [UIColor clearColor];

    self.accessoryType = UITableViewCellAccessoryNone;
	
	NSString *s = self.prefixLabel.text;
	UIFont *font = self.prefixLabel.font;
	CGSize singleLineStringSize = [s sizeWithFont:font];
	self.prefixLabel.width = singleLineStringSize.width;
	self.titleLabel.left = self.prefixLabel.right;
	self.titleLabel.width = kCellWidth - self.prefixLabel.right ;
	self.commentTableView.top = self.attachScrollView.bottom + 5;
	
	//计算总的cell高度
	CGFloat height = 0;
	
	if (0 != [self.newsFeedItem.commentListArray count]) {
		height += kCellCommentTableViewHeight; //加上评论列表的高度
		height = self.commentTableView.bottom;

	}else {
		height = self.attachScrollView.bottom;
	}
	self.height = height;
}

/*
	设置cell的数据
 */
- (void)setCellWithItem :(RRNewsFeedItem*)newsFeedItem{
	if (!newsFeedItem) {
		return;
	}
	
	//新鲜事主题的数据结构存储
	self.newsFeedItem = newsFeedItem;

	[self.contentView removeAllSubviews];
	[self.contentView addSubview:self.userNameLabel];
	[self.contentView addSubview:self.headImageView];
	[self.contentView addSubview:self.prefixLabel];
	[self.contentView addSubview:self.titleLabel];
	[self.contentView addSubview:self.updateTimeLabel];
	[self.contentView addSubview:self.attachScrollView];
	//头像
	if (self.newsFeedItem.headUrl) {
		[self.headImageView setImageWithURL:[NSURL URLWithString:self.newsFeedItem.headUrl]
						   placeholderImage:[UIImage imageNamed:@"main_head_profile.png"]];
	}
	
	//用户名
	if (self.newsFeedItem.userName ) {
		self.userNameLabel.text = self.newsFeedItem.userName;
	}
	
	if (self.newsFeedItem.prefix) {
		NSMutableString  *prefixAndTitleString = [NSMutableString stringWithString: self.newsFeedItem.prefix];
		self.prefixLabel.text  = prefixAndTitleString;
	}

	self.titleLabel.text = self.newsFeedItem.title;
		
	if (self.newsFeedItem.updateTime) {
		self.updateTimeLabel.text = [self.newsFeedItem.updateTime stringForSectionTitle3];
	}
	
	if (self.newsFeedItem.attachments) {
		//重置滚动试图里面的照片
		if ([self.newsFeedItem.attachments count] < 3) {
			self.attachScrollView.height = 320;
		}else {
			self.attachScrollView.height = kCellContentViewHeight;
		}
		[self.attachScrollView setWithAttachments:self.newsFeedItem.attachments];
	}
	
	if ([self.newsFeedItem.commentListArray count] != 0) {
		NSLog(@"评论数为%d",[self.newsFeedItem.commentListArray count] );
		//评论列表
		[self.contentView addSubview:self.commentTableView];
		[self.commentTableView reloadData];
	}
	
	[self layoutIfNeeded];
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
		CALayer* layer = [_headImageView layer];
		[layer setCornerRadius:4.0];
		layer.masksToBounds = YES;
		
		//点击头像，进入某个用户的主页
		_headImageView.userInteractionEnabled = YES;
		[_headImageView addTargetForTouch:self action:@selector(onTapHeadImageView:)];
	}
	return _headImageView;
}

/*
	用户名标签
 */
- (UILabel *)userNameLabel{
	if (!_userNameLabel) {
		_userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60,
																  kCellTopPadding,
																  200, 
																  kCellHeadImageHeight / 2)];
		
		_userNameLabel.backgroundColor = [UIColor clearColor];
		_userNameLabel.textColor = RGBCOLOR(0, 229 ,238);
		_userNameLabel.font = [UIFont systemFontOfSize:15];
		
		//添加点击事件，和头像点击事件一样
		_userNameLabel.userInteractionEnabled = YES;
		UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc]   
											  initWithTarget:self action:@selector(onTapHeadImageView:)]autorelease];
		[_userNameLabel addGestureRecognizer:singleTap]; 
	}
	 
	return _userNameLabel;
}

/*
	新鲜事更新时间
 */
- (UILabel *)updateTimeLabel{
	if (!_updateTimeLabel) {
		_updateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kCellWidth - 60, 
																   self.userNameLabel.top,
																   60,
																   20)];
		_updateTimeLabel.textColor = RGBCOLOR(100, 100,100);
		_updateTimeLabel.font = [UIFont fontWithName:MED_HEITI_FONT size:10];
		_updateTimeLabel.backgroundColor = [UIColor clearColor];
	}
	return _updateTimeLabel;
}

/*
	新鲜事内容前缀
 */
- (UILabel *)prefixLabel{
	if (!_prefixLabel) {
		_prefixLabel = [[UILabel alloc]initWithFrame:CGRectMake(70,
																kCellTopPadding + self.userNameLabel.height,
																kCellWidth - kCellLeftPadding - 70, 
																kCellHeadImageHeight / 2)];
		_prefixLabel.textColor = RGBCOLOR(100, 100, 100);
		_prefixLabel.font = [UIFont fontWithName:MED_HEITI_FONT size:12];
		_prefixLabel.backgroundColor = [UIColor clearColor];
	}
	return _prefixLabel;
}

/*
	新鲜事主体内容
 */
- (UILabel *)titleLabel{
	
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.prefixLabel.right + 10, 
															  self.prefixLabel.origin.y, 
															  100, 
															  kCellHeadImageHeight / 2)];
		_titleLabel.textColor = RGBCOLOR(120, 150, 100);
		_titleLabel.font = [UIFont fontWithName:MED_HEITI_FONT size:13];
		_titleLabel.backgroundColor = [UIColor clearColor];
		_titleLabel.userInteractionEnabled = YES;
		//添加点击事件
		UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc]   
											  initWithTarget:self action:@selector(onTapTitleLabel)]autorelease];
		[_titleLabel addGestureRecognizer:singleTap]; 
	}
	return _titleLabel;
}

/*
	点击标题,将进入相册内容页面（流式布局）
 */
- (void)onTapTitleLabel{
	//暂时这样处理，日后想办法改进
	RRAttachmentItem *item = self.newsFeedItem.firstAttachment;
	NSNumber *mediaId = item.mediaId;
	NSNumber *userId = item.ownerId;
	
	if ([self.delegate respondsToSelector:@selector(onTapTitleLabel:albumId:)]) {
		[self.delegate onTapTitleLabel:userId albumId:mediaId];
	}
}

/*
	点击头像/点击用户名称
 */
- (void)onTapHeadImageView:(id) sender{
	NSNumber *userId = self.newsFeedItem.userId;
	if (!userId) {
		return;
	}
	if ([self.delegate respondsToSelector:@selector(onTapHeadImageView:)]) {
		[self.delegate onTapHeadImageView:userId];
	}
}
/*
	附件照片滚动视图
 */
- (RRAttachScrollView *)attachScrollView{
		
	if (!_attachScrollView) {
		_attachScrollView = [[RRAttachScrollView alloc]initWithFrame:CGRectMake(10, 
																			   kCellHeadImageHeight + kCellTopPadding + kCellHeadContentSpace,
																			   kCellContentViewWidth, 
																				kCellContentViewHeight)];
		_attachScrollView.attachScrollViewDelgate  = self;
	}
	return _attachScrollView;
}

- (UITableView *)commentTableView{
	if (!_commentsTableView) {
		
		_commentsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 
																		 0, 
																		 PHONE_SCREEN_SIZE.width, 
																		 80) 
														 style:UITableViewStylePlain];
		_commentsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		_commentsTableView.backgroundColor = [UIColor clearColor];
		_commentsTableView.delegate = self;
		_commentsTableView.dataSource = self;
	}
	return _commentsTableView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	
	return 1;
}// Default is 1 if not implemented

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	NSLog(@"indexPath %@",indexPath);
	return [self tableView:self.commentTableView cellForRowAtIndexPath:indexPath].height;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	NSInteger numberOfRows = [self.newsFeedItem.commentListArray count] ;
	//最多显示三行评论
	numberOfRows =  numberOfRows > 2 ? 2 : numberOfRows ;
	NSLog(@"评论数目为%d",numberOfRows);

	return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	NSLog(@"indexpath = %@",indexPath);
	static NSString *cellIdentifier = @"commentListIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[[RNCommentListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
	}
	
	[((RNCommentListCell *)cell) setCellWithItem:[self.newsFeedItem.commentListArray objectAtIndex:indexPath.row]];

	return cell;
}

#pragma mark - RRAttachScrollViewDelegate
/**
 * 点击附件照片
 */
- (void)tapAttachImageAtIndex:(NSInteger)index andAttachItem:(RRAttachmentItem *)item{
	
	NSNumber *mediaId = item.mediaId;
	NSNumber *userId = item.ownerId;
	if (self.delegate && [self.delegate respondsToSelector:@selector(onTapAttachView:photoId:)]) {
		[self.delegate onTapAttachView:userId photoId:mediaId];
	}
}


@end

////////////////////////////////////////////////////////////////////////////////////////////////




