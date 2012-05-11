//
//  RNExploreViewController.h
//  RRPhotos
//
//  Created by yi chen on 12-5-11.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNModelViewController.h"

/*	-----------------------------------  */
/*			热门分享						 */
/*	-----------------------------------  */
@interface RNHotShareViewController : RNModelViewController
{
	//所有的照片数据
	NSMutableArray *_hotSharePhotoArray;
	
	//照片内容滚动视图
	UIScrollView *_contentScrollView;
}

@property(nonatomic,retain)NSMutableArray *hotSharePhotoArray;
@property(nonatomic,retain)UIScrollView *contentScrollView;
@end
