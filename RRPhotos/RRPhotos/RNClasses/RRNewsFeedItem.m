//
//  RRNewsFeedItem.m
//  RRPhotos
//
//  Created by yi chen on 12-4-13.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RRNewsFeedItem.h"

@implementation RRNewsFeedItem

@synthesize feedId = _feedId;
@synthesize sourceId = _sourceId;
@synthesize feedType = _feedType;
@synthesize updateTime = _updateTime;
@synthesize userId = _userId;
@synthesize userName = _userName;
@synthesize headUrl = _headUrl;
@synthesize prefix = _prefix;
@synthesize content = _content;
@synthesize title = _title;
@synthesize titleUrl = _titleUrl;
@synthesize originType = _originType;
@synthesize originTitle = _originTitle;
@synthesize originIconUrl = _originIconUrl;
@synthesize originPageId = _originPageId;
@synthesize decription = _description;

- (void)dealloc{
	self.feedId = nil;
	self.sourceId = nil;
	//
	self.updateTime = nil;
	self.userId = nil;
	self.userName = nil;
	self.headUrl = nil;
	self.prefix = nil;
	self.content = nil;
	self.title = nil;
	self.titleUrl = nil;
	//
	self.originTitle = nil;
	self.originIconUrl = nil;
	self.originPageId = nil;
	self.decription = nil;
	
	[super dealloc];
}


+ (id)newsfeedWithDictionary:(NSDictionary*) dictionary{
	RRNewsfeedType myFeedType = [[dictionary objectForKey:@"type"] intValue];
	switch (myFeedType) {
		case RRItemTypeAlbumShared:
        case RRItemTypeAlbumSharedForPage:
		case RRItemTypePhotoShared:
		case RRItemTypePhotoUploadOne:
		case RRItemTypePhotoUploadMore: {
//			RRNewsfeedPhotoItem* newsfeed = [[[RRNewsfeedPhotoItem alloc] initWithDictionary:dictionary] autorelease];
//			return newsfeed;
		}
      
		default:
			
			break;
	}
	return nil;

}
@end


//////////////////////////////////////////////////////////////////////////////

@implementation RRNewsfeedPhotoItem
@synthesize aid;



@end

