//
//  RRShareListItem.h
//  xiaonei
//
//  Created by SunYu on 11-5-31.
//  Copyright 2011 renren.com. All rights reserved.
//
#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

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

@interface RRShareListItem :NSObject {
	NSNumber * _userId;//个人主页者的id
	NSNumber * _shareId;//分享或收藏的id

//	RRMyShareType _myshareType;//　分享或收藏的类型
	NSString* _commentCnt;//　评论数
	NSString* _title;//　分享收藏的title
	NSDate* _updateTime;//　时间
	NSString* _href;//　图片连接
	NSNumber* _ownerId;//　分享或收藏源作者的id
	NSNumber* _sourceID;//　分享或收藏源id
	NSString* _videoSupport;//是否是可支持播放的video
	NSString* _videoUrl;//　视频url
    
    NSString* _shareOrFav;//　分享为０，收藏为１
}
@property (nonatomic, copy) NSNumber* userId;
@property (nonatomic, copy) NSNumber* shareId;

//@property RRMyShareType myshareType;
@property (nonatomic, copy) NSString* commentCnt;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, retain) NSDate* updateTime;
@property (nonatomic, copy) NSString* href;
@property (nonatomic, copy) NSNumber* ownerId;
@property (nonatomic, copy) NSNumber* sourceID;
@property (nonatomic, copy) NSString* videoSupport;
@property (nonatomic, copy) NSString* videoUrl;
@property (nonatomic, copy) NSString* shareOrFav;

+ (id)sharefeedWithDictionary:(NSDictionary*)dictionary;
- (NSString *)actionUrlGoCommentWithItem:(RRShareListItem*)sharefeed;
@end



//photo share
@interface RRSharePhotoItem : RRShareListItem {
	
}
- (id)initWithDictionary:(NSDictionary*) dictionary;
@end



