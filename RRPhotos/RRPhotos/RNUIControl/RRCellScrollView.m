//
//  RRCellScrollView.m
//  RRPhotos
//
//  Created by yi chen on 12-3-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RRCellScrollView.h"

@implementation RRCellScrollView
@synthesize images = _images;
@synthesize selectedIndex = _selectedIndex;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		//　设置委托
		self.delegate = self; 
		
		// 是否按页滚动
		self.pagingEnabled = YES;
		
		// 背景色
		self.backgroundColor = [UIColor blackColor];
		// 滚动条颜色 因为背景为黑,所以用白色
		self.indicatorStyle = UIScrollViewIndicatorStyleWhite;
		
		//设置滚动内容的大小
		self.contentSize = CGSizeMake([self.images count]*IMAGE_WIDTH,IMAGE_HEIGHT);
		// 显示滚动条
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.canCancelContentTouches = NO;
		self.clipsToBounds = YES;
		
		//逐个添加图片
		int i = 0;
		for ( id obj in self.images) {
			if ([obj isKindOfClass: RRImageView.class ]) {
				RRImageView *currentImage = (RRImageView *) obj;
				currentImage.frame = CGRectMake(0, i * IMAGE_WIDTH, IMAGE_WIDTH, IMAGE_HEIGHT);//设置当前照片的位置
				[self addSubview: currentImage];//添加到视图
			}
			
			i ++;
		}
		
    }
	
	
	
    return self;
}

- (void)layoutSubviews{
	self.frame = self.bounds;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma -mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {


}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}


@end
