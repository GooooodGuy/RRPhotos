//
//  RNExploreViewController.m
//  RRPhotos
//
//  Created by yi chen on 12-5-11.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RNHotShareViewController.h"
#import "RNHotShareModel.h"
#import "UIImageView+RRWebImage.h"

#define kImageHeight 76.25
#define kImageWidth 76.25 //图片的宽高
#define kImageSpace 5.0  //图片间隙
@implementation RNHotShareViewController
@synthesize hotSharePhotoArray = _hotSharePhotoArray;
@synthesize contentScrollView = _contentScrollView;
- (void)dealloc{
	self.hotSharePhotoArray = nil;
	self.contentScrollView = nil;
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
	}
    return self;
}

/*
 重载父类的创建model
 */
- (void)createModel {
	NSString *typeString = @"8";//只请求与照片有关的数据
	
	//新鲜事类型
	RNHotShareModel *model = [[RNHotShareModel alloc]initWithTypeString:typeString];
	self.model = (RNModel *) model;
	[self.model load:YES];//加载数据
}


/*
	开始
 */
- (void)modelDidStartLoad:(RNModel *)model {

}

- (void)modelDidFinishLoad:(RNModel *)model{
	
	if (!_hotSharePhotoArray) {
		_hotSharePhotoArray = [[NSMutableArray alloc]initWithCapacity:kHotSharePhotoCountMax];
	}
	
	self.contentScrollView.contentSize = CGSizeMake(PHONE_SCREEN_SIZE.width, 
													(kHotSharePhotoCountMax / 4) * (kImageSpace + kImageHeight));
	[self.contentScrollView removeAllSubviews];
	NSArray *hotShareItems = ((RNHotShareModel *)model).hotShareItems;
	NSInteger photoIndex = 0;
	for(id item in hotShareItems){
		CGFloat currentY = 0;
		CGFloat currentX = 0;

		currentY = (kImageHeight + kImageSpace ) * (int) (photoIndex / 4);
		currentX = (photoIndex % 4) * (kImageSpace + kImageWidth);
		
		CGRect r = CGRectMake(currentX, currentY, kImageWidth, kImageHeight);
//		NSString *String = [NSString stringWithFormat:@"%@",r];
//		NSLog(@"照片的位置 currentX = %f currentY = %f r = %@",currentX,currentY,String);
		UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:r];
		if([item isKindOfClass:NSDictionary.class] ){
			NSURL *url = [NSURL URLWithString:[(NSDictionary *)item objectForKey:@"photo"]];
			[photoImageView setImageWithURL:url];
		}
		[self.contentScrollView addSubview:photoImageView];
		[photoImageView release];
		photoIndex ++;
	}
}
#pragma mark - view lifecycle
- (void)loadView{
	
	[super loadView];
	self.navBar.hidden = YES; //采用系统的navbar
	
	[self.view addSubview:self.contentScrollView];
}

- (void)viewDidLoad{
	
	[super viewDidLoad];
}

- (void)viewDidUnload{
	
	[super viewDidUnload];
	self.hotSharePhotoArray = nil;
	self.contentScrollView = nil;

}

- (UIScrollView *)contentScrollView {
	
	if (!_contentScrollView) {
		_contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,
																		  0,
																		  PHONE_SCREEN_SIZE.width, 
																		  PHONE_SCREEN_SIZE.height)];
		_contentScrollView.backgroundColor = [UIColor redColor];
		
	}
	
	return  _contentScrollView;
}

@end
