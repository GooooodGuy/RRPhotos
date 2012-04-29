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

static const CGFloat kCellLeftPadding = 20;         // 内容左填充
static const CGFloat kCellTopPadding = 5;           //  内容顶部填充
static const CGFloat kCellBottomPadding = 5;        //  内容底部填充
static const CGFloat kCellRightPadding = 5;         //  内容右填充

static const CGFloat kCellHeadImageHeight = 40;     // 头像高度
static const CGFloat kCellHeadImageWidth = 40;      // 头像宽度 

static const CGFloat kCellHeadContentSpace = 10;     // 头像和滚动视图的空隙
static const CGFloat kCellContentViewHeight = (kCellHeight - kCellHeadContentSpace  - kCellHeadImageHeight);    //多图片滚动视图高度
static const CGFloat kCellContentViewWidth = 320;
static const NSInteger kCellContentViewPhotoCount = 3;	//滚动视图内的照片数量


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
	self.selectionStyle = UITableViewCellSelectionStyleNone; 
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

	//头像
	if (self.newsFeedItem.headUrl) {
		[self.headImageView setImageWithURL:[NSURL URLWithString:self.newsFeedItem.headUrl]
						   placeholderImage:[UIImage imageNamed:@"main_head_profile.png"]];
	}
	
	//用户名
	if (self.newsFeedItem.userName && self.newsFeedItem.prefix) {
		self.userNameLabel.text = [NSString stringWithFormat:@"%@-%@", 
								   self.newsFeedItem.userName,self.newsFeedItem.prefix];
	}
	
	//新鲜事主体，照片附件,加载图片
	if (self.newsFeedItem.attachments) {	
		[self.attachmentsTableView reloadData];
	}


	[self.contentView removeAllSubviews];
	[self.contentView addSubview:self.userNameLabel];
	[self.contentView addSubview:self.headImageView];
	[self.contentView addSubview:self.attachmentsTableView];
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

- (UITableView *)attachmentsTableView{
	
	if (!_attachmentsTableView) {
		
		_attachmentsTableView = [[UITableView alloc]initWithFrame:CGRectMake(kCellHeadImageHeight + kCellHeadContentSpace, 
																			 0,
																			 kCellContentViewHeight, 
																			 kCellContentViewWidth)
															style:UITableViewStylePlain];

		_attachmentsTableView.dataSource = self;
		_attachmentsTableView.delegate = self;

		//旋转90度
		CGRect  r = _attachmentsTableView.frame;
		CGFloat new_x = r.origin.y;
		CGFloat new_y = r.origin.x;
		NSLog(@"变换之前---------------x = %f y = %f width = %f height = %f",r.origin.x,r.origin.y,r.size.width,r.size.height);

		_attachmentsTableView.transform = CGAffineTransformRotate(self.transform, - M_PI / 2);
		r = _attachmentsTableView.frame;
		NSLog(@"90旋转变化之后---------------x = %f y = %f width = %f height = %f",r.origin.x,r.origin.y,r.size.width,r.size.height);

		
		_attachmentsTableView.frame = CGRectMake(new_x, new_y, r.size.width, r.size.height);
		r = _attachmentsTableView.frame;
		
		NSLog(@"最终调整变化之后---------------x = %f y = %f width = %f height = %f",r.origin.x,r.origin.y,r.size.width,r.size.height);

		// scrollbar 不显示
		_attachmentsTableView.showsVerticalScrollIndicator = NO;
		_attachmentsTableView.showsHorizontalScrollIndicator = NO;
	}
	return _attachmentsTableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	//照片数目
	NSInteger count = [self.newsFeedItem.attachments count];
	NSLog(@"附件的cell数目 %d",count);
	return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}// Default is 1 if not implemented

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"section = %d row = %d",indexPath.section, indexPath.row);
	static NSString *AttachmentCellIdentifier = @"AttachmentsViewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AttachmentCellIdentifier];
	if (!cell) {
		cell = [[[RNAttachmentCell alloc]initWithStyle:UITableViewCellStyleDefault 
									 reuseIdentifier:AttachmentCellIdentifier]autorelease];
	}
	
	if (indexPath.row < [self.newsFeedItem.attachments count]) {
		id attachment = [self.newsFeedItem.attachments objectAtIndex:indexPath.row];
		if (attachment && [attachment isKindOfClass:RRAttachment.class]) {
			NSURL *url = [NSURL URLWithString:[(RRAttachment*)attachment main_url]];
			[((RNAttachmentCell *)cell).contentImageView setImageWithURL:url];
		}

	}
		
	cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];

	return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	//最多每次只显示三张
	return kCellContentViewWidth / 3;
}
@end

////////////////////////////////////////////////////////////////////////////////////////////////

/*	-------------------------------------	*/
/*			新鲜事主列表的照片附件cell			*/
/*	-------------------------------------	*/
@implementation RNAttachmentCell
@synthesize bgImageView = _bgImageView;
@synthesize contentImageView = _contentImageView;

- (void)dealloc{

	self.contentImageView = nil;
	[super dealloc];
}

- (void)layoutSubviews{
	
	[super layoutSubviews];
	
	self.detailTextLabel.backgroundColor = [UIColor clearColor];
	self.textLabel.backgroundColor = [UIColor clearColor];
	self.selectionStyle = UITableViewCellSelectionStyleNone; 
	self.backgroundColor = [UIColor clearColor];
    self.accessoryType = UITableViewCellAccessoryNone;
	
	UIView *selectedView = [[UIView alloc] initWithFrame:self.contentView.frame];
	selectedView.backgroundColor = [UIColor clearColor];
	self.selectedBackgroundView = selectedView;
	[selectedView release];
	
	[self.contentView removeAllSubviews];
	[self.contentView addSubview:self.contentImageView];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
				
	}
	return self;
}

- (UIImageView *)contentImageView{
	if (!_contentImageView) {
		_contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,kCellContentViewHeight,  kCellContentViewWidth / 3)];
		CGRect r = _contentImageView.frame;
		NSLog(@"contentImageView---------------x = %f y = %f width = %f height = %f",r.origin.x,r.origin.y,r.size.width,r.size.height);
		_contentImageView.transform = CGAffineTransformRotate(self.transform,  M_PI / 2);
	}
	return _contentImageView;
}
@end





