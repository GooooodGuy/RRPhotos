//
//  RRNewsFeedItem.h
//  RRPhotos
//
//  Created by yi chen on 12-4-13.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>


///新鲜事的类型
#define ITEM_TYPES_NEWSFEED_FOR_PAGE	@"2002,2003,2004,2005,2006,2008,2009,2012,2013,2015"
#define ITEM_TYPES_NEWSFEED_FOR_USER	@"102,103,104,107,110,501,502,601,701,709,1101,1104,2002,2003,2004,2005,2006,2008,2009,2012,2013,2015,8001,8002,8003,8004"

typedef enum {
    
	RRItemTypeHeadUpdated =                 501, // head updated	
	RRItemTypeStatusUpdated =				502, // status updated
	
	RRItemTypeBlogShared =					102, // blog shared
	RRItemTypePhotoShared =					103, // photo shared
	RRItemTypeAlbumShared =					104, // album shared
    RRItemTypeLinkShared =                  107, // link shared
	RRItemTypeVideoShared =                 110, // video shared
    
    RRItemTypeBlogPublish =					601, // blog publish
    RRItemTypePhotoUploadOne =				701, // a photo upload 
	RRItemTypePhotoUploadMore =				709, // more photo upload
    
    RRItemTypePageJoin =                    2002, // page join
    RRItemTypeBlogSharedForPage =			2003, // blog shared for page
    RRItemTypePhotoSharedForPage =          2004, // photo shared for page
    RRItemTypeLinkSharedForPage =           2005, // link shared for page
	RRItemTypeVideoSharedForPage =          2006, // video shared for page
	RRItemTypeStatusUpdatedForPage =		2008, // status updated for page
    RRItemTypeAlbumSharedForPage =          2009, // share album for page
	RRItemTypeBlogPublishForPage =			2012, // blog publish for page
	RRItemTypePhotoUploadForPage =			2013, // photo upload for page
	RRItemTypePageHeadPhotoUpdate =         2015, // Page Head Photo Update
	
	RRItemTypeCheckIn =                     1101, // check in
	RRItemTypeCommentPlace =                1104, // place comment
    
    RRItemTypeOthersText =                  8001, //非常规新鲜事类型的对象数据：置顶新鲜事。。等
    RRItemTypeOthersPhoto =                 8002,
    RRItemTypeOthersVideo =                 8003,
    RRItemTypeOthersFlash =                 8004
	
} RRNewsfeedType;

@interface RRNewsFeedItem : NSObject
{
	//新鲜事的id
	NSNumber *_feedId;
	
	//新鲜事主体内容的id 例如日志 、相册、分享 id 等等
	NSNumber *_sourceId;
	
	//新鲜事类型
	RRNewsfeedType _feedType;
	
	//新鲜事的更新事件
	NSDate *_updateTime;
	
	//新鲜事用户的id
	NSNumber *_userId;
	
	//新鲜事用户的名字
	NSString *_userName;
	
	//新鲜事的用户头像的url
	NSString *_headUrl;
	
	//新鲜事的内容前缀
	NSString *_prefix;
	
	//新鲜事用户的自定义输入内容状态
	NSString *_content;
	
	//新鲜事主体内容
	NSString *_title;
	
	//新鲜事主体的相关链接url
	NSString *_titleUrl;
	
	//新鲜事来源的类型
	NSNumber *_originType;
	
	//新鲜事来源描述
	NSString *_originTitle;
	
	//新鲜事来源的图标地址
	NSString *_originIconUrl;
	
	//表示新鲜事来源pageid
	NSNumber *_originPageId;
	
	//表示新鲜事的具体内容 如日志内容	
	NSString *_description;
	
}

@property(nonatomic,copy)NSNumber *feedId;
@property(nonatomic,copy)NSNumber *sourceId;
@property(nonatomic,assign)RRNewsfeedType feedType;
@property(nonatomic,retain)NSDate *updateTime;
@property(nonatomic,copy)NSNumber *userId;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *headUrl;
@property(nonatomic,copy)NSString *prefix;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *titleUrl;
@property(nonatomic,copy)NSNumber *originType;
@property(nonatomic,copy)NSString *originTitle;
@property(nonatomic,copy)NSString *originIconUrl;
@property(nonatomic,copy)NSNumber *originPageId;
@property(nonatomic,copy)NSString *decription;

@end

//照片新鲜事
@interface RRNewsfeedPhotoItem : RRNewsFeedItem {
	
}
- (id)initWithPlaceDictionary:(NSDictionary*) dictionary;
//hzhang modify retian to copy
@property (nonatomic, copy)NSNumber *aid;
@end
