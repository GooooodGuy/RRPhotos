//
//  RNPickPhotoHelper.m
//  RRSpring
//
//  Created by yi chen on 12-3-31.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import "RNPickPhotoHelper.h"
#import "AppDelegate.h"
@implementation RNPickPhotoHelper

@synthesize imagePickerController = _imagePickerController;
@synthesize editPhotoController = _editPhotoController;
@synthesize sourceType = _sourceType;
@synthesize imageToReturn = _imageToReturn;
@synthesize photoInfoDic =_photoInfoDic;
@synthesize delegate = _delegate;
@synthesize parentViewContrller = _parentViewController;
- (void)dealloc{
	self.imagePickerController = nil;
	self.editPhotoController = nil;
	self.imageToReturn = nil;
	self.photoInfoDic = nil;
	self.delegate = nil;
	self.parentViewContrller = nil;
	
	[super dealloc];
}

- (id)init{
	if (self = [super init]) {
		self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//默认从照片库里面取
		_imagePickerController = [[UIImagePickerController alloc]init];
	}
	return  self;
}
 
 /**
 * uploadType :默认是普通照片上传
 */
- (id)initWithType: (PhotoUploadType)uploadType{
	
	if (self = [super init]) {
		self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//默认从照片库里面取
		_imagePickerController = [[UIImagePickerController alloc]init];
		_editPhotoController = [[RNEditPhotoViewController alloc]initWithType:uploadType];
	}
	return self;
}

- (id)initWithAlbumId:(NSString *)albumId withAlbumName:(NSString *)albumname{
    if (self = [super init]) {
		self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//默认从照片库里面取
		_imagePickerController = [[UIImagePickerController alloc]init];
		_editPhotoController = [[RNEditPhotoViewController alloc] initWithAlbumId:albumId withAlbumName:albumname];
	}
	return  self;
}

/**
 * 获取照片，数据通过回调传回
 */
- (void)pickPhotoWithSoureType:(UIImagePickerControllerSourceType) sourceType{
	self.sourceType = sourceType;
	if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
		
		self.imagePickerController.sourceType = self.sourceType;
		self.imagePickerController.delegate = self;
		
		AppDelegate *appDelegate = (AppDelegate *)[UIApplication 
												   sharedApplication].delegate;
		
		[appDelegate.rootNavController  presentModalViewController:self.imagePickerController  animated:YES];
	}
	
}
#pragma -mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	self.photoInfoDic = info;
	
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	if ([mediaType isEqualToString:@"public.image"])
	{
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		if(image){
			NSLog(@"found an image");
			RNEditPhotoViewController *editViewController = [[RNEditPhotoViewController alloc]init];
			self.editPhotoController = editViewController;
			TT_RELEASE_SAFELY(editViewController);
			
		    [_editPhotoController loadImageToEdit:image];//初始化编辑界面
			_editPhotoController.delegate = self; //设置代理
			[picker pushViewController:self.editPhotoController animated:YES];

		}
		
	}
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[picker dismissModalViewControllerAnimated:YES];

}	

#pragma -mark RNEditPhotoFinishDelegate
/**
 * 照片编辑完成回调
 */
- (void)editPhotoFinished:(UIImage *) imageEdited photoInfoDic: (NSDictionary * )photoInfoDic{
	self.imageToReturn = imageEdited;
	//
	[self.photoInfoDic setValuesForKeysWithDictionary:photoInfoDic];
	//回调传回数据
	[self.delegate pickPhotoFinished:self.imageToReturn photoInfoDic:self.photoInfoDic];
	
    
	[self.imagePickerController dismissModalViewControllerAnimated:YES];

}


@end
