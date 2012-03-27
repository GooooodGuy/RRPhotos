//
//  RRCellScrollView.h
//  RRPhotos
//
//  Created by yi chen on 12-3-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRImageView.h"
#define IMAGE_HEIGHT 100 //每个照片高度
#define IMAGE_WIDTH 100  //每个照片宽度

@interface RRCellScrollView : UIScrollView <UIScrollViewDelegate>
{	
	//图片容器
	NSMutableArray *_images;
	
	//当前选中的图片索引
	NSInteger _selectedIndex;
	

}
@property(nonatomic, retain) NSMutableArray *images;

@property(nonatomic, assign) NSInteger selectedIndex;
@end
