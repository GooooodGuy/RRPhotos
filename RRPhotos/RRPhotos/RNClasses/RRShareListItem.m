//
//  RRShareListItem.m
//  xiaonei
//
//  Created by SunYu on 11-5-31.
//  Copyright 2011 renren.com. All rights reserved.
//

#import "RRShareListItem.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////

@implementation RRShareListItem
@synthesize userId = _userId;
@synthesize shareId = _shareId;

//@synthesize myshareType = _myshareType;
@synthesize commentCnt = _commentCnt;
@synthesize title = _title;
@synthesize updateTime = _updateTime;
@synthesize href = _href;
@synthesize ownerId = _ownerId;
@synthesize sourceID = _sourceID;
@synthesize videoUrl = _videoUrl;
@synthesize videoSupport = _videoSupport;
@synthesize shareOrFav = _shareOrFav;

- (void)dealloc{
	TT_RELEASE_SAFELY(_userId);
	TT_RELEASE_SAFELY(_shareId);

	TT_RELEASE_SAFELY(_commentCnt);
	TT_RELEASE_SAFELY(_title);
	TT_RELEASE_SAFELY(_updateTime);
	TT_RELEASE_SAFELY(_href);
	TT_RELEASE_SAFELY(_ownerId);
	TT_RELEASE_SAFELY(_sourceID);
	TT_RELEASE_SAFELY(_videoUrl);
	TT_RELEASE_SAFELY(_videoSupport);
    TT_RELEASE_SAFELY(_shareOrFav);
	[super dealloc];
}

+ (id)sharefeedWithDictionary:(NSDictionary*)dictionary{
	RRNewsfeedType sharetype = [[dictionary objectForKey:@"type"] intValue];
	switch (sharetype) {
	
		case RRItemTypeAlbumShared:
		case RRItemTypePhotoShared: //分享的照片和相册
			
		case RRItemTypePhotoUploadOne:
		case RRItemTypePhotoUploadMore://上传的单张和多张图片
			
        case RRItemTypeAlbumSharedForPage:
        case RRItemTypePhotoSharedForPage://公共主页
		case RRItemTypePhotoUploadForPage:
		{
			RRSharePhotoItem* sitem = [[[RRSharePhotoItem alloc] initWithDictionary:dictionary] autorelease];
			return sitem;
		}
			break;
		default:
			break;
	}
	return nil;
	
}

- (id)initWithDictionary:(NSDictionary*) dictionary
{
	if (self = [super init]) {
		self.shareId = [dictionary objectForKey:@"id"];
//		self.myshareType = [[dictionary objectForKey:@"type"] intValue];
		self.title = [dictionary objectForKey:@"title"];
		self.updateTime = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"time"] doubleValue]/1000];
		self.commentCnt = [dictionary objectForKey:@"comment_count"];
//		self.shareInfo = [RRShareInfo shareInfoWithDictionary:dictionary];
        
        self.ownerId = [dictionary objectForKey:@"source_owner_id"];
		self.sourceID = [dictionary objectForKey:@"source_id"];
	}
	
	return self;
}

- (NSString *)actionUrlGoCommentWithItem:(RRShareListItem*)sharefeed{
	NSString *url = @"";
	return url;
}
@end


@implementation RRSharePhotoItem

- (void)dealloc{
	[super dealloc];
}

- (NSString *)actionUrlGoCommentWithItem:(RRShareListItem*)sharefeed
{
    NSString* url = [NSString stringWithFormat:@"rr://shareCommentViewController?source_id=%@&amp;uid=%@&amp", 
				   sharefeed.shareId,
				   sharefeed.userId];
    return url;
}

- (id)initWithDictionary:(NSDictionary *)dictionary{
	if(self = [super initWithDictionary:dictionary]){
		self.href = [dictionary objectForKey:@"photo"];
	}
	return self;
}
@end

