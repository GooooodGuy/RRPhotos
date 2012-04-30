//
//  RNNewsFeedCell.m
//  RRPhotos
//
//  Created by yi chen on 12-3-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RNNewsFeedCell.h"
#import <QuartzCore/QuartzCore.h>

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

- (void)dealloc{
	self.newsFeedItem = nil;
	self.headImageView = nil;
	self.userNameLabel = nil;
	self.prefixLabel = nil;
	self.titleLabel = nil;
	self.updateTimeLabel = nil;
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
		if (self.newsFeedItem.title) {
			[prefixAndTitleString appendString:self.newsFeedItem.title];
		}
		self.prefixLabel.text  = prefixAndTitleString;
	}
		
	if (self.newsFeedItem.updateTime) {
		self.updateTimeLabel.text = [self.newsFeedItem.updateTime stringForSectionTitle3];
	}
	
	//新鲜事主体，照片附件,加载图片
	if (self.newsFeedItem.attachments) {	
		
		if ([self.newsFeedItem.attachments count] == 1) {
			CGRect r = 	self.attachmentsTableView.frame;
			self.attachmentsTableView.frame = CGRectMake(r.origin.x,r.origin.y, 320, 320);
		}else {
			CGRect r = 	self.attachmentsTableView.frame;
			self.attachmentsTableView.frame = CGRectMake(r.origin.x,
														 r.origin.y, 
														  kCellContentViewWidth, 
														  kCellContentViewHeight);
		}
		[self.attachmentsTableView reloadData];
		NSLog(@"附件的照片的数目1 = %d", [self.newsFeedItem.attachments count]);
	}
	[self.contentView removeAllSubviews];
	[self.contentView addSubview:self.userNameLabel];
	[self.contentView addSubview:self.headImageView];
	[self.contentView addSubview:self.prefixLabel];
	[self.contentView addSubview:self.updateTimeLabel];
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
		CALayer* layer = [_headImageView layer];
		[layer setCornerRadius:4.0];
		layer.masksToBounds = YES;
		
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UITableView *)attachmentsTableView{
	
	if (!_attachmentsTableView) {
		
		_attachmentsTableView = [[UITableView alloc]initWithFrame:CGRectMake(kCellHeadImageHeight + kCellTopPadding + kCellHeadContentSpace, 
																			 0,
																			 kCellContentViewHeight, 
																			 kCellContentViewWidth)
															style:UITableViewStylePlain];
		_attachmentsTableView.backgroundColor = [UIColor clearColor];
		_attachmentsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
	
	NSLog(@"附件的照片的数目2 = %d", [self.newsFeedItem.attachments count]);

	if (indexPath.row < [self.newsFeedItem.attachments count]) { //重新加载新鲜事的照片内容
		id attachment = [self.newsFeedItem.attachments objectAtIndex:indexPath.row];
		if (attachment && [attachment isKindOfClass:RRAttachment.class]) {
			NSURL *url = [NSURL URLWithString:[(RRAttachment*)attachment main_url]];
			[((RNAttachmentCell *)cell).contentImageView setImageWithURL:url];
			
			//仅有一张照片的时候高度做调整
			if ([self.newsFeedItem.attachments count] == 1) {
				CGRect r = 	((RNAttachmentCell *)cell).contentImageView.frame;
				((RNAttachmentCell *)cell).contentImageView.frame = CGRectMake(r.origin.x,r.origin.y, 320, 320);
			}else {
				((RNAttachmentCell *)cell).contentImageView.frame = CGRectMake(0, 
															 0,
															 kCellContentViewWidth / 3,  
															 kCellContentViewWidth / 3);
			}

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
	
	self.contentView.backgroundColor = [UIColor clearColor];
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
	CALayer* layer = [self.contentImageView layer];
	[layer setCornerRadius:6.0];
	layer.masksToBounds = YES;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
				
	}
	return self;
}

/*
	cell的主内容图片（带缓存自加载能力）
 */
- (UIImageView *)contentImageView{
	if (!_contentImageView) {
		_contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 
																		 0,
																		 kCellContentViewWidth / 3,  
																		 kCellContentViewWidth / 3)];
		_contentImageView.backgroundColor = [UIColor clearColor];
		CGRect r = _contentImageView.frame;
		
		NSLog(@"contentImageView---------------x = %f y = %f width = %f height = %f",r.origin.x,r.origin.y,r.size.width,r.size.height);
		_contentImageView.transform = CGAffineTransformRotate(self.transform,  M_PI / 2);
	}
	return _contentImageView;
}
@end





